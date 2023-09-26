defmodule HTTP do
  require Logger

  @spec get!(binary, HTTPoison.headers(), Keyword.t()) :: HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()
  def get!(url, headers \\ [], options \\ []) do
    Logger.debug("Sending request GET #{url}.")

    HTTPoison.get!(url, headers, options)
  end
end
