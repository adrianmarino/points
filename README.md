# <img src="https://cdn.rawgit.com/adrianmarino/points/features/basic-readme/images/logo.svg" width="35" height="35" /> Points
  Points is a platform used to foreign exchange between registered users.

  [![Build Status](https://travis-ci.org/adrianmarino/points.svg?branch=master)](https://travis-ci.org/adrianmarino/points)
  [![License](http://img.shields.io/:license-mit-blue.svg)](http://badges.mit-license.org)

## Features
  * Manage currencies, exchange rates, accounts, users, transactions and entities.
  * Use three basic transactions to increase/decrease amount on accounts:
    * Deposit an amount to backup account.
    * Extract an amount from backup account.
    * Transfer an amount between accounts(This include foreign exchange when necessary).
  * Also, include a simple DSL to create custom transactions at runtime.

## Requirements

* MySQL or MariaDB
* Elixir(iex/mix)

## Beginning

**Step 1:** Download project.
```bash
git clone https://github.com/adrianmarino/points.git; cd points
```
**Step 2:** Install dependencies.
```bash
mix deps.get
```
**Step 3:** Create your database.
```bash
mix ecto.create
mix ecto.migrate
```
**Step 4:** Start server.
```bash
mix phoenix.server
```

## Guide

What can you do with points?
```bash
$ mix help | grep points
mix points.client.accounts                   # Show accounts. Params: token
mix points.client.accounts.create            # Create an account. Params: token owner_email currency_code
mix points.client.accounts.delete            # Delete an account. Params: token owner_email currency_code
mix points.client.accounts.show              # Show an account. Params: token owner_email currency_code
mix points.client.currencies                 # Show currencies. Params: token
mix points.client.currencies.create          # Create a currency. Params: token code name
mix points.client.currencies.delete          # Delete a currency. Params: token code
mix points.client.currencies.show            # Show a currency. Params: token code
mix points.client.currencies.update          # Update currency name. Params: token code name
mix points.client.exchange_rates             # Show exchange rates. Params: token
mix points.client.exchange_rates.create      # Create a exchange rate. Params: token source target value
mix points.client.exchange_rates.delete      # Delete a exchange rate. Params: token source target
mix points.client.exchange_rates.show        # Show a exchange rate. Params: token source target
mix points.client.exchange_rates.update      # Update a exchange rate. Params: token source target value
mix points.client.sessions                   # Show sessions
mix points.client.sessions.sign_in           # Open a session
mix points.client.sessions.sign_out          # Close a session
mix points.client.transactions               # Show transactions. Params: token
mix points.client.transactions.create        # Create a transaction. Params: token name source
mix points.client.transactions.delete        # Delete a transaction. Params: token name
mix points.client.transactions.exec          # Execute a transaction. Params: token name params(as json: '{...}')
mix points.client.transactions.exec.deposit  # Deposit. Params: token name params(as json: '{...}')
mix points.client.transactions.exec.extract  # Extract. Params: token name params(as json: '{...}')
mix points.client.transactions.exec.transfer # Transfer. Params: token name params(as json: '{...}')
mix points.client.transactions.show          # Show a transaction. Params: token name
mix points.client.transactions.update        # Update a transaction. Params: token name source
mix points.client.users                      # Show users
mix points.client.users.create               # Create a user. Params: token email password first_name last_name
mix points.client.users.delete               # Delete a user. Params: token email
mix points.client.users.show                 # Show a user. Params: token email
mix points.client.users.update               # Update a user. Params: token email password first_name last_name
```
