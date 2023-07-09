# bot = Discordrb::Commands::CommandBot.new(
#   token: Rails.application.credentials.dig(:discord, :token),
#   client_id: Rails.application.credentials.dig(:discord, :client_id),
#   prefix: '/'
# )

# bot.message do |event|
#   # puts event.message.content
#   puts event.message.author.inspect
#   puts event.message.author.username

#   event.message.author.pm('DONT TALK IN MY SERVER YOU UGLY KRAKEN')

#   # reply = OutgoingMessageService.new(body: event.message.content)
#   # event.respond(reply)
# end

# bot.run(true)