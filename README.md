# Budget Boss

Budget Boss is a simple Ruby on Rails application that allows you to track your monthly budget via text messages. Every time you make a purchase, simply send a text message to the application with the amount spent, and the app will automatically deduct it from your monthly budget. You can also use text commands to add to your budget, create bills, or check your current budget status. Initially was built using Twilio, but switched to Discord to bring down the operating costs of Budget Boss.

## Features

Use text commands to:
- Track your monthly budget
- Deduct purchases from your budget
- Add paydays
- Check your current budget status
- Receive a summary of your monthly spending at the end of each month

## Technologies Used

- Ruby on Rails
- PostgreSQL
- ~~Twilio~~ Discord API
- AWS EC2

## TODO Features:

- Better performance
- Delete/remove bills
- Specify which month a payday is for instead of defaulting to the current month (paid late, paid early)
- Expand available commands to add more functionality like serving a user historical data
- Better error handling
- Reversing a transaction (undo)
- Listing a users recent transactions