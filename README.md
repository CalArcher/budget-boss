# Budget Boss

## About

Budget Boss is a simple Ruby on Rails application that simplifies your monthly budget tracking. Initially developed as a solution to the hassle of using spreadsheets to monitor your finances, Budget Boss makes the tracking process straightforward and easy.

Using spreadsheets, tracking small expenses was a pain and recalculating the budget each month felt like an unwanted task. Budget Boss addresses these issues head-on, making budget tracking as easy as sending a text message. Spend something? Send the amount to the bot and it's deducted from your monthly budget.

Budget Boss goes beyond basic tracking. With simple text commands, you can log your paydays, create bills, and check your current budget status anytime. The app takes care of end of month reports, reminds you to log your paychecks, and keeps track of all transactions. Each new month, the app sets up starting values for you.

Originally using Twilio, Budget Boss now runs on Discord to lower operating costs.

## Features

**Current commands available:**
- `update bill (bill_name) (amount)`  --> update a bill to a new monthly amount
- `create bill (new_bill_name) (amount)` --> creates a new monthly bill
- `delete bill (bill_name)` --> deletes an existing monthly bill 
- `(user name) status` --> returns a user's remaining monthly budget and how much they spent
- `payday (amount)` --> log a payday
- `(user name) spent (amount) "(description in quotes)"` --> log a spent transaction
- `(user name) saved (amount) "(description in quotes)"` --> track money earned not from a payday
- `list commands` --> list all available commands
- `list bills` --> list all bills
- `list paydays` --> gives info on how many paydays this month have been logged
- `previous (number) transactions` --> list last x number of transactions


## Technologies Used

- Ruby on Rails
- PostgreSQL
- ~~Twilio~~ Discord API
- AWS EC2
- AWS RDS

## TODO Features:

- Specify which month a payday is for instead of defaulting to the current month (paid late, paid early)
- Expand available commands to add more functionality like serving a user historical data
- Better error handling
- Reversing a transaction (undo)
- Add yearly bills
- create bill categories (i.e groceries, medical expenses, pets, etc)
- last x transactions (not prev)
- list categories
- create, update, delete categories

---
<br/>
<br/>

<img src="demo.gif" width="360" height="780">