require 'redis'
redis_config = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }

begin
  $redis = Redis.new(redis_config)
rescue Exception => e
  puts e
end

begin
  $redis_lock = Redlock::Client.new([ENV.fetch("REDIS_LOCK_URL") { "redis://localhost:6379/1" }])
rescue Exception => e
  puts e
end

# method to generate chat_number using redis
def generate_chat_number(application_token)
  # Construct a unique Redis key for storing chat numbers for each application
  redis_key = "chat_number_application_token_#{application_token}"

  $redis_lock.lock(redis_key, 2000) do |locked|
    chat_number = $redis.get(redis_key)
    $redis.set(redis_key, chat_number.to_i + 1)
    return chat_number
  end
end

def generate_message_number(chat_number, application_token)
  # Construct a unique Redis key for storing message numbers for each application
  redis_key = "message_number_chat_number#{chat_number}_application_token_#{application_token}"
  $redis_lock.lock(redis_key, 2000) do |locked|
  message_number = $redis.get(redis_key)
    $redis.set(redis_key, message_number.to_i + 1)
    return message_number
  end
end
