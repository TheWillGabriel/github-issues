defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command-line parsing and dispatch to various
  functions that will fetch and display a table of the
  last _n_ issues in a GitHub project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github username, project name, and
  (optionally) the number of entries to display.

  Return a tuple of `{user, project, count}`, or `:help`
  if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal
  end

  def args_to_internal([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal([user, project]) do
    {user, project, @default_count}
  end

  # bad arg or --help
  def args_to_internal(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_descending
    |> last(count)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def sort_descending(issue_list) do
    issue_list
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")
    System.halt(2)
  end
end
