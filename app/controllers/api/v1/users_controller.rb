module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [ :show, :update, :destroy ]

      # GET /v1/users
      def index
        # Retornar los usuarios creados por el usuario actual
        users = current_user.created_users
        render json: users
      end

      # GET /v1/users/:id
      def show
        render json: @user
      end

      # GET /v1/users/me
      def me
        render json: current_user
      end

      # POST /v1/users
      def create
        user = current_user.created_users.build(user_params)
        user.role = "user" # Los usuarios creados son de rol regular

        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /v1/users/:id
      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        # Permitir ver/editar si es el mismo usuario (para configuración de cuenta)
        # o si fue creado por el usuario actual
        if params[:id] == "me"
          @user = current_user
        else
          @user = User.find(params[:id])
          unless @user == current_user || @user.creator_id == current_user.id
            render json: { error: "No autorizado para acceder a este usuario" }, status: :forbidden
          end
        end
      end

      def user_params
        # Permitir email, password y password_confirmation para poder crear/registrar nuevos usuarios
        params.require(:user).permit(:name, :email, :rfc, :password, :password_confirmation, :address, :phone, :website)
      end
    end
  end
end
