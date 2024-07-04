# require 'sidekiq'
class CreateApplicationsJob
  include Sidekiq::Job

  def perform(token, name)
    @application = Application.new(token: token, name: name)
    @application.save
    $redis.set("application_Token_#{token}_chat_number", 1)
    if @application.save
      Rails.logger.info("set new counter in redis to handle the chat number: Application_token_#{token}_chat_number")
      $redis.set("Application_token_#{token}_chat_number", 1)
    else
        Rails.logger.error("Failed to create Application: #{@application.errors.full_messages.join(", ")}")
    end
  end
end
