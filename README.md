# Budget Tracker

Budget Tracker is a simple Ruby on Rails application that allows you to track your monthly budget via text messages. Every time you make a purchase, simply send a text message to the application with the amount spent, and the app will automatically deduct it from your monthly budget. You can also use text commands to refill your budget or check your current budget status.

## Features

- Track your monthly budget via text messages
- Deduct purchases from your budget automatically
- Refill your budget with text commands
- Check your current budget status with text commands
- Receive a summary of your monthly spending at the end of each month

## How to Use

1. Text the application with the amount you spent in the format `spent $20`.
2. The app will automatically deduct the amount from your monthly budget.
3. Use the text command `refill 1800` to add income to your budget (replace 1800 with the amount of income you received).
4. Use the text command `status` to receive a text message with your current budget.
5. At the end of the month, you will receive a summary of your monthly spending via text message.

## Technologies Used

- Ruby on Rails
- PostgreSQL
- Twilio API
