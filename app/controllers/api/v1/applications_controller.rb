# app/controllers/api/v1/applications_controller.rb
class Api::V1::ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update]

  # GET /api/v1/applications
  def index
    @applications = Application.all.as_json(except: [:id])
    render json: @applications
  end

  # GET /api/v1/applications/:token
  def show
    render json: @application
  end

  # POST /api/v1/applications
  def create
    @application = Application.new(application_params)
    if @application.save
      render json: @application.as_json(except: [:id]), status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/applications/:token
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private

  # Find application by token
  def set_application
    @application = Application.find_by(token: params[:token]).as_json(:except => [:id])
    unless @application
      render json: { error: "Application not found" }, status: :not_found
    end
  end

  # Permit only the name parameter for update
  def application_params
    params.require(:application).permit(:name)
  end
end
