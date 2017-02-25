defmodule Mix.Task.Point.Client do
  defmacro __using__(_options) do
    quote do
      use Mix.Task
      import unquote(__MODULE__)
      import Point.Client
      import PointLogger
      import Point.Config
      alias Point.JSON
      alias Point.Client.Dto.Session
      alias Point.Client.Dto.User
      alias Point.Client.Dto.ExchangeRateId
      alias Point.Client.Dto.ExchangeRate
      alias Point.Client.Dto.Account
      alias Point.Client.Dto.Transaction
      alias Point.Client.Dto.Currency
      alias Point.Client.Dto.AccountMovement
      alias Point.Client.Dto.Between
      alias Point.Client.Dto.Entity
      alias Point.Client.Dto.Partner
    end
  end

  defmacro defrun(block) do
    quote do
      def run(params), do: unquote(block).(params) |> response
    end
  end

  def response({:ok, response, _}), do: response
  def response({:error, response}), do: response
  def response(response), do: response
end
