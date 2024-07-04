class UpdateMessageJob
  include Sidekiq::Job

  def perform(token, chat_number, message_number, body)
    Rails.logger.info("Application Token: #{token}")
    Rails.logger.info("chat_number: #{chat_number}")
    Rails.logger.info("message_number: #{message_number}")
    Rails.logger.info("message_body: #{body}")
    @application = Application.find_by(token: token)
    @chat = @application.chats.find_by(number: chat_number, application_token: @application.token) if @application
    @message = @chat.messages.find_by(number: message_number) if @chat

    @message.with_lock do
      if @message.update(body: body)
        Rails.logger.info("update message body for message number: #{message_number} IN
        chat number: #{chat_number} IN Application: #{token}")
      else
        Rails.logger.error("Failed to update message body for message number: #{message_number} due to: #{@message.errors.full_messages.join(", ")}")

      end
    end
  end
end
