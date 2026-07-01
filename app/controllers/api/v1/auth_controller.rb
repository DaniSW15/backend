module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user, only: [:register, :login, :forgot_password]
      
      # Registro
      def register
        user = User.new(user_params)
        user.role = 'user' # Por defecto, rol regular
        
        # Si es el primer usuario, lo hacemos administrador
        if User.count == 0
          user.role = 'admin'
        end
        
        if user.save
          session = user.sessions.create!(active: true)
          token = user.generate_jwt(session.id)
          
          render json: {
            user: UserSerializer.new(user),
            token: token,
            session_id: session.id
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # Login
      def login
        user = User.find_by(email: params[:email]&.downcase&.strip)
        
        if user&.authenticate(params[:password])
          # Invalidar sesiones anteriores (una sola sesión activa a la vez)
          user.sessions.active.update_all(active: false)
          
          session = user.sessions.create!(active: true)
          token = user.generate_jwt(session.id)
          
          render json: {
            user: UserSerializer.new(user),
            token: token,
            session_id: session.id
          }, status: :ok
        else
          render json: { error: 'Los valores introducidos no coinciden con los registros en el sistema' }, status: :unauthorized
        end
      end
      
      # Logout
      def logout
        if current_session
          current_session.invalidate!
          render json: { message: 'Sesión cerrada exitosamente' }, status: :ok
        else
          render json: { error: 'Sesión no encontrada' }, status: :not_found
        end
      end
      
      # Actualizar contraseña
      def update_password
        if current_user.authenticate(params[:current_password])
          if params[:new_password] == params[:password_confirmation]
            if current_user.update(password: params[:new_password])
              # Invalidar todas las sesiones
              current_user.sessions.active.update_all(active: false)
              
              # Crear nueva sesión para que el usuario no sea deslogueado inmediatamente
              session = current_user.sessions.create!(active: true)
              token = current_user.generate_jwt(session.id)
              
              render json: {
                message: 'Contraseña actualizada exitosamente',
                token: token,
                session_id: session.id
              }, status: :ok
            else
              render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
            end
          else
            render json: { error: 'La confirmación del password no coincide' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Contraseña actual incorrecta' }, status: :unauthorized
        end
      end
      
      # Recuperar contraseña (por email y RFC)
      def forgot_password
        user = User.find_by(email: params[:email]&.downcase&.strip)
        
        if user && user.rfc == params[:rfc]&.upcase&.strip
          if params[:new_password].present? && params[:new_password] == params[:password_confirmation]
            if user.update(password: params[:new_password])
              # Invalidar todas las sesiones
              user.sessions.active.update_all(active: false)
              render json: { message: 'Contraseña restablecida exitosamente' }, status: :ok
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
          else
            render json: { error: 'La confirmación del password no coincide' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Los valores introducidos no coinciden con los registros en el sistema' }, status: :not_found
        end
      end
      
      private
      
      def user_params
        params.require(:user).permit(:name, :email, :rfc, :password, :password_confirmation, :address, :phone, :website)
      end
    end
  end
end