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
    end
  end

  defmacro defrun(block) do
    quote do
      def run(params) do
        try do
          unquote(block).(params) |> response
        rescue
          err -> error inspect(err)
        end
      end
    end
  end

  def response({:ok, response, _}), do: response
  def response({:error, response}), do: response
  def response(response), do: response
end
