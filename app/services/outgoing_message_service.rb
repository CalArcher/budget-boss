require 'net/http'
require 'uri'
require 'json'

class OutgoingMessageService
  def initialize(to_user:, body:)
    @to_user = to_user
    @body = body
  end

  def send
    bot_token = Rails.application.credentials.dig(:discord, :token)
    user_id = @to_user.discord_userid
    message_content = @body

    channel_id = @to_user.channel_id

    uri = URI.parse("https://discord.com/api/v9/channels/#{channel_id}/messages")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bot #{bot_token}"
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "content" => message_content
    })

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    response = http.request(request)
  end
end

# keep for later implementation if needed.
# current setup only works if you already have a DM channel open with user
# which is fine for my use

# bot_token = Rails.application.credentials.dig(:discord, :token)
# user_id = ''
# message_content = @body

# # create a DM Channel
# uri = URI.parse("https://discord.com/api/v9/users/@me/channels")
# request = Net::HTTP::Post.new(uri)
# request["Authorization"] = "Bot #{bot_token}"
# request["Content-Type"] = "application/json"
# request.body = JSON.dump({
#   "recipient_id" => user_id

# })

# http = Net::HTTP.new(uri.hostname, uri.port)
# http.use_ssl = true
# response = http.request(request)

# # get the channel ID from the response
# channel_id = JSON.parse(response.body)["id"]

# # send a message
# uri = URI.parse("https://discord.com/api/v9/channels/#{channel_id}/messages")
# request = Net::HTTP::Post.new(uri)
# request["Authorization"] = "Bot #{bot_token}"
# request["Content-Type"] = "application/json"
# request.body = JSON.dump({
#   "content" => message_content
# })

# http = Net::HTTP.new(uri.hostname, uri.port)
# http.use_ssl = true
# response = http.request(request)
