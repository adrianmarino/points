require Engine

IO.puts Engine.run(
  Transfer,
  %{
    from: %{email: "obiwankenoby@gmail.com",    currency: "RBL"},
    to:   %{email: "anakinskywalker@gmail.com", currency: "EMP"},
    amount: 100
  }
)
