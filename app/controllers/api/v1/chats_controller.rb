class Api::V1::ChatsController < ApplicationController
  before_action :set_application, only: [:create, :show, :index]
  before_action :set_chat, only: [:show]

  # GET /chats
  def index
    @chats = @application.chats
    render json: @chats,  :except=> [:id, :application_id]
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
		chat_number = generate_chat_number(@application.token)
		chat = @application.chats.new(number: chat_number,application_token: @application.token)

		if chat.save
			render json: chat, status: :created
		else
			render json: chat.errors, status: :bad_request
		end
	end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by(token: params[:application_token])
      unless @application
        return render(json: { "error": 'Application not Found' }, status: :not_found)
      end
      puts "application founded"
    end

    def set_chat
      @chat = @application.chats.find_by(number: params[:number]) if @application
      unless @chat
        render json: { error: "Chat not found" }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:number)
    end
end
