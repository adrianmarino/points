# <img src="https://cdn.rawgit.com/adrianmarino/points/features/basic-readme/images/logo.svg" width="35" height="35" /> Points
  Points is a platform used to exchange money under both virtual and real currency between registered users.

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

* Elixir >= 1.3.x
* MySQL/MariaDB 10.x

## Beginning

  **Step 1:** Download project.
  ```bash
  git clone https://github.com/adrianmarino/points.git; cd points
  ```

  **Step 2**: Install dependencies.
  ```bash
  $ mix deps.get
  ```

  **Step 3**: Create and populate points database.
  ```bash
  $ MIX_ENV=dev mix ecto.reset
  ```

  **Step 4**: Start server.
  ```bash
  $ mix phoenix.server
  ```

## Beginning with docker

  ```bash
  $ bash scripts/docker-server-init
  ```

## Guide

This guide introduces you how can interact with points platform through easy examples. Adicionally, I'll show you how to configure the server api.

### User Roles

Each user has a role that allow perform different actions on the platform. Next I'll show each role and its associated actions.

#### normal_user
Is a platform user. They can:
* Exchange amounts between accounts under same entity or between partner entities.
* Check account status or last movements.

#### entity_admin
Cant be created by a _system_admin_ user only and their actions modify the context of the entity.
An entity_admin:
* Could administrate many entities.
* Can deposit/extract amount to/from backup accounts under an entity.
* Can manage custom transations that belong to entity.
* Can manage partner associations.
* Is an account issuer, this means that can manage default accounts under an entity. Keep in mind that when an entity_admin user creates an account, **that account belong to same issuer entity**.

#### system_admin
Can perfom all functions like a root user on Linux OS.

### Account types

There are two account types.

#### Default accounts

These accounts belongs to a _normal_user_ could be used to trasnfer amounts between accounts only.

#### Backup accounts

These accounts contain money in real currency only. They are used to support amounts in virtual currency in other accounts (default accounts). An emiter entity has one backup account by real currency and many default accounts by user registered in itself. These default accounts has money y real or virtual currency but all supported by entity backup accounts.

#### Accounts and allow movements

You can:
  * Deposit an amount in real currency to backup account.
  * Extract an amount in real currency from backup amount.
  * And transfer an amount between backup/default accounts.

### Mix Tasks

You can interact with the rest api through mix tasks without need to use curl or any rest client. This tasks actually use a rest client as we'll see later.

What can you do with _points_?
Let's begin by run next command under _points_ path:
```bash
$ mix help | grep cli                
mix cli.accounts                   # Show accounts. Params: token
mix cli.accounts.create            # Create an account. Params: token owner_email currency_code type(Optional: default/backup)
mix cli.accounts.delete            # Delete an account. Params: token owner_email currency_code
mix cli.accounts.show              # Show an account. Params: token owner_email currency_code
mix cli.currencies                 # Show currencies. Params: token
mix cli.currencies.create          # Create a currency. Params: token code name
mix cli.currencies.delete          # Delete a currency. Params: token code
mix cli.currencies.show            # Show a currency. Params: token code
mix cli.currencies.update          # Update currency name. Params: token code name
mix cli.entities                   # Show entities. Params: token
mix cli.entities.create            # Create an entity. Params: token code name
mix cli.entities.delete            # Delete an entity. Params: token code
mix cli.entities.partners          # Show entity partners. Params: token entity_code
mix cli.entities.partners.create   # Create an entity partner. Params: token partner_code entity_code
mix cli.entities.partners.delete   # Delete an entity partner. Params: token partner_code entity_code
mix cli.entities.show              # Show an entity. Params: token code
mix cli.entities.update            # Update entity name. Params: token code name
mix cli.exchange_rates             # Show exchange rates. Params: token
mix cli.exchange_rates.create      # Create a exchange rate. Params: token source target value
mix cli.exchange_rates.delete      # Delete a exchange rate. Params: token source target
mix cli.exchange_rates.show        # Show a exchange rate. Params: token source target
mix cli.exchange_rates.update      # Update a exchange rate. Params: token source target value
mix cli.movements.between          # Show movements between dates. Params: from to (format: YYYYMMDD_HHMM)
mix cli.movements.by_account_after # Show account movements after a date. Params: token owner_email currency_code timestamp (after format: YYYYMMDD_HHMM)
mix cli.sessions                   # Show sessions. Params: token
mix cli.sessions.sign_in           # Open a session. Params: email password
mix cli.sessions.sign_out          # Close a session. Params: token
mix cli.transactions               # Show transactions. Params: token
mix cli.transactions.create        # Create a transaction. Params: token name source
mix cli.transactions.delete        # Delete a transaction. Params: token name
mix cli.transactions.exec          # Execute a transaction. Params: token name params(as json: '{...}')
mix cli.transactions.exec.deposit  # Deposit. Params: token params(as json: '{...}')
mix cli.transactions.exec.extract  # Extract. Params: token params(as json: '{...}')
mix cli.transactions.exec.transfer # Transfer. Params: token params(as json: '{...}')
mix cli.transactions.show          # Show a transaction. Params: token name
mix cli.transactions.update        # Update a transaction. Params: token name source
mix cli.users                      # Show users.
mix cli.users.create               # Create a user. Params: token email password role first_name last_name
mix cli.users.delete               # Delete a user. Params: token email
mix cli.users.roles                # Show roles. Param: token
mix cli.users.show                 # Show a user. Params: token email
mix cli.users.update               # Update a user. Params: token email password role first_name last_name
```
As we can see, all _points_ interactions was grouped under _cli_ namespace and then are grouped by resource name namespace. Each task has a tiny description and show you params required to perform this.

