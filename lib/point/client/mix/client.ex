defmodule Mix.Task.Point.Client do
  defmacro __using__(_options) do
    quote do
      use Mix.Task
      import unquote(__MODULE__)
      import Point.Client
      import PointLogger
      import Point.Config
      alias Point.JSON
      alias Point.Client.User
      alias Point.Client.ExchangeRate
      alias Point.Client.Account
      alias Point.Client.Transaction
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
