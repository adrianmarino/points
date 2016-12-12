defmodule Point.ModelUtil do
    defmacro map_from(changeset, from, to: to, resolver: resolver) do
      quote do
        case unquote(changeset) do
          %Ecto.Changeset{changes: %{unquote(from) => value}} ->
            case unquote(resolver).(value) do
              nil -> add_error(unquote(changeset), :missing, "#{value} #{unquote(from)} is missing")
              model -> unquote(changeset) |> put_change(unquote(to), model.id)
            end
          _  -> unquote(changeset)
        end
      end
    end
end
