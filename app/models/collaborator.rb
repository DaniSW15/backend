class Collaborator < ApplicationRecord
  belongs_to :user

  # Encriptación determinista para permitir búsquedas y validación
  encrypts :social_security_number, :curp, :rfc, deterministic: true

  validates :name, :email, :rfc, :fiscal_address, :curp, :social_security_number, :start_date, :contract_type, :department, :position, :daily_salary, :salary, :entity_key, :state, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rfc, format: { with: /\A[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}\z/i }
  validates :curp, length: { is: 18 }
  validates :salary, :daily_salary, numericality: { greater_than: 0 }

  MEXICAN_STATES = [
    "Aguascalientes", "Baja California", "Baja California Sur", "Campeche",
    "Chiapas", "Chihuahua", "Coahuila", "Colima", "Durango", "Estado de México",
    "Guanajuato", "Guerrero", "Hidalgo", "Jalisco", "Michoacán", "Morelos",
    "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo",
    "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala",
    "Veracruz", "Yucatán", "Zacatecas", "Ciudad de México"
  ].freeze

  validates :state, inclusion: { in: MEXICAN_STATES }
end
