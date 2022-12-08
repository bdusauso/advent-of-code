# [C]         [S] [H]
# [F] [B]     [C] [S]     [W]
# [B] [W]     [W] [M] [S] [B]
# [L] [H] [G] [L] [P] [F] [Q]
# [D] [P] [J] [F] [T] [G] [M] [T]
# [P] [G] [B] [N] [L] [W] [P] [W] [R]
# [Z] [V] [W] [J] [J] [C] [T] [S] [C]
# [S] [N] [F] [G] [W] [B] [H] [F] [N]
#  1   2   3   4   5   6   7   8   9

defmodule SupplyStacks do
  def move_one_by_one(stacks, {0, _, _}), do: stacks

  def move_one_by_one(stacks, {count, from, to}) do
    {elem_to_move, new_from} =
      stacks
      |> Enum.at(from - 1)
      |> List.pop_at(0)

    new_to =
      stacks
      |> Enum.at(to - 1)
      |> List.insert_at(0, elem_to_move)

    new_stacks =
      stacks
      |> List.replace_at(from - 1, new_from)
      |> List.replace_at(to - 1, new_to)

    move_one_by_one(new_stacks, {count - 1, from, to})
  end

  def move_all_at_once(stacks, {count, from, to}) do
    source = Enum.at(stacks, from - 1)
    {elems_to_move, new_from} = {Enum.take(source, count), Enum.drop(source, count)}

    new_to = Enum.concat(elems_to_move, Enum.at(stacks, to - 1))

    stacks
    |> List.replace_at(from - 1, new_from)
    |> List.replace_at(to - 1, new_to)
  end
end

defmodule Input do
  @regex ~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/

  def sanitize(input) do
    input
    |> String.split("\n\n")
    |> Enum.at(1)
    |> String.split("\n")
    |> Enum.map(fn instruction ->
      [_, count, from, to] = Regex.run(@regex, instruction)

      [count, from, to]
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end
end

# [[?N, ?Z], [?D, ?C, ?M], [?P]]
# |> SupplyStacks.move_all_at_once({1, 2, 1})
# |> SupplyStacks.move_all_at_once({3, 1, 3})
# |> SupplyStacks.move_all_at_once({2, 2, 1})
# |> SupplyStacks.move_all_at_once({1, 1, 2})
# |> dbg()

stacks = [
  [?C, ?F, ?B, ?L, ?D, ?P, ?Z, ?S],
  [?B, ?W, ?H, ?P, ?G, ?V, ?N],
  [?G, ?J, ?B, ?W, ?F],
  [?S, ?C, ?W, ?L, ?F, ?N, ?J, ?G],
  [?H, ?S, ?M, ?P, ?T, ?L, ?J, ?W],
  [?S, ?F, ?G, ?W, ?C, ?B],
  [?W, ?B, ?Q, ?M, ?P, ?T, ?H],
  [?T, ?W, ?S, ?F],
  [?R, ?C, ?N]
]

input =
  File.read!("input.txt")
  |> Input.sanitize()

input
|> Enum.reduce(stacks, &SupplyStacks.move_one_by_one(&2, &1))
|> Enum.map(&List.first/1)
|> IO.inspect(label: "Part 1")

input
|> Enum.reduce(stacks, &SupplyStacks.move_all_at_once(&2, &1))
|> Enum.map(&List.first/1)
|> IO.inspect(label: "Part 2")
