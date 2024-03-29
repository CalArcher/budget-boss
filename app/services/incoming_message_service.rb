class IncomingMessageService
  include SmsHelper

  def initialize(body:, from_username:)
    @body = body&.downcase&.strip
    @from_username = from_username&.to_s
  end

  def from_user
    User.find_by!(discord_username: @from_username)
  end

  def body_array
    @_body_array ||= @body.gsub(/".*?"/, '').split(' ')
  end

  def body_correct_length?
    body_array.length > 1 && body_array.length < 5
  end

  def reply_invalid_command
    error_message = "\"**#{@body}**\" is an invalid command. Reply \"List commands\" to show valid commands"

    if @body == 'hello'
      error_message = "https://tenor.com/view/xluna-high-five-gif-25422702"
    end
    send_message(from_user, error_message)
  end

  def command_valid_length?
    if body_correct_length?
      true
    else
      reply_invalid_command
      false
    end
  end

  def all_command_names
    [
      'update bill (bill_name) (amount)',
      'create bill (new_bill_name) (amount)',
      'delete bill (bill_name)',

      'cal status',
      'sabrina status',
      'together status',
      'all status',

      'payday (amount)',

      'cal spent (amount)',
      'sabrina spent (amount)',
      'together spent (amount)',

      'list commands',
      'list bills',
    ]
  end

  def register_all_commands
    Commands.constants.each do |constant_name|
      command_class = Commands.const_get(constant_name)
      if command_class.is_a?(Class) && command_class < Commands::BaseCommand
        Commands::CommandRegistry.register(command_class.command_key, command_class)
      end
    end
  end

  def validate_and_execute_command(registry_entry)
    registered_commands = Commands::CommandRegistry.list_registered_commands
    command_class = registry_entry[1].new(command: @body, to_user: from_user)
    is_valid_command = command_class&.validate

    if is_valid_command == 'valid!'
      command_class.execute
    end
  end

  def process_incoming_message
    return if [command_valid_length?, from_user].any?(&:blank?)

    register_all_commands
    registered_commands = Commands::CommandRegistry.list_registered_commands

    registry_entry = registered_commands.detect do |k, v|
      body_array.include?(k)
    end
    
    if registry_entry
      validate_and_execute_command(registry_entry)
    else
      reply_invalid_command
    end
  end

end