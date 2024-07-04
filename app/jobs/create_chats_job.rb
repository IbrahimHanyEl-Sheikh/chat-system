class CreateChatsJob
  include Sidekiq::Job

  def perform(token, chat_number)
    Rails.logger.info("Application Token: #{token}")
    Rails.logger.info("chat_number: #{chat_number}")
    @application = Application.find_by(token: token)
    # to avoid race condition will lock application until add new chat and update counter
    @chat = @application.chats.new(number: chat_number, application_token: @application.token)
    @application.with_lock do
      if @chat.save
        @application.increment!(:chats_count)
        if @application.save
          Rails.logger.info("update chats_count for application: #{token} to be: #{@application.chats_count}")
        else
          Rails.logger.error("Failed to update application: #{@application.errors.full_messages.join(", ")}")
        end
        Rails.logger.info("added new chat with number: #{chat_number} IN Application: #{token}")
      else
        Rails.logger.error("Failed to create chat: #{@chat.errors.full_messages.join(", ")}")
      end
    end
  end
end
