namespace :import do
  desc "Import suppliers from docs XLSX (BASE DE DATOS  PROVEEDORES.xlsx)"
  task suppliers: :environment do
    require 'roo'
    # In dev Docker, mount docs into /app/docs by adding a volume, fallback to host path when running locally
    candidates = [ Rails.root.join('docs', 'BASE DE DATOS  PROVEEDORES.xlsx'), Rails.root.join('..', 'docs', 'BASE DE DATOS  PROVEEDORES.xlsx') ]
    path = candidates.find { |p| File.exist?(p) }
    unless File.exist?(path)
      puts "File not found: #{path}"
      exit 1
    end
    xlsx = Roo::Spreadsheet.open(path.to_s)
    sheet = xlsx.sheet(0)

    # Find header row heuristically in first 10 rows
    header_row_idx = nil
    header = nil
    (1..[20, sheet.last_row].min).each do |i|
      row = sheet.row(i).map { |h| h.to_s.strip.downcase }
      next if row.compact.empty?
      if row.any? { |c| c =~ /(correo|email|mail)/ } && row.any? { |c| c =~ /(nombre|name|razon|razón|proveedor)/ } && row.any? { |c| c =~ /(ruc|nit|tax|cedula|c[eé]dula|dni)/ }
        header_row_idx = i
        header = row
        break
      end
    end
    header ||= sheet.row(1).map { |h| h.to_s.strip.downcase }
    header_row_idx ||= 1

    # Map columns with flexible matching
    find_index = ->(patterns) { header&.find_index { |h| patterns.any? { |p| h.include?(p) } } }
    email_idx = find_index.call(["correo electronico", "correo", "email", "mail", "e-mail"]) || find_index.call(%w[corr correo email mail e-mail])
    name_idx  = find_index.call(["nombre proveedor", "proveedor", "nombre"]) || find_index.call(%w[nombre name razon razón proveedor])
    tax_idx   = find_index.call(%w[ruc nit tax tax_id tax id cedula cédula dni documento doc])

    puts "Header(#{header_row_idx}): #{header.inspect}"
    puts "Detected idx => name: #{name_idx}, email: #{email_idx}, tax: #{tax_idx}"

    admin = User.first || User.create!(email: 'admin@example.com', password: 'Password123!', password_confirmation: 'Password123!', role: :admin)
    imported = 0
    start_row = header_row_idx + 1
    imported = 0
    skipped = 0
    (start_row..sheet.last_row).each do |i|
      row = sheet.row(i)
      email = email_idx ? row[email_idx].to_s.strip : nil
      name = name_idx ? row[name_idx].to_s.strip : nil
      tax = tax_idx ? row[tax_idx].to_s.strip : (name.present? ? name.parameterize.upcase : nil)
      if name.blank? && email.blank? && tax.blank?
        next
      end
      if name.blank? || email.blank? || tax.blank?
        skipped += 1
        next
      end
      s = Supplier.find_or_initialize_by(tax_id: tax)
      s.name = name
      s.email = email
      s.created_by_user ||= admin
      if s.save
        imported += 1
      else
        puts "Row #{i} skipped: #{s.errors.full_messages.join(', ')}"
        skipped += 1
      end
    end
    puts "Imported suppliers: #{imported}, skipped: #{skipped}"
  end
end