Up to this point very nice but, how could you use these tasks?
Well, let's see _points_ in action in next section.

#### Sessions

*Step 1:* Get a session to interact with _points_:
```bash
$ mix cli.sessions.sign_in chewbacca@gmail.com 12345678910
23:52:53.774 [info]  Response - Status: 201, Body: {"token":"aHZEWXV2VGdWUGI5SWR1U2p1Q3cwZz09"}
```
This request generate a session token witch has a 30 minutes lifetime(It can be modified) and must be passed to any task as first parameter.

*Step 2:* Save token value to env variable to reuse this:
```bash
$ export TOKEN=aHZEWXV2VGdWUGI5SWR1U2p1Q3cwZz09aHZEWXV2VGdWUGI5SWR1U2p1Q3cwZz09
```

*Step 3:* Show opened sessions info:
```bash
$ mix cli.sessions $TOKEN                             
12:11:18.545 [info]  Response - Status: 200, Body: [
  {
    "email": "chewbacca@gmail.com",
    "remote_ip": "127.0.0.1",
    "timeout": "29 minutes, 42 seconds"
  }
]
```

*Step 4:* After interact with points you can close the session:
```bash
$ mix cli.sessions.sign_out $TOKEN
```

**Note**: To close all session from server side use:
```bash
$ mix run scripts/sessions_close_all.exs
```

#### Users

*Step 1:* Create a user.

```bash
$ mix help | grep cli.users.create
mix cli.users.create               # Create a user. Params: token email password role first_name last_name
$ mix cli.users.create $TOKEN adrianmarino@gmail.com 12345678910 normal_user Adrian Marino                          
12:15:36.546 [info]  Response - Status: 201, Body: {
  "email": "adrianmarino@gmail.com",
  "first_name": "Adrian",
  "last_name": "Marino",
  "role": "normal_user"
}
```

*Step 2:* Modifiy user role and password.

```bash
$ mix help | grep cli.users.update                                                         
mix cli.users.update               # Update a user. Params: token email password role first_name last_name
$ mix cli.users.update $TOKEN adrianmarino@gmail.com acbd5678910 entity_admin Adrian Marino
12:49:29.238 [info]  Response - Status: 200, Body: {
  "email": "adrianmarino@gmail.com",
  "first_name": "Adrian",
  "last_name": "Marino",
  "role": "entity_admin"
}
```

*Step 3:* Show user info.

```bash
$ mix help | grep cli.users.show  
mix cli.users.show                 # Show a user. Params: token email
$ mix cli.users.show $TOKEN adrianmairno@gmail.com
12:52:38.119 [info]  Response - Status: 200, Body: {
  "email": "adrianmairno@gmail.com",
  "first_name": "Adrian",
  "last_name": "Marino",
  "role": "entity_admin"
}
```

