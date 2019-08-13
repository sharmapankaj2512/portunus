defmodule Portunus.Protocol do
  @callback marshal(atom) :: String.t
  @callback unmarshal(String.t) :: [String.t]
end
