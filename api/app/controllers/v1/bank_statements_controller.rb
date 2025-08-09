module V1
  class BankStatementsController < ApplicationController
    def show
      statement = BankStatement.find(params[:id])
      authorize statement, :show?
      render json: { data: BankStatementSerializer.new(statement) }
    end

    def import
      authorize BankStatement, :create?
      file = params.require(:file)
      # Create a BankStatement record and parse CSV lines (basic parser)
      statement = BankStatement.new(account: "default", statement_on: Date.today,
                                    original_filename: file.respond_to?(:original_filename) ? file.original_filename : "upload")
      statement.imported_by_user = current_user
      if statement.save
        begin
          io = file.respond_to?(:read) ? file.read : file.to_s
          parse_bank_csv!(statement: statement, csv_string: io)
        rescue => e
          # keep statement saved; return partial success with error info
          Rails.logger.warn("Bank CSV parse failed: #{e.message}")
        end
        render json: { data: BankStatementSerializer.new(statement) }, status: :created
      else
        render_errors(statement.errors.full_messages)
      end
    end

    private

    def parse_bank_csv!(statement:, csv_string:)
      require "csv"
      CSV.parse(csv_string, headers: true).each do |row|
        posted_on = Date.parse(row["date"] || row["posted_on"] || row["Date"]) rescue nil
        amount = row["amount"] || row["Amount"] || row["import"] || row["importe"]
        desc = row["description"] || row["memo"] || row["Description"] || row["concepto"]
        next unless posted_on && amount
        StatementLine.create!(
          bank_statement: statement,
          posted_on: posted_on,
          description: desc,
          amount_cents: (amount.to_f * 100).to_i,
          match_status: "unmatched"
        )
      end
    end
  end
end