*Step 4:* Delete user.

```bash
$ mix help | grep cli.users.delete                  
mix cli.users.delete               # Delete a user. Params: token email
$ mix cli.users.delete $TOKEN adrianmairno@gmail.com
12:54:16.146 [info]  Response - Status: 204
```

#### Currencies

*Step 1:* Create a currency.
```bash
$ mix help | grep cli.currencies.create  
mix cli.currencies.create          # Create a currency. Params: token code name
$ mix cli.currencies.create $TOKEN PTS Points             
13:29:42.110 [info]  Response - Status: 201, Body: {"code":"PTS","issuer_email":"chewbacca@gmail.com","name":"Points"}
```
As we can see, this currency was created by an issuer user (with entity_admin/system_admin role).
_Note:_ An user is represented by an uniq email.

*Step 2:* Let's see PTS currency:
```bash
$ mix help | grep cli.currencies.show                     
mix cli.currencies.show            # Show a currency. Params: token code
$ mix cli.currencies.show $TOKEN PTS
13:33:19.279 [info]  Response - Status: 200, Body: {"code":"PTS","issuer_email":"chewbacca@gmail.com","name":"Points"}
```

*Step 3:* Update currency name:
```bash
$ mix help | grep cli.currencies.update
mix cli.currencies.update          # Update currency name. Params: token code name
$ mix cli.currencies.update $TOKEN PTS "Points currency"
13:34:34.249 [info]  Response - Status: 200, Body: {"code":"PTS","issuer_email":"chewbacca@gmail.com","name":"Points currency"}
```

*Step 4:* Delete currency.
```bash
$ mix help | grep cli.currencies.delete                 
mix cli.currencies.delete          # Delete a currency. Params: token code
$ mix cli.currencies.delete $TOKEN PTS
13:36:11.204 [info]  Response - Status: 204
```

#### Accounts

*Step 1:* Create an account for adrianmarino@gmail.com under PTS currency.
```bash
$ mix help | grep cli.accounts.create  
mix cli.accounts.create            # Create an account. Params: token owner_email currency_code type(Optional: default/backup)
$ mix cli.accounts.create $TOKEN adrianmarino@gmail.com PTS
13:41:26.641 [info]  Response - Status: 201, Body: {
  "amount": "0.00",
  "currency": "PTS",
  "id": 4,
  "issuer_email": "chewbacca@gmail.com",
  "owner_email": "adrianmarino@gmail.com",
  "type": "default"
}
```

*Step 2:* Show account for adrianmarino@gmail.com under PTS currency.
```bash
$ mix help | grep cli.accounts.show  
mix cli.accounts.show              # Show an account. Params: token owner_email currency_code
$ mix cli.accounts.show $TOKEN adrianmarino@gmail.com PTS
13:44:16.733 [info]  Response - Status: 200, Body: {
  "amount": "0.00",
  "currency": "PTS",
  "id": 4,
  "issuer_email": "chewbacca@gmail.com",
  "owner_email": "adrianmarino@gmail.com",
  "type": "default"
}
```

*Step 3:* Delete account.
```bash
$ mix help | grep cli.accounts.delete                    
mix cli.accounts.delete            # Delete an account. Params: token owner_email currency_code
$ mix cli.accounts.delete $TOKEN adrianmarino@gmail.com PTS
13:45:21.783 [info]  Response - Status: 204
```

#### Exchange rates

*Step 1:* Create an exchange rate between ARS and PTS.
```bash
$ mix help | grep cli.exchange_rates.create
mix cli.exchange_rates.create      # Create a exchange rate. Params: token source target value
$ mix cli.exchange_rates.create $TOKEN ARS PTS 1000
13:49:39.557 [info]  Response - Status: 201, Body: {"source":"ARS","target":"PTS","value":"1000.00"}
```

*Step 2:* Modify exchange rate between ARS and PTS.
```bash
$ mix help | grep cli.exchange_rates.update
mix cli.exchange_rates.update      # Update a exchange rate. Params: token source target value
$ mix cli.exchange_rates.update $TOKEN ARS PTS "123.5"
13:51:23.122 [info]  Response - Status: 201, Body: {"source":"ARS","target":"PTS","value":"123.50"}
```

