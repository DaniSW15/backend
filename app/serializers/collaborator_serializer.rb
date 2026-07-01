class CollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :rfc, :fiscal_address, :curp,
             :social_security_number, :start_date, :contract_type,
             :department, :position, :daily_salary, :salary,
             :entity_key, :state, :created_at, :updated_at
  
  belongs_to :user
end