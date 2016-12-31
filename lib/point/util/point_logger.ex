defmodule PointLogger do
  require Logger

  def info(Tuple = tuple), do: info(to_string tuple)
  def info(%Point.ExchangeRate{} = model), do: Logger.info("Rate: #{to_string model}")
  def info(%Point.Movement{} = model), do: Logger.info("Movement: #{to_string model}")
  def info(%Point.Account{} = model), do: Logger.info("Account: #{to_string model}")
  def info(message), do: Logger.info(message)

  def warn(message), do: Logger.warn(message)
  def error(message), do: Logger.error(message)
  def debug(message), do: Logger.debug(message)
end
