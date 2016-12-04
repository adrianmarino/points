IO.puts "EXEC SEEDS!!!!!!"

import Point.Repo
alias Point.{User, Entity, Account, Currency, ExchangeRate, Movement}
#------------------------------------------------------------------------------
# Users
#------------------------------------------------------------------------------
root = insert! %User{
  email: "jangofett@gmail.com", password: "1234A", first_name: "Jango", last_name: "Fett"
}
obiwan_kenoby = insert! %User{
  email: "obiwankenoby@gmail.com", password: "1234B", first_name: "Obi-Wan", last_name: "Kenoby"
}
quigon_jinn = insert! %User{
  email: "quigonjinn@gmail.com", password: "1234B", first_name: "Qui-Gon", last_name: "Jinn"
}
#
#
#
#------------------------------------------------------------------------------
# Currencies
#------------------------------------------------------------------------------
# Real
ars = insert! %Currency{code: "ARS", name: "Pesos", issuer: root}
# Virtual
rio_points = insert! %Currency{code: "RIO", name: "Rio Points", issuer: root}
santander_points = insert! %Currency{code: "STD", name: "Santander Points", issuer: root}
#
#
#
#------------------------------------------------------------------------------
# Exchange rates
#------------------------------------------------------------------------------
# Rio points
insert_all [
  %ExchangeRate{value: 1, source: ars,               target: rio_points},
  %ExchangeRate{value: 2, source: rio_points,        target: ars},
# Santander Points
  %ExchangeRate{value: 3, source: ars,               target: santander_points},
  %ExchangeRate{value: 4, source: santander_points,  target: ars},
]
#
#
#
#------------------------------------------------------------------------------
# Accounts
#------------------------------------------------------------------------------
# Backup
backup_account = insert! %Account{
  amount: 15000, type: "backup", currency: ars, owner: root, issuer: root
}
# Points
obiwan_acount = insert! %Account{
  amount: 5000, type: "default", currency: rio_points, owner: obiwan_kenoby, issuer: root
}
quigon_acount = insert! %Account{
  amount: 10000, type: "default", currency: santander_points, owner: quigon_jinn, issuer: root
}
#
#
#
#------------------------------------------------------------------------------
# Entities
#------------------------------------------------------------------------------
platform  = insert! %Entity{name: "Point Platform", users: [root]}
rio       = insert! %Entity{name: "Rio",            users: [obiwan_kenoby]}
boston    = insert! %Entity{name: "Boston",         users: [quigon_jinn]}
#
#
#
#------------------------------------------------------------------------------
# Movements
#------------------------------------------------------------------------------
transfer = insert! %Movement{
  type: "transfer", amount: 10, source: obiwan_acount, target: quigon_acount, rate: 1
}
