require 'redis'
$redis = Redis.new(url: ENV["REDIS_URL"])
# method to generate chat_number using redis
def generate_chat_number(application_token)
  puts "entered generate chat number method"
  # Construct a unique Redis key for storing chat numbers for each application
  redis_key = "chat_number_application_token_#{application_token}"

  # Use Redis INCR command to increment the chat number
  chat_number = $redis.incr(redis_key)

  # Return the incremented chat number
  chat_number
end
def generate_message_number(chat_number, application_token)
  puts "entered generate message number method"
  # Construct a unique Redis key for storing message numbers for each application
  redis_key = "message_number_chat_number#{chat_number}_application_token_#{application_token}"

  # Use Redis INCR command to increment the message number
  message_number = $redis.incr(redis_key)

  # Return the incremented message number
  return message_number
end
