class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :rfc, :role, :address, :phone, :website, :creator_id, :created_at, :updated_at
end
