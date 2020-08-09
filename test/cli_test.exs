defmodule CliTestTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

  test ":help returned by option parsing with -h and --help flags" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending orders correct way" do
    result = sort_descending(dummy_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp dummy_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data" => "xyz"}
  end
end
