defmodule Transaction do
  alias Point.{StopWatch, Repo, JSON}

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :params_def, accumulate: true
      import StandardLib
      import PointLogger
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run(params) do
        info "Begin Transation."
        params = valid_params(params)
        stop_watch = StopWatch.begin
        result = Repo.transaction fn -> perform(params) end
        info "Transaction Result: #{result}"
        info "End Transaction (Elapsed Time: #{stop_watch})."
        result
      end

      defp valid_params(params) do
        build_params = Params.valid_params(params, get_def(@params_def))
        info("Transaction Params: #{JSON.to_pretty_json build_params}")
        build_params
      end

      defp get_def([]), do: %{}
      defp get_def([params_def|_]), do: params_def
    end
  end

  defmacro defparams(do: params_def), do: quote do: @params_def unquote(params_def)
end
