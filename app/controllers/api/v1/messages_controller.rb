class Api::V1::MessagesController < ApplicationController
  before_action :set_application, :set_chat, only: [:create, :index, :show, :search, :update, :destroy]
  before_action :set_message, only: [:show, :update, :destroy]

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
    @result = Message.search(params[:body], where: {chat_id: @chat.id},fields: [:body], match: :text_middle)
    # this will return all result match query but there is drawback it check if match message contain query
    # or contain query length-1
    # example
    # have list ["hello 8", "hello 88", "hello 888"]
    # if we add in query 88 actual result => ["hello 8", "hello 88"] expected => ["hello 88"]
    # if query 888 result => ["hello 88", "hello 888"] expected ["hello 888"]
    # so we need to add filter

    # Filter and prepare the response
    matched_messages = @result.map do |message|
      if message.body.include?(params[:body])
        {
          number: message.number,
          body: message.body,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      end
    end.compact # Remove nil values from the array
    render json: matched_messages, status: :ok
  end

  # POST /messages
  def create
		message_number = generate_message_number(@chat.number, params[:application_token])
    message = @chat.messages.new(number: message_number, body: params[:body], chat_id: @chat.id)
    if message.valid?
      CreateMessagesJob.perform_async(@application.token, @chat.number, message_number, params[:body])
      render json: message, :except=>[:id, :created_at, :updated_at, :chat_id], status: :created
    else
      render json: message.errors, status: :bad_request
    end
	end

  # PATCH/PUT /messages/1
  def update
    if @message
     UpdateMessageJob.perform_async(@application.token, @chat.number, params[:number], params[:body])
     render json: {status: "message body for message number: #{@message.number} updated."}, status: :ok
    else
      render json: { error: "message not found" }, status: :not_found
    end
  end

  # DELETE /messages/1
  def destroy
    @message.with_lock do
      @message.destroy!
    end
    @chat.with_lock do
      @chat.decrement!(:msgs_count)
    end
    render json: {"status": "message deleted successfully"}, status: :ok
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
