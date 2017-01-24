defmodule Mix.Task.PointClient do
  defmacro __using__(_options) do
    quote do
      use Mix.Task
      import unquote(__MODULE__)
      import List
      import Point.Client
      import PointLogger
      import Point.Config
    end
  end

  defmacro defrun(block), do: quote do: def run(params), do: unquote(block).(params) |> response

  def response({:ok, response, _}), do: response
  def response({:error, response}), do: response
  def response(response), do: response
end
