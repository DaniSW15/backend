module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [ :show, :update, :destroy ]

      # GET /v1/employees
      def index
        employees = current_user.collaborators
        render json: employees
      end

      # GET /v1/employees/:id
      def show
        render json: @employee
      end

      # POST /v1/employees
      def create
        employee = current_user.collaborators.build(employee_params)

        if employee.save
          render json: employee, status: :created
        else
          render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /v1/employees/:id
      def update
        if @employee.update(employee_params)
          render json: @employee, status: :ok
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /v1/employees/:id
      def destroy
        @employee.destroy
        head :no_content
      end

      # GET /v1/employees/states
      def states
        render json: { states: Collaborator::MEXICAN_STATES }
      end

      private

      def set_employee
        @employee = current_user.collaborators.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :name, :email, :rfc, :fiscal_address, :curp,
          :social_security_number, :start_date, :contract_type,
          :department, :position, :daily_salary, :salary,
          :entity_key, :state
        )
      end
    end
  end
end
