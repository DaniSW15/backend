class User < ApplicationRecord
    has_secure_password

    # Encriptación determinista para permitir búsquedas únicas
    encrypts :rfc, deterministic: true

    # Validaciones
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :rfc, presence: true, uniqueness: true, format: { with: /\A[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}\z/i }
    validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
    validates :role, inclusion: { in: [ "admin", "user" ] }

    # Campos opcionales para usuario administrador, pero requeridos para sub-usuarios creados
    validates :address, :phone, :website, presence: true, if: -> { creator_id.present? }

    has_many :sessions, dependent: :destroy
    has_many :collaborators, dependent: :destroy
    has_many :created_users, class_name: "User", foreign_key: "creator_id", dependent: :nullify
    belongs_to :creator, class_name: "User", optional: true

    before_save :normalize_rfc
    before_save :normalize_email
    before_validation :set_default_role, on: :create

    def admin?
        role == "admin"
    end

    def generate_jwt(session_id)
        JWT.encode(
          {
            user_id: id,
            email: email,
            session_id: session_id,
            exp: 24.hours.from_now.to_i
          }, Rails.application.secret_key_base, "HS256")
    end

    private

    def set_default_role
        self.role = User.count == 0 ? "admin" : "user"
    end

    def normalize_rfc
        self.rfc = rfc.upcase.strip if rfc.present?
    end

    def normalize_email
        self.email = email.downcase.strip if email.present?
    end

    def password_required?
        new_record? || password_digest_changed?
    end
end
