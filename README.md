# Points
  Points is a platform used to foreign exchange between registered users.

  [![Build Status](https://travis-ci.org/adrianmarino/points.svg?branch=master)](https://travis-ci.org/adrianmarino/points)
  [![License](http://img.shields.io/:license-mit-blue.svg)](http://badges.mit-license.org)

# Features
  * Manage currencies, exchange rates, accounts, users, transactions, entities.
  * Use three basic transactions for increase/decrease amount on accounts:
    * Deposit an amount to backup account.
    * Extract an amount from backup account.
    * Transfer an amount between accounts(This include foreign exchange when necessary).
  * Also, include a DSL to create custom transactions at runtime.

# Requirements

* MySQL or MariaDB
* Elixir(iex/mix)

# Beginning

**Step 1:** Download project.
```bash
git clone https://github.com/adrianmarino/points.git; cd points
```
**Step 2:** Install dependencies.
```bash
mix deps.get
```
**Step 3:** Create and migrate your database.
```bash
mix ecto.create
mix ecto.migrate
```
**Step 4:** Start server.
```bash
mix phoenix.server
```

## Sign In
Request:
```
POST /api/v1/sign_in
{
  "email": "chewbacca@gmail.com",
  "password": "12345678910"
}
```
Response:
```
{
  "token": "ZTF5ejdsbENLeDlJUVhWbWpjZFFXZz09"
}
```
## Sessions
```
GET /api/v1/sessions
[
  {
    "email": "chewbacca@gmail.com",
    "timeout": "3 minutes, 12 seconds"
  }
]
```
