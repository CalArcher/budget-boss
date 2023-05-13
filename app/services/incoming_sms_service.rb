class IncomingSmsService

  def initialize(body:, from_number:)
    @body = body.downcase
    @from_number = from_number.to_s
  end

  def year
    @_year ||= Time.now.year
  end

  def month
    @_month ||= Time.now.month
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

  # a command is three words long (besides exeptions)
  # either delete, update, create, for first word
  # bill name in snake case
  # third word is the new amount
  def commands
    update_commands = all_bill_names.map do |name|
      "update #{name}"
    end
    second_string = body_array[1]
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
      'list bills',
    ].concat(update_commands, create_command)
  end

  def all_bill_names
    @_all_bill_name ||= Bill.bill_names
  end

  def body_array
    @_body_array ||= @body.split(' ')
  end

  def parse_body
    chunks = body_array
    command = nil
    amount = nil
    prefix = nil
    bill_name = nil

    if chunks.size == 2
      command = "#{chunks[0]} #{chunks[1]}"
    elsif chunks.size == 3
      prefix = chunks[0]
      bill_name = chunks[1]
      amount = chunks[2].to_f
    end

    { 
      command: command,
      amount: amount,
      prefix: prefix,
      bill_name: bill_name
    }
  end

  def body_correct_length?
    body_array.length == 2 || body_array.length == 3
  end

  def command_recognized?
    first_two = body_array.take(2).join(' ')
    commands.include?(first_two)
  end

  def command_valid?
    if command_recognized? && body_correct_length?
      true
    else
      error_message = "\"#{@body}\" is an invalid command. Reply \"List commands\" to show valid commands"
      OutgoingSmsService.new(to_user_id: from_user_id, body: error_message)
    end
  end

  def two_word_command
    case parse_body[:command]
    when 'list bills'
      # list_bills
    when 'list commands'
      # list_commands
    when 'cal status'
      get_status('user_1', "Cal's")
    when 'sabrina status'
      get_status('user_2', "Sabrina's")
    when 'together status'
      get_status('together', 'Together')
    end
  end

  def call_user_requested_service
    if body_array.length == 2
      two_word_command
    elsif body_array.length == 3
      # three_word_command
    end
  end


  def handle_reply
    return unless recognized_user?
    return unless command_valid?
    call_user_requested_service
  end

  def get_status(user, name)
    user_budget_column = "#{user}_budget" # column name to query
    user_spent_column = "#{user}_spent" # column name to query

    sheet = Sheet.where(month: month, year: year)

    user_spent = sheet.pluck(user_spent_column).first
    user_budget = sheet.pluck(user_budget_column).first

    reply = "#{name} budget remaining this month: $#{user_budget}. Total spent this month: $#{user_spent}"
    OutgoingSmsService.new(to_user_id: from_user_id, body: reply)
  end

  def create_bill(amount)
    UpdateSpreadsheetService.new(user_id: from_user_id, amount: amount).create_bill
  end
 
end