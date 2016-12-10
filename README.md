# Points
  * Is a bank of virtual money.
  * Can be used to point management or any type of currency.
  * Each user belongs to entities.
  * Each user has many accounts.
  * Each account has an amount in a currency.
  * Two type of accounts: Backup, Default.
  * You can:
    * Deposit to backup account.
    * Extract from backup account.
    * Transfer between accounts (any type).

## Start
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Base url: localhost:4000

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
