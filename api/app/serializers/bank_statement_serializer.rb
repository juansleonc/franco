class BankStatementSerializer < ActiveModel::Serializer
  attributes :id, :account, :statement_on, :original_filename, :created_at
end
