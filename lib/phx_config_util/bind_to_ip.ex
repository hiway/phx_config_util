defmodule PhxConfigUtil.BindToIp do
  @moduledoc """
  Parse shortcuts or string representations to IP addresses.

  # PhxConfigUtil.BindToIp.parse!/1

  Expects a string representation of an IP address
  or one of the following shortcuts:

  * `all4` - All IPv4 addresses ("0.0.0.0")
  * `all6` - All IPv6 addresses ("::")
  * `local4` - Local IPv4 address ("127.0.0.1")
  * `local6` - Local IPv6 address ("::1")
  * `tailscale4` - Tailscale IPv4 address (uses `tailscale ip -4`)
  * `tailscale6` - Tailscale IPv6 address (uses `tailscale ip -6`)

  ## Examples

      iex> PhxConfigUtil.BindToIp.parse!("all4")
      {0, 0, 0, 0}

      iex> PhxConfigUtil.BindToIp.parse!("local4")
      {127, 0, 0, 1}

      iex> PhxConfigUtil.BindToIp.parse!("all6")
      {0, 0, 0, 0, 0, 0, 0, 0}

      iex> PhxConfigUtil.BindToIp.parse!("local6")
      {0, 0, 0, 0, 0, 0, 0, 1}

      iex> PhxConfigUtil.BindToIp.parse!("172.16.0.1")
      {172, 16, 0, 1}
  """
  def parse!(bind) do
    case bind do
      "all4" -> IP.from_string!("0.0.0.0")
      "all6" -> IP.from_string!("::")
      "local4" -> IP.from_string!("127.0.0.1")
      "local6" -> IP.from_string!("::1")
      "tailscale4" -> get_tailscale_ip4() |> verify_tailscale_is_up()
      "tailscale6" -> get_tailscale_ip6() |> verify_tailscale_is_up()
      other -> IP.from_string!(other)
    end
  end

  defp get_tailscale_ip4() do
    exec_tailscale(["ip", "-4"])
  end

  defp get_tailscale_ip6() do
    exec_tailscale(["ip", "-6"])
  end

  defp verify_tailscale_is_up(ip) do
    case System.cmd("tailscale", ["status"]) do
      {_, 0} -> ip
      {_, _} -> raise "Tailscale is not running"
    end
  end

  defp exec_tailscale(args) do
    case System.cmd("tailscale", args) do
      {ip, 0} -> IP.from_string!(String.trim(ip))
      {_, _} -> raise "Failed to get IP from tailscale"
    end
  end
end
