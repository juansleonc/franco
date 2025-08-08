require "csv"
require "json-schema"

module Suppliers
  class CsvImporter
    ImportResult = Struct.new(:imported, :rejected, :errors, :error_csv, keyword_init: true)

    def initialize(current_user:, schema_path: Rails.root.join("schemas", "supplier.schema.json"))
      @current_user = current_user
      @schema = JSON.parse(File.read(schema_path))
      # json-schema gem cannot fetch remote metaschemas in offline/test; disable metaschema validation
      @schema.delete("$schema")
    end

    def call(io:, dry_run: true, col_sep: ",", generate_error_csv: false)
      imported = 0
      errors = []

      csv = CSV.new(io, headers: true, col_sep: col_sep)
      csv.each_with_index do |row, idx|
        attrs = normalize_row(row.to_h)
        unless JSON::Validator.validate(@schema, attrs, validate_schema: false)
          errors << { row: idx + 2, error: "schema_validation_failed", details: JSON::Validator.fully_validate(@schema, attrs, validate_schema: false) }
          next
        end

        supplier = Supplier.find_or_initialize_by(tax_id: attrs["taxId"])
        supplier.assign_attributes(
          name: attrs["legalName"],
          email: attrs["email"],
          phone: attrs["phone"],
          created_by_user: supplier.created_by_user || @current_user
        )

        if supplier.valid?
          imported += 1
          supplier.save! unless dry_run
        else
          errors << { row: idx + 2, error: "model_validation_failed", details: supplier.errors.full_messages }
        end
      end

      error_csv_str = nil
      if generate_error_csv && errors.any?
        error_csv_str = CSV.generate do |csv_out|
          csv_out << %w[row error details]
          errors.each { |e| csv_out << [ e[:row], e[:error], Array(e[:details]).join("; ") ] }
        end
      end

      ImportResult.new(imported: imported, rejected: errors.size, errors: errors, error_csv: error_csv_str)
    end

    private

    def normalize_row(row)
      {
        "id" => row["id"] || SecureRandom.uuid,
        "legalName" => first_present(row, %w[legalName name Nombre NOMBRE]),
        "taxId" => first_present(row, %w[taxId tax_id RUC NIT]),
        "email" => first_present(row, %w[email Email EMAIL]),
        "phone" => first_present(row, %w[phone Phone TELEFONO])
      }.compact
    end

    def first_present(row, keys)
      keys.map { |k| row[k] }.find { |v| v.present? }
    end
  end
end
