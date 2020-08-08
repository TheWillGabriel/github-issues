defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command-line parsing and dispatch to various
  functions that will fetch and display a table of the
  last _n_ issues in a GitHub project
  """

  def run(argv) do
    parse_args(argv)
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
end
