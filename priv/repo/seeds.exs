import Point.Repo
alias Point.{User, Entity, Partner, Account, Currency, ExchangeRate}

#------------------------------------------------------------------------------
# Users
#------------------------------------------------------------------------------
# Is the root user
chewbacca = insert! User.insert_changeset(%User{}, %{
  email: "chewbacca@gmail.com", password: "12345678910",
  first_name: "Chewbacca", last_name: "Chewbacca", role: :system_admin
})
obiwan_kenoby = insert! User.insert_changeset(%User{}, %{
  email: "obiwankenoby@gmail.com", password: "12345678910",
  first_name: "Obi-Wan", last_name: "Kenoby", role: :normal_user
})
anakin_skywalker = insert! User.insert_changeset(%User{}, %{
  email: "anakinskywalker@gmail.com", password: "12345678910",
  first_name: "Anakin", last_name: "Skywalker", role: :normal_user
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
  %ExchangeRate{value: Decimal.new(500), source: ars, target: empire_point},
  %ExchangeRate{value: Decimal.new(10), source: rebel_point, target: empire_point}
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
platform = insert! %Entity{name: "Point Platform", users: [chewbacca]}
revelion = insert! %Entity{name: "Rebellion",      users: [obiwan_kenoby]}
empire = insert! %Entity{name: "Empire",         users: [anakin_skywalker]}
#
#
#
#------------------------------------------------------------------------------
# Partners
#------------------------------------------------------------------------------
insert! %Partner{entity: platform, partner: revelion}
insert! %Partner{entity: platform, partner: empire}
insert! %Partner{entity: revelion, partner: empire}
