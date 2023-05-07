class IncomingSmsService

  def initialize(body:, from_number:)
    @body = body.downcase
    @from_number = from_number.to_s
  end

  def from_user_id
    user_id_map = {
      ENV['1'] => '1',
      ENV['2'] => '2',
    }
    user_id_map[@from_number] || 0
  end

  def recognized_user?
    from_user_id != 0
  end

  def commands
    update_commands = all_bill_names.map do |name|
      "update #{name}"
    end
    second_string = @body.split(' ')[1]
    create_command = []
    if second_string.match?(/\D/)
      create_command = ["create #{second_string}"]
    end

    standard_commands = [
      'cal status',
      'sabrina status',
      'together status',
      'new payday',
      'cal spent',
      'sabrina spent',
      'together spent',
      'list commands',
    ].concat(update_commands, create_command)
  end

  def all_bill_names
    @_all_bill_name ||= Bill.bill_names
  end

  def parse_body
    pieces = @body.split(' ')
    if pieces.size >= 2
      command = "#{pieces[0]} #{pieces[1]}"
    end
    if pieces.size >= 3
      amount = pieces[2].to_f
    end
    { command: command, amount: amount }
  end

  def body_correct_length?
    peices = @body.split(' ')
    peices.length == 2 || peices.length == 3
  end

  def is_good_command?
    first_two = @body.split(' ').take(2).join(' ')
    commands.include?(first_two)
  end


  def command_valid?
    if is_good_command? && body_correct_length?
      true
    else
      error_message = "#{@body} is an invalid command. Reply \"List commands\" to show valid commands"
      OutgoingSmsService.new(to_user_id: from_user_id, body: error_message)
    end
  end


  def handle_reply
    return unless recognized_user?
    return unless command_valid?

    command = parse_body[:command]
    amount = parse_body[:amount]
    if amount
      call_command_function(command, amount)
    else
      call_command_function(command)
    end

  end

  def create_bill(amount)
    UpdateSpreadsheetService.new(user_id: from_user_id, amount: amount).create_bill
  end
 
end