[![Build Status](https://travis-ci.org/adrianmarino/points.svg?branch=master)](https://travis-ci.org/adrianmarino/points)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://badges.mit-license.org)

# Points
  * Is a virtual bank where users can exchange money under real or virtual currency(e.g. dolars, points).
  * Each user has accounts under entities.
  * Each account has an amount under a currency.
  * Is possible exchange amount between diferent currencies.
  * Each entity have backup accounts under real currency.
  * Each user can:
    * Deposit to backup account.
    * Extract from backup account.
    * Transfer between accounts of any type an currency.

## Begining

  **Step 1**: Install dependencies.
  ```bash
  $ mix deps.get
  ```

  **Step 2**: Create and populate points database.
  ```bash
  $ mix ecto.reset
  ```

  **Step 3**: Start server.
  ```bash
  $ mix phoenix.server
  ```

## Begining with docker

  ```bash
  $ ./docker-server-init
  ```

## Client Tasks

  You can interact with the rest api through mix tasks without need to use curl or any rest client. This tasks actually use a rest client.

  What can you do with points api?
  Run next on points path:
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
  mix cli.roles                      # Show roles. Param: token
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
  mix cli.users.create               # Create a user. Params: token email password first_name last_name
  mix cli.users.delete               # Delete a user. Params: token email
  mix cli.users.show                 # Show a user. Params: token email
  mix cli.users.update               # Update a user. Params: token email password first_name last_name
  ```

## Docker

* docker-server-init: create/poulate database and run server in docker-compose env.
* docker-server: Run server on docker-compose env.
* docker-test: Run test on docker-compose env.
* docker-reset: Reset(drop/create/migrate/populate) database in docker-compose env.
* docker-clean: Clean(drop/create/migrate) database in docker-compose env.
