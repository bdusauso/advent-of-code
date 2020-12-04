defmodule Passport do
  @mandatory_fields ~w(byr iyr eyr hgt hcl ecl pid)
  @mandatory_fields_length length(@mandatory_fields)

  @spec valid?(String.t(), map()) :: boolean()
  def valid?(passport, rules \\ %{})
  def valid?(passport, _) when length(passport) != @mandatory_fields_length, do: false
  def valid?(_, rules) when map_size(rules) == 0, do: true
  def valid?(passport, rules) do
    Enum.all?(passport, fn {field, value} ->
      if rules[field], do: rules[field].(value), else: false
    end)
  end

  @spec split_passports(list(String.t())) :: list(tuple())
  def split_passports(passports) do
    Enum.reduce(passports, [], fn
      elem, [] ->
        [[elem]]

      {field, _} = elem, [treated | _] = acc ->
        if field in Enum.map(treated, &elem(&1, 0)),
          do: [[elem] | acc],
          else: List.replace_at(acc, 0, [elem | treated])
    end)
  end
end
optionals = ~w(cid)

input =
  "input.txt"
  |> File.read!()
  |> String.replace(~r/\s+/, " ")
  |> String.trim()
  |> String.split()
  |> Enum.map(&(&1 |> String.split(":") |> List.to_tuple()))
  |> Enum.reject(fn {field, _} -> field in optionals end)
  |> Passport.split_passports()

input
|> Enum.count(&Passport.valid?/1)
|> IO.inspect(label: "Part 1")
