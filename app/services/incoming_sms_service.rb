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

  # a command is either two or three words
  # three word commands are always data update commands
  # two word commands are always data request commands

  # data update commads first words are either update, create, for first word
  # bill name in snake case
  # third word is the new amount

  #ex: "updte bill_name 100"
  def commands
    update_commands = all_bill_names.map do |name|
      "update #{name}"
    end
    bill_name = body_array[1]
    create_command = []
    if bill_name.match?(/\D/) && !all_bill_names.include?(bill_name)
      create_command = ["create #{bill_name}"]
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
      'list bill names',
      'list bill amounts',
    ].concat(update_commands, create_command)
  end

  def all_bill_names
    @_all_bill_name ||= Bill.all_bill_names.join(' ')
  end

  def body_array
    @_body_array ||= @body.split(' ')
  end

  def parse_body
    @_parse_body ||= begin
      chunks = body_array
      command = nil
      amount = nil
      prefix = nil
      middle = nil

      if chunks.size == 2
        command = "#{chunks[0]} #{chunks[1]}"
      elsif chunks.size == 3
        prefix = chunks[0]
        middle = chunks[1]
        amount = chunks[2].to_f
      end
      { 
        command: command,
        amount: amount,
        prefix: prefix,
        middle: middle
      }
    end
  end

  def body_correct_length?
    body_array.length == 2 || body_array.length == 3
  end

  def command_recognized?
    body_length = body_array.length
    first_two = body_array.take(2).join(' ') 
    return false unless commands.include?(first_two)
    body_array.length == 2 || body_array[2] =~ /^\d+$/
  end

  def command_valid?
    if command_recognized? && body_correct_length?
      true
    else
      error_message = "\"#{@body}\" is an invalid command. Reply \"List commands\" to show valid commands"
      OutgoingSmsService.new(to_user_id: from_user_id, body: error_message)
    end
  end

  def handle_info_request_command
    case parse_body[:command]
    when 'list bill amounts'
      list_bills('amounts')
    when 'list bill names'
      list_bills('names')
    when 'list commands'
      list_commands
    when 'cal status'
      get_status('user_1', "Cal's")
    when 'sabrina status'
      get_status('user_2', "Sabrina's")
    when 'together status'
      get_status('together', 'Together')
    end
  end

  def list_bills(type)
    if type == 'names'
      reply = "Here are the names of your bills: #{all_bill_names.sort.join(' ')}"
      OutgoingSmsService.new(to_user_id: from_user_id, body: reply)
    else
      all_bills_formatted = Bill.all.order(:bill_name).map do |bill|
        "#{bill.bill_name}: $#{bill.bill_amount} per month"
      end.join(",\n")
      reply = "Here are the names of your bills and their amounts:\n#{all_bills_formatted}."
      OutgoingSmsService.new(to_user_id: from_user_id, body: reply)
    end
  end

  def all_command_names
    [
      'update (bill_name) (amount)',
      'create (new_bill_name) (amount)',
      'cal status',
      'sabrina status',
      'together status',
      'new payday (amount)',
      'cal spent (amount)',
      'sabrina spent (amount)',
      'together spent (amount)',
      'list commands',
      'list bill names',
      'list bill amounts',
    ]
  end

  def list_commands
    reply = "Valid commands:\n#{all_command_names.join(",\n")}."
    OutgoingSmsService.new(to_user_id: from_user_id, body: reply)
  end


  def create_update_bill(name:, amount:, type:)
    if type == 'create'
      UpdateDbService.new(user_id: from_user_id, amount: amount, bill_name: name).create_bill
    else
      UpdateDbService.new(user_id: from_user_id, amount: amount, bill_name: name).update_bill
    end
  end

  def process_payday
    UpdateDbService.new(user_id: from_user_id, amount: parse_body[:amount], bill_name: nil).payday
  end

  def call_user_requested_service
    if body_array.length == 2
      handle_info_request_command
    elsif parse_body[:prefix] == 'create' || parse_body[:prefix] == 'update'
      create_update_bill(name: parse_body[:middle], amount: parse_body[:amount], type: parse_body[:prefix])
    elsif parse_body:[middle] == 'payday'
      process_payday
    # elsif
      # handle parse[:middle] == spent commands
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
end