defmodule Transaction do
  use Behaviour

  defmacro __using__(_) do
    quote do
      import StandardLib
      @behaviour Transaction
    end
  end

  defcallback perform(params:: %{})
end
