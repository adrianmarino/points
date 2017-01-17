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
        perform(build_params)
      end
    end
  end

  defmacro params(block), do: quote bind_quoted: [block: block], do: @params_def block.()

  def get_def(nil), do: %{}
  def get_def([]), do: %{}
  def get_def([params_def|_]), do: params_def
end
