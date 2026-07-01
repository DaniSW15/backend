class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  
  before_action :authenticate_user
  attr_reader :current_user, :current_session
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :bad_request
  
  private
  
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    
    unless token
      return render json: { error: 'Token no proporcionado' }, status: :unauthorized
    end
    
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      user_id = decoded.first['user_id']
      session_id = decoded.first['session_id']
      
      @current_user = User.find(user_id)
      @current_session = @current_user.sessions.active.find_by(id: session_id)
      
      unless @current_session
        return render json: { error: 'Sesión expirada o inválida' }, status: :unauthorized
      end
    rescue JWT::ExpiredSignature
      return render json: { error: 'Token expirado' }, status: :unauthorized
    rescue JWT::DecodeError
      return render json: { error: 'Token inválido' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      return render json: { error: 'Usuario no encontrado' }, status: :unauthorized
    end
  end
  
  def authorize_admin!
    unless @current_user.admin?
      render json: { error: 'Acceso denegado' }, status: :forbidden
    end
  end
  
  def not_found
    render json: { error: 'Recurso no encontrado' }, status: :not_found
  end
  
  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
  
  def bad_request
    render json: { error: 'Parámetros inválidos' }, status: :bad_request
  end
  
  def forbidden
    render json: { error: 'No tienes permisos para esta acción' }, status: :forbidden
  end
end