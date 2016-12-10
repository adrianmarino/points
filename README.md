# Point
  * A bank of points.
  * Each user has many accounts.
  * An user belongs to entities.
  * Each account has an amount in a currency.
  * Two type of accounts: Backup, Default.
  * You can:
    * Deposit to backup account.
    * Extract from backup account.
    * Transfer between accounts.

## Start
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

## Sign In
  * Endpoint: [`localhost:4000/api/v1/sign_in`](http://localhost:4000/api/v1/sign_in)
  * Method: POST
  * Request Body: ```{ "email": "chewbacca@gmail.com", "password": "12345678910" }```
  * Response Body: ```{ "token": "ZTF5ejdsbENLeDlJUVhWbWpjZFFXZz09" }```

## Get sessions
    * Endpoint: [`localhost:4000/api/v1/sessions`](http://localhost:4000/api/v1/sessions)
    * Method: GET
    * Response Body: ```[ {"email": "chewbacca@gmail.com", "timeout": "3 minutes, 12 seconds"} ]```
