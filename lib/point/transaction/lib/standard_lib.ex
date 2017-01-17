defmodule StandardLib do
  alias Point.{AccountService, ExtractService, TransferService, DepositService}
  import PointLogger
  import Enum, only: [into: 2]
  import Map, only: [to_list: 1, get: 2]

  def valid_params(params, def: definition), do: _valid_params(params, definition, "")

  def _valid_params(_, [], _), do: %{}
  def _valid_params(params, definition, path) do
    into(for {def_key, def_value} <- to_list(definition) do
      case {get(params, def_key), def_value} do
        {nil, :required} ->
          throw "#{path}#{def_key} param is required!"
        {value, :required} ->
          {def_key, value}
        {value, def_value} when is_map(def_value) ->
          {def_key, _valid_params(value || %{}, def_value, "#{path}#{def_key}.")}
        {nil, def_value} when def_value != nil ->
          info "#{path}#{def_key} param doesn't found! Use \"#{def_value}\" default value."
          {def_key, def_value}
      end
    end, %{})
  end

  def refresh(model), do: Point.Repo.refresh(model)
  def amount(account), do: AccountService.amount(account)
  def account(email: email, currency: currency) do
    case AccountService.by(email: email, currency_code: currency) do
      nil -> raise "Not found account for #{email} with #{currency} currency!"
      account -> account
    end
  end
  def transfer(from: source, to: target, amount: amount) do
    TransferService.transfer(from: source, to: target, amount: dec(amount))
  end
  def extract(amount: amount, from: account), do: ExtractService.extract(amount: dec(amount), from: account)
  def deposit(amount: amount, on: account), do: DepositService.deposit(amount: dec(amount), on: account)

  def print(message) do
    case message do
      message when is_list(message) ->
        Enum.each(message, &(info/1))
        List.last(message)
      message ->
        info(message)
        message
    end
  end

  defp dec(value), do: Decimal.new(value)
end
