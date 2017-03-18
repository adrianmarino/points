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
  $ ./docker-server-init
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
mix cli.accounts.create            # Create an account. Params: token owner_email currency_code
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
mix cli.sessions                   # Show sessions
mix cli.sessions.sign_in           # Open a session
mix cli.sessions.sign_out          # Close a session
mix cli.transactions               # Show transactions. Params: token
mix cli.transactions.create        # Create a transaction. Params: token name source
mix cli.transactions.delete        # Delete a transaction. Params: token name
mix cli.transactions.exec          # Execute a transaction. Params: token name params(as json: '{...}')
mix cli.transactions.exec.deposit  # Deposit. Params: token name params(as json: '{...}')
mix cli.transactions.exec.extract  # Extract. Params: token name params(as json: '{...}')
mix cli.transactions.exec.transfer # Transfer. Params: token name params(as json: '{...}')
mix cli.transactions.show          # Show a transaction. Params: token name
mix cli.transactions.update        # Update a transaction. Params: token name source
mix cli.users                      # Show users
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
mix cli.accounts.create            # Create an account. Params: token owner_email currency_code
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

```
*Step 1:* Create an exchange rate between ARS and PTS.
```bash
$ mix help | grep cli.exchange_rates.create
mix cli.exchange_rates.create      # Create a exchange rate. Params: token source target value
$ mix cli.exchange_rates.create $TOKEN ARS PTS 1000
13:49:39.557 [info]  Response - Status: 201, Body: {"source":"ARS","target":"PTS","value":"1000.00"}
```

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

To complete

#### Transactions

##### Basic

To complete

##### Custom

To complete

#### Learning by example

##### Example 1: X company offer points to its clients

Suppose that X company sell flights through a web site and would like to grant point for each time that a client buy a flight an giving their clients the opportunity to use these points in the following purchase.

How we implement this with _points_?
To complete

##### Example 2: Share points between X and Y companies

Suppose that Y company that has a web site to sell products of any type offer to X company
share points between their giving their clients the opportunity to use these points(X+Y) in the following purchase in either company.

How we implement this with _points_?
To complete

##### Example 3: X company offer buy with points that belong to Y company clients.

This example differs from _Example 1_ in that X company give their clients the opportunity to use points of Y company.

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

* docker-server-init: create/poulate database and run server in docker-compose env.
* docker-server: Run server on docker-compose env.
* docker-test: Run test on docker-compose env.
* docker-reset: Reset(drop/create/migrate/populate) database in docker-compose env.
* docker-clean: Clean(drop/create/migrate) database in docker-compose env.
