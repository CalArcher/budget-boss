namespace :bot do
  task :start => :environment do
    bot = Discordrb::Commands::CommandBot.new(
      token: Rails.application.credentials.dig(:discord, :token),
      client_id: Rails.application.credentials.dig(:discord, :client_id),
      prefix: '/'
    )

    bot.message do |event|
      message = event.message.content
      sending_username = event.message.author.username
      IncomingMessageService.new(body: message, from_username: sending_username).process_incoming_message
      puts("THREADDDD COUNT: #{Thread.list.count}")

    end
    puts('bot start')
    bot.run
  end
end
