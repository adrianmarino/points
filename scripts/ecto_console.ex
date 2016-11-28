alias Point.{Repo, Model, Account}
import Repo

account = get_by(Account, id: 1)
IO.puts "Before update: #{Model.to_string(account)}"

save(account, %{amount: 20000})

account = get_by(Account, id: 1)
IO.puts "After update: #{Model.to_string(account)}"

save(account, %{amount: 15000})