*Step 3:* Show exchange rate between ARS and PTS.
```bash
$ mix help | grep cli.exchange_rates.show     
mix cli.exchange_rates.show        # Show a exchange rate. Params: token source target
$ mix cli.exchange_rates.show $TOKEN ARS PTS  
13:57:14.520 [info]  Response - Status: 200, Body: {"source":"ARS","target":"PTS","value":"1000.00"}
```

*Step 4:* Delete exchange rate between ARS and PTS.
```bash
$ mix help | grep cli.exchange_rates.delete           
mix cli.exchange_rates.delete      # Delete a exchange rate. Params: token source target
$ mix cli.exchange_rates.delete $TOKEN ARS PTS
13:52:38.674 [info]  Response - Status: 204
```

#### Entities

*Step 1:* Create an entity.
```bash
$ mix help | grep cli.entities.create             
mix cli.entities.create            # Create an entity. Params: token code name
$ mix cli.entities.create $TOKEN XYZ "XYZ company"
22:58:27.000 [info]  Response - Status: 201, Body: {"code":"XYZ","name":"XYZ company"}
```

*Step 2:* Modify an entity.
```bash
$ mix help | grep cli.entities.update
mix cli.entities.update            # Update entity name. Params: token code name
$ mix cli.entities.update $TOKEN XYZ "XYZ Company 2"
23:01:53.665 [info]  Response - Status: 200, Body: {"code":"XYZ","name":"XYZ Company 2"}
```

*Step 3:* Show an entity.
```bash
$ mix help | grep cli.entities.show                 
mix cli.entities.show              # Show an entity. Params: token code
$ mix cli.entities.show $TOKEN XYZ
23:02:54.416 [info]  Response - Status: 200, Body: {"code":"XYZ","name":"XYZ Company 2"}
```

*Step 4:* Delete an entity.
```bash
$ mix help | grep cli.entities.delete
mix cli.entities.delete            # Delete an entity. Params: token code
$ mix cli.entities.delete $TOKEN XYZ
23:03:53.540 [info]  Response - Status: 204
```

#### Transactions

##### Primitive transactions

*Deposit:* Deposit an amount to backup account.
```bash
$ mix help | grep cli.transactions.exec.deposit
mix cli.transactions.exec.deposit  # Deposit. Params: token params(as json: '{...}')
$ mix cli.transactions.exec.deposit $TOKEN '{"to":{"email":"adrianmarino@gmail.com","currency":"ARS"},"amount":10000}'
01:01:53.707 [info]  Response - Status: 200, Body: {
  "amount": "10000.00",
  "source": "non",
  "target": {
    "amount": "19990.00",
    "currency": "ARS",
    "type": "backup"
  },
  "type": "deposit"
}
```

*Extract:* Extract an amount from backup account.
```bash
$ mix help | grep cli.transactions.exec.extract                                                                       
mix cli.transactions.exec.extract  # Extract. Params: token params(as json: '{...}')
$ mix cli.transactions.exec.extract $TOKEN '{"from":{"email":"adrianmarino@gmail.com","currency":"ARS"},"amount":100}'
01:39:56.843 [info]  Response - Status: 200, Body: {
  "amount": "100.00",
  "source": {
    "amount": "9890.00",
    "currency": "ARS",
    "type": "backup"
  },
  "target": "non",
  "type": "extract"
}
```

*Transfer:* Transfer an amount between accounts.
```bash
$ mix help | grep cli.transactions.exec.transfer
mix cli.transactions.exec.transfer # Transfer. Params: token params(as json: '{...}')
$ mix cli.transactions.exec.transfer $TOKEN '{"from":{"email":"a@gmail.com","currency":"XPT"},"to":{"email":"b@gmail.com","currency":"XPT"},"amount":5000}'
01:41:03.264 [info]  Response - Status: 200, Body: {
  "amount": "5000.00",
  "source": {
    "amount": "0.00",
    "currency": "XPT",
    "owner": "a@gmail.com"
  },
  "target": {
    "amount": "10000.00",
    "currency": "XPT",
    "owner": "b@gmail.com"
  },
  "type": "transfer"
}
```

##### Custom transactions

