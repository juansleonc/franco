require 'csv'
require 'json-schema'

module Suppliers
  class CsvImporter
    ImportResult = Struct.new(:imported, :rejected, :errors, keyword_init: true)

    def initialize(current_user:, schema_path: Rails.root.join('schemas', 'supplier.schema.json'))
      @current_user = current_user
      @schema = JSON.parse(File.read(schema_path))
    end

    def call(io:, dry_run: true)
      imported = 0
      errors = []

      CSV.new(io, headers: true).each_with_index do |row, idx|
        attrs = normalize_row(row.to_h)
        unless JSON::Validator.validate(@schema, attrs)
          errors << { row: idx + 2, error: 'schema_validation_failed', details: JSON::Validator.fully_validate(@schema, attrs) }
          next
        end
        supplier = Supplier.new(
          name: attrs['legalName'],
          tax_id: attrs['taxId'],
          email: attrs['email'],
          phone: attrs['phone'],
          created_by_user: @current_user
        )
        if supplier.valid?
          imported += 1
          supplier.save! unless dry_run
        else
          errors << { row: idx + 2, error: 'model_validation_failed', details: supplier.errors.full_messages }
        end
      end

      ImportResult.new(imported: imported, rejected: errors.size, errors: errors)
    end

    private

    def normalize_row(row)
      # map potential CSV headers to schema fields
      {
        'id' => row['id'] || SecureRandom.uuid,
        'legalName' => row['legalName'] || row['name'] || row['Nombre'] || row['NOMBRE'],
        'taxId' => row['taxId'] || row['tax_id'] || row['RUC'] || row['NIT'],
        'email' => row['email'] || row['Email'] || row['EMAIL'],
        'phone' => row['phone'] || row['Phone'] || row['TELEFONO']
      }.compact
    end
  end
end
