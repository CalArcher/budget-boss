class IncomingSmsService
  include SmsHelper

  def initialize(body:, from_number:)
    @body = body.downcase
    @from_number = from_number.to_s
  end

  def from_user
    User.find_by!(phone_number: @from_number)
  end

  def body_array
    @_body_array ||= @body.split(' ')
  end

  def body_correct_length?
    body_array.length >= 2 || body_array.length <= 4
  end

  def reply_invalid_command
    error_message = "\"#{@body}\" is an invalid command. Reply \"List commands\" to show valid commands"
    send_sms(from_user, error_message)
  end

  def command_valid_length?
    if body_correct_length?
      true
    else
      reply_invalid_command
    end
  end

  def all_command_names
    [
      'update bill (bill_name) (amount)',
      'create bill (new_bill_name) (amount)',

      'cal status',
      'sabrina status',
      'together status',

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

    if is_valid_command
      command_class.execute
    end
  end

  def process_incoming_message
    return unless command_valid_length? && from_user.present?
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