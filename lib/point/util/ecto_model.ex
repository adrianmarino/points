defmodule Point.EctoModel do

  defmacro map_from(changeset, from, to: to, resolver: resolver) do
    quote bind_quoted: [changeset: changeset, from: from, to: to, resolver: resolver] do
      case changeset do
        %Ecto.Changeset{changes: %{^from => value}} ->
          case resolver.(value) do
            nil -> add_error(changeset, :missing, "#{value} #{from} is missing")
            model -> changeset |> put_change(to, model.id)
          end
        _  -> changeset
      end
    end
  end

  defmacro set_default_value_to(changeset, field: field, value: default_value) do
    quote bind_quoted: [changeset: changeset, field: field, default_value: default_value] do
      case changeset do
        %Ecto.Changeset{changes: %{^field => current_value}} ->
          case current_value do
            nil -> changeset |> put_change(field, default_value)
            _ -> changeset
          end
        _  -> changeset |> put_change(field, default_value)
      end
    end
  end
end
