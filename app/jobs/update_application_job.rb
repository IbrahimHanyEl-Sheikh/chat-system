class UpdateApplicationJob
  include Sidekiq::Job

  def perform(token, name)
    Rails.logger.info("Application token: #{token}")
    @application = Application.find_by(token: token)
    @application.with_lock do
        if @application.update(name: name)
            Rails.logger.info("Application #{name} is updated successfully")
        else
            Rails.logger.error("Failed to update app: #{name} due to: #{@message.errors.full_messages.join(", ")}")
        end
    end
  end
end
