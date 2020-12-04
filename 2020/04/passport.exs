defmodule Passport do
  @type field_pair() :: {String.t(), String.t()}
  @type passport() :: list(field_pair())

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

  @spec split_passports(list(String.t())) :: list(passport())
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

defmodule InputSanitizer do
  @optionals ~w(cid)

  @type field_pair() :: {String.t(), String.t()}

  @spec sanitize(String.t()) :: list(field_pair())
  def sanitize(input) do
    input
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> String.split()
    |> Enum.map(&(&1 |> String.split(":") |> List.to_tuple()))
    |> Enum.reject(fn {field, _} -> field in @optionals end)
  end
end

passports =
  "input.txt"
  |> File.read!()
  |> InputSanitizer.sanitize()
  |> Passport.split_passports()

passports
|> Enum.count(&Passport.valid?/1)
|> IO.inspect(label: "Part 1")

rules = %{
  "byr" => &(&1 =~ ~r/19[^0-1]\d|200[0-2]/),
  "iyr" => &(&1 =~ ~r/20(1\d|20)/),
  "eyr" => &(&1 =~ ~r/20(2\d|30)/),
  "hgt" => &(&1 =~ ~r/1([5-8]\d|9[0-3])cm|(59|6\d|7[0-6])in/),
  "hcl" => &(&1 =~ ~r/#[0-9a-f]{6}/),
  "ecl" => &(&1 =~ ~r/amb|blu|brn|gry|grn|hzl|oth/),
  "pid" => &(&1 =~ ~r/\d{9}/)
}

passports
|> Enum.count(&Passport.valid?(&1, rules))
|> IO.inspect(label: "Part 2")
