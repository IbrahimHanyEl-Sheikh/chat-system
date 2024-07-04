class CreateMessagesJob
  include Sidekiq::Job

  def perform(token, chat_number, message_number, body)
    Rails.logger.info("Application Token: #{token}")
    Rails.logger.info("chat_number: #{chat_number}")
    Rails.logger.info("message_number: #{message_number}")
    Rails.logger.info("message_body: #{body}")
    @application = Application.find_by(token: token)
    @chat = @application.chats.find_by(number: chat_number, application_token: @application.token) if @application
    @message = @chat.messages.new(number: message_number, body: body) if @chat

    @chat.with_lock do
      if @message.save
        @chat.increment!(:msgs_count)
        if @chat.save
          Rails.logger.info("update msgs_count for chat: #{chat_number} to be: #{@chat.msgs_count}")
        else
          Rails.logger.error("Failed to update the chat: #{@chat.errors.full_messages.join(", ")}")
        end
        Rails.logger.info("added new message with number: #{message_number} IN chat number: #{chat_number} IN Application: #{token}")
      else
          Rails.logger.error("Failed to create chat: #{@chat.errors.full_messages.join(", ")}")
      end
    end
  end
end
