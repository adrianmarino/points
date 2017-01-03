require Engine
Code.require_file("scripts/example.exs")

Engine.run(
  Example,
  params: %{
    from: %{email: "obiwankenoby@gmail.com",    currency: "RBL"},
    to:   %{email: "anakinskywalker@gmail.com", currency: "EMP"},
    amount: 100
  }
)
