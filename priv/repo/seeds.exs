import Point.Repo
alias Point.{User, Entity, Account, Currency, ExchangeRate}

#------------------------------------------------------------------------------
# Users
#------------------------------------------------------------------------------
# Is the root user
chewbacca = insert! User.registration_changeset(%User{}, %{
  email: "chewbacca@gmail.com", password: "12345678910",
  first_name: "Chewbacca", last_name: "Chewbacca"
})
obiwan_kenoby = insert! User.registration_changeset(%User{}, %{
  email: "obiwankenoby@gmail.com", password: "12345678910",
  first_name: "Obi-Wan", last_name: "Kenoby"
})
anakin_skywalker = insert! User.registration_changeset(%User{}, %{
  email: "anakinskywalker@gmail.com", password: "12345678910",
  first_name: "Anakin", last_name: "Skywalker"
})
#
#
#
#------------------------------------------------------------------------------
# Currencies
#------------------------------------------------------------------------------
ars = insert! %Currency{code: "ARS", name: "Pesos", issuer: chewbacca}
rebel_point = insert! %Currency{
  code: "RBL", name: "Rebel Points", issuer: chewbacca
}
empire_point = insert! %Currency{
  code: "EMP", name: "Empire Points", issuer: chewbacca
}
#
#
#
#------------------------------------------------------------------------------
# Exchange rates
#------------------------------------------------------------------------------
insert_all [
  %ExchangeRate{value: Decimal.new(1000), source: ars, target: rebel_point},
  %ExchangeRate{value: Decimal.new(500), source: ars, target: empire_point}
]
#
#
#
#------------------------------------------------------------------------------
# Accounts
#------------------------------------------------------------------------------
initial_amount = Decimal.new(10000)

insert! %Account{
  amount: initial_amount, type: "backup", currency: ars,
  owner: chewbacca, issuer: chewbacca
}
insert! %Account{
  amount: initial_amount, type: "default", currency: rebel_point,
  owner: obiwan_kenoby, issuer: chewbacca
}
insert! %Account{
  amount: initial_amount, type: "default", currency: empire_point,
  owner: anakin_skywalker, issuer: chewbacca
}
#
#
#
#------------------------------------------------------------------------------
# Entities
#------------------------------------------------------------------------------
insert! %Entity{name: "Point Platform", users: [chewbacca]}
insert! %Entity{name: "Rebellion",      users: [obiwan_kenoby]}
insert! %Entity{name: "Empire",         users: [anakin_skywalker]}
