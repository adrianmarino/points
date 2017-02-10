# <img src="https://cdn.rawgit.com/adrianmarino/points/features/basic-readme/images/logo.svg" width="35" height="35" /> Points
  Points is a platform used to exchange amounts in both virtual and real currency between registered users.

  [![Build Status](https://travis-ci.org/adrianmarino/points.svg?branch=master)](https://travis-ci.org/adrianmarino/points)
  [![License](http://img.shields.io/:license-mit-blue.svg)](http://badges.mit-license.org)

## Features
  * Use three basic transactions to increase/decrease accounts amount:
    * Deposit an amount to backup account.
    * Extract an amount from backup account.
    * Transfer an amount between accounts (This include foreign exchange when necessary).
  * Includes a simple DSL to create custom transactions at runtime.
  * Manage currencies, exchange rates, accounts, users, transactions and entities.

## Requirements

* MySQL/MariaDB 10.x
* Elixir >= 1.3.3

## Beginning

**Step 1:** Download project.
```bash
git clone https://github.com/adrianmarino/points.git; cd points
```
**Step 2:** Install dependencies.
```bash
mix deps.get
```
**Step 3:** Create your dev database.
```bash
mix ecto.create
mix ecto.migrate
MIX_ENV=dev mix ecto.reset
```
**Step 4:** Start server.
```bash
mix phoenix.server
```

## Guide

This guide introduces you how can interact with points platform through easy examples. Adicionally, I'll show you how to configure the server.

### Client Tasks

You can interact with the rest api through mix tasks without need to use curl or any rest client. This tasks actually use a rest client as we'll see later. 

What can you do with points api? 
Run next on points directory:
```bash
$ mix help | grep cli
cli.accounts                   # Show accounts. Param: session_token
cli.accounts.create            # Create an account. Params: session_token owner_email currency_code
cli.accounts.delete            # Delete an account. Params: session_token owner_email currency_code
cli.accounts.show              # Show an account. Params: session_token owner_email currency_code
cli.currencies                 # Show currencies. Param: session_token
cli.currencies.create          # Create a currency. Params: session_token code name
cli.currencies.delete          # Delete a currency. Params: session_token code
cli.currencies.show            # Show a currency. Params: session_token code
cli.currencies.update          # Update currency name. Params: session_token code name
cli.exchange_rates             # Show exchange rates. Param: session_token
cli.exchange_rates.create      # Create a exchange rate. Params: session_token source target value
cli.exchange_rates.delete      # Delete a exchange rate. Params: session_token source target
cli.exchange_rates.show        # Show a exchange rate. Params: session_token source target
cli.exchange_rates.update      # Update a exchange rate. Params: session_token source target value
cli.sessions                   # Show sessions. Param: session_token
cli.sessions.sign_in           # Open a session. Params: username password
cli.sessions.sign_out          # Close a session. Param: session_token
cli.transactions               # Show transactions. Param: session_token
cli.transactions.create        # Create a transaction. Params: session_token name source
cli.transactions.delete        # Delete a transaction. Params: session_token name
cli.transactions.exec          # Execute a transaction. Params: session_token name params(as json: '{...}')
cli.transactions.exec.deposit  # Deposit. Params: session_token name params(as json: '{...}')
cli.transactions.exec.extract  # Extract. Params: session_token name params(as json: '{...}')
cli.transactions.exec.transfer # Transfer. Params: session_token name params(as json: '{...}')
cli.transactions.show          # Show a transaction. Params: session_token name
cli.transactions.update        # Update a transaction. Params: session_token name source
cli.users                      # Show users. Param: session_token
cli.users.create               # Create a user. Params: session_token email password first_name last_name
cli.users.delete               # Delete a user. Params: session_token email
cli.users.show                 # Show a user. Params: session_token email
cli.users.update               # Update a user. Params: session_token email password first_name last_name
```
But, How could you use these tasks?
Well, let's see these in action:

*Step 1:* First at all, we need get a session to interact with the api:
```bash
$ mix cli.sessions.sign_in chewbacca@gmail.com 12345678910
23:52:53.774 [info]  Response - Status: 201, Body: {"token":"aHZEWXV2VGdWUGI5SWR1U2p1Q3cwZz09"}
```
This request generate a session token witch has a 30 minutes lifetime(It can be configured). Also must be passed to any task as first parameter.

*Step 2:* Create a new currency.
```bash
$ mix help | grep cli.currencies.create
mix cli.currencies.create          # Create a currency. Params: session_token code name
$ mix cli.currencies.create OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 XPT "X-Men Points"
22:11:30.158 [info]  Response - Status: 201, Body: {"code":"XPT","issuer_email":"chewbacca@gmail.com","name":"X-Men Points"}
```
You see that a currency as a issues_email. A user is represented by an uniq email and belong to an emiter entity.

*Step 3:* Let's see XPT currency:
```bash$
$ mix help | grep cli.currencies.show                                                                                        
mix cli.currencies.show            # Show a currency. Params: session_token code
$ mix cli.currencies.show OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 XPT            
22:16:43.070 [info]  Response - Status: 200, Body: {"code":"XPT","issuer_email":"chewbacca@gmail.com","name":"X-Men Points"}
```

*Step 4:* Create a user.

```bash
$ mix help | grep cli.users.create
mix cli.users.create               # Create a user. Params: session_token email password first_name last_name
$ mix cli.users.create OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 adrianmarino@gmail.com 1234567890 "Adrian Norberto" Marino 
22:20:53.900 [info]  Response - Status: 201, Body: {
  "email": "adrianmarino@gmail.com",
  "first_name": "Adrian Norberto",
  "last_name": "Marino"
}
```
*Step 5:* Create and account for adrianmarino@gmail.com with XPT currency.
```bash
$ mix help | grep cli.accounts.create  
mix cli.accounts.create            # Create an account. Params: session_token owner_email currency_code
$ mix cli.accounts.create OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 adrianmarino@gmail.com XPT                         
22:24:53.213 [info]  Response - Status: 201, Body: {
  "amount": "0.00",
  "currency": "XPT",
  "id": 4,
  "issuer_email": "chewbacca@gmail.com",
  "owner_email": "adrianmarino@gmail.com",
  "type": "default"
}
```
*Step 6:* Show currency currencies.
```bash
$ mix cli.currencies OHpIUENHak9FTTAzUCtwaHB1dnk3dz09
22:32:29.429 [info]  Response - Status: 200, Body: [
  {
    "code": "ARS",
    "issuer_email": "chewbacca@gmail.com",
    "name": "Pesos"
  },
  {
    "code": "RBL",
    "issuer_email": "chewbacca@gmail.com",
    "name": "Rebel Points"
  },
  {
    "code": "EMP",
    "issuer_email": "chewbacca@gmail.com",
    "name": "Empire Points"
  },
  {
    "code": "XPT",
    "issuer_email": "chewbacca@gmail.com",
    "name": "X-Men Points"
  }
]
```
*Step 7:* Create an exchange rate between ARS and XPT and other between XPT and RBL.
```bash
$ mix help | grep cli.exchange_rates.create                                
mix cli.exchange_rates.create   # Create a exchange rate. Params: session_token source target value (target = source * value)
$ mix cli.exchange_rates.create OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 ARS XPT 0.1
22:53:00.810 [info]  Response - Status: 201, Body: {"source":"ARS","target":"XPT","value":"0.1"}
$ mix cli.exchange_rates.create OHpIUENHak9FTTAzUCtwaHB1dnk3dz09 XPT RBL 10
22:38:28.031 [info]  Response - Status: 201, Body: {"source":"XPT","target":"RBL","value":"10"}
```

*Step 7:* show accounts.
```bash
$ mix cli.accounts OHpIUENHak9FTTAzUCtwaHB1dnk3dz09
22:43:14.078 [info]  Response - Status: 401, Body: {"message":"Session expired or closed"}
```
But session was expired, try again:
```bash
$ mix cli.sessions.sign_in chewbacca@gmail.com 12345678910
22:43:29.479 [info]  Response - Status: 201, Body: {"token":"bGJnODBXVnoySUZBVkh2eEV4UVk5UT09"}
```
Ok, let's do it:
```bash
$ mix cli.accounts bGJnODBXVnoySUZBVkh2eEV4UVk5UT09       
22:46:02.607 [info]  Response - Status: 200, Body: [
  {
    "amount": "10000.00",
    "currency": "ARS",
    "id": 1,
    "issuer_email": "chewbacca@gmail.com",
    "owner_email": "chewbacca@gmail.com",
    "type": "backup"
  },
  {
    "amount": "10000.00",
    "currency": "RBL",
    "id": 2,
    "issuer_email": "chewbacca@gmail.com",
    "owner_email": "obiwankenoby@gmail.com",
    "type": "default"
  },
  {
    "amount": "10000.00",
    "currency": "EMP",
    "id": 3,
    "issuer_email": "chewbacca@gmail.com",
    "owner_email": "anakinskywalker@gmail.com",
    "type": "default"
  },
  {
    "amount": "0.00",
    "currency": "XPT",
    "id": 4,
    "issuer_email": "chewbacca@gmail.com",
    "owner_email": "adrianmarino@gmail.com",
    "type": "default"
  }
]
```
*Step 8*: Transfer an amount from backup account 1 to default account 4.

Before all, you must know next concepts:
* There are two account types:
  * Backup accounts: These accounts contain money in real currency only. They are used to support amounts in virtual currency in other accounts (default accounts). An emiter entity has one backup account by real currency and many default accounts by user registered in itself. These default accounts has money y real or virtual currency but all supported by entity backup accounts.
  * Default account: These accounts belongs to normal users (The opposite of an issuer user).
* You can:
  * Deposit an amount in real currency to backup account.
  * Extract an amount in real currency from backup amount.
  * And transfer an amount between backup/default accounts.

Well, returning to our example, you need add an amount to account 4. This account belong to "Point Platform", given that was created by chewbacca@gmail.com user an user create under "Point Platform" entity. Then you must move and amount from backup account 1 to default account 4.


### Rest API
To complete

### Client
To complete

### Custom Transactions
To complete