There are times when you need execute a transaction group atomically. _points_ allow this behavior througth _custom transactions_. A _custom transaciton_ actually is an script that can execute many transactions atomically. Also you can create and run there at runtime througth rest api.

###### Defining a custom transaction

A _custom transaction_ must be defined in a elixir module in the following way:
```elixir
defmodule MyCustomTransaction do
  use Transaction

  def perform(params) do
    # your code
  end
end
```
_Transaction_ module actually is a behavior module that include all needed functions to execute the transaction as well as many primitive functions that can be used in perform function to build the behavior of your transaction.

On the other hand, you can define required and opcional parameters in the following way:
```elixir
defmodule MyCustomTransaction2 do
  use Transaction

  defparams do: %{to: %{user: %{email: "adrianmarino@gmail.com"}, currency: :required}, amount: 100}

  def perform(params) do
    # any code...
  end
end
```
This transaction asign a default value to email("adrianmarino@gmail.com") and amount(100) in case they are not passed but require a currency code.

###### Standard functions

By default _Transaction_ module import _StandardLib_ module that give you many primitive functions as we will see below:

```elixir
defmodule StandardLib do
  # Print a messsage under server console.
  def print(message)

  # Find an account by owner email and currency.
  def account(email: email, currency: currency)
  # Get account amount.
  def amount(account)

  # Primivite tarnsactions
  def transfer(amount: amount, from: source_account, to: target_account)
  def extract(amount: amount, from: account)
  def deposit(amount: amount, to: account)

  # Refresh state of a model (account, rate, entity, user, etc...).
  def refresh(model)
end
```

Also you can create your owns modules to use in transactions, only must include module in your transaction. Create a _MyModule_ under lib path:
```elixir
defmodule MyModule do
  def hello(name), do: IO.puts("Hello #{name}")
end
```
After, import this in your transation:
```elixir
defmodule Deposit do
  import MyModule
  def perform(_params), do: hello("Adrian")
end
```

###### Create, remove and execute custom transactions

To complete

#### Learning by example

##### Exercise 1: X company offer points to its clients

Suppose that X company sell flights through a web site and would like to grant points for each time that a client buy a flight giving their clients the opportunity to use these points in the following purchase.

_Guidelines:_
1. The entity grant points to client from a backup amount in real money.
2. Points can be tranfered between clients.
3. Then a client spent N points there are transfered to an entity acount to control the amount of spent points.

How we implement this with _points_?
You can see the exercise resolution in an executable scenario in [scripts/exercise_1](scripts/exercise_1) script. You must execute next command to run the exercise:
```bash
$ bash scripts/exercise_1
```

##### Exercise 2: Share points between X and Y companies

Suppose that Y company sell products of any type also through a web site and offer to X company
share points between their giving their clients the opportunity to use these points(X+Y) in the following purchase in either company.

How we implement this with _points_?
To complete

##### Exercise 3: X company offer buy with points that belong to Y company clients.

This example differs from _Exercise 1_ in that X company give their clients the opportunity to use points of Y company.

How we implement this with _points_?
To complete

### Rest API interface

To complete

### Client

To complete

### Custom transactions

To complete

### Server configuration

You can change configuration settings from config/XXX.exs file where XXX is the name of environmnet where
_points_ could run: dev, test or prod.

#### session_ttl

* Is the time that can last a session.
* Is expresed in milliseconds.
* Default value: 1800 (30 minutes).

#### simultaneous_sessions_by_user_and_remote_ip

* Specifies the max number of user sessions by remote ip, where remote IP is the IP from that was performed the sign_in action.
* Default value: 3.

#### tmp_path

* Path used to create and load custom transaction files
* Default value: "./tmp"

#### http_potion_log_request_as_info_level

* User to show request information of cli.RESOURCE.ACTION tasks.
* :yes and :no are the possible values.
* Default value: :no.

## Docker

* scripts/docker-server-init: create/poulate database and run server in docker-compose env.
* scripts/docker-server: Run server on docker-compose env.
* scripts/docker-test: Run test on docker-compose env.
* scripts/docker-reset: Reset(drop/create/migrate/populate) database in docker-compose env.
* scripts/docker-clean: Clean(drop/create/migrate) database in docker-compose env.
