import Point.Repo
alias Point.{User, Entity, Account, Currency, ExchangeRate, Movement}
#------------------------------------------------------------------------------
# Users
#------------------------------------------------------------------------------
root = %User{
  email: "jangofett@gmail.com", password: "1234A", first_name: "Jango", last_name: "Fett"
}
obiwan_kenoby = %User{
  email: "obiwankenoby@gmail.com", password: "1234B", first_name: "Obi-Wan", last_name: "Kenoby"
}
quigon_jinn = %User{
  email: "quigonjinn@gmail.com", password: "1234B", first_name: "Qui-Gon", last_name: "Jinn"
}
insert_all [root, obiwan_kenoby, quigon_jinn]
#
#
#
#------------------------------------------------------------------------------
# Currencies
#------------------------------------------------------------------------------
# Real
ars = %Currency{code: "ARS", name: "Pesos", issuer: root}
# Virtual
rio_points = %Currency{code: "RIO", name: "Rio Points", issuer: root}
santander_points = %Currency{code: "STD", name: "Santander Points", issuer: root}

insert_all [ars, rio_points, santander_points]
#
#
#
#------------------------------------------------------------------------------
# Exchange rates
#------------------------------------------------------------------------------
# Rio points
insert_all [
  %ExchangeRate{value: 1, source: ars,               target: rio_points},
  %ExchangeRate{value: 1, source: rio_points,        target: ars},
# Santander Points
  %ExchangeRate{value: 1, source: ars,               target: santander_points},
  %ExchangeRate{value: 1, source: santander_points,  target: ars},
]
#
#
#
#------------------------------------------------------------------------------
# Accounts
#------------------------------------------------------------------------------
# Backup
backup_account = %Account{
  amount: 15000, type: "backup", currency: ars, owner: root, issuer: root
}
# Points
obiwan_acount = %Account{
  amount: 5000, type: "default", currency: rio_points, owner: obiwan_kenoby, issuer: root
}
quigon_acount = %Account{
  amount: 10000, type: "default", currency: santander_points, owner: quigon_jinn, issuer: root
}
insert_all [backup_account, obiwan_acount, quigon_acount]
#
#
#
#------------------------------------------------------------------------------
# Entities
#------------------------------------------------------------------------------
platform  = %Entity{name: "Point Platform", users: [root]}
rio       = %Entity{name: "Rio",            users: [obiwan_kenoby]}
boston    = %Entity{name: "Boston",         users: [quigon_jinn]}

insert_all [platform, rio, boston]
#
#
#
#------------------------------------------------------------------------------
# Movements
#------------------------------------------------------------------------------
transfer = %Movement{
  type: "transfer", amount: 10, source: obiwan_acount, target: quigon_acount, rate: 1
}
insert_all [transfer]
