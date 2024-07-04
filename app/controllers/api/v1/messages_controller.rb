class Api::V1::MessagesController < ApplicationController
  before_action :set_application, :set_chat, only: [:create, :index, :show, :search]
  before_action :set_message, only: [:show]

  # GET /messages
  def index
    @messages = @chat.messages
    render json: @messages, :except=> [:id, :chat_id]
  end

  # GET /messages/1
	def show
    render json: @message, :except=> [:id, :chat_id]
	end

  # GET /messages/search
  def search
    @result = Message.search(params[:body], fields: [:body], match: :text_middle)
    render json: @result, :except=> [:id, :chat_id], status: :ok
  end

  # POST /messages
  def create
		message_number = generate_message_number(@chat.number, params[:application_token])
		message = Message.new(message_params)
        message.number = message_number
        message.chat = @chat

		if message.save
			render json: message, status: :created
		else
			render json: message.errors, status: :bad_request
		end
	end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by("token": params[:application_token])
    unless @application
      render json: { error: "Application not found" }, status: :not_found
    end
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:chat_number]) if @application
    unless @chat
      render json: { error: "chat not found" }, status: :not_found
    end
  end

  def set_message
    @message = @chat.messages.find_by(number: params[:number]) if @chat
    unless @message
      render json: { error: "message not found" }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:body)
  end
end
