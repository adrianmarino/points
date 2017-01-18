defmodule Transaction do
  import PointLogger

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :params_def, accumulate: true
      import StandardLib
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run(params) do
        info("params_def: #{inspect get_def(@params_def)}")
        build_params = Params.valid_params(params, get_def(@params_def))
        info("params: #{build_params}")
        Point.Repo.transaction fn -> perform(build_params) end
      end
    end
  end

  defmacro defparams(do: params_def), do: quote do: @params_def unquote(params_def)

  def get_def([]), do: %{}
  def get_def([params_def|_]), do: params_def
end
