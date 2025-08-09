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
      # Minimal stub: create a BankStatement record capturing filename
      statement = BankStatement.new(account: "default", statement_on: Date.today,
                                    original_filename: file.respond_to?(:original_filename) ? file.original_filename : "upload")
      statement.imported_by_user = current_user
      if statement.save
        render json: { data: BankStatementSerializer.new(statement) }, status: :created
      else
        render_errors(statement.errors.full_messages)
      end
    end
  end
end
