defmodule ScratchCards do
  @line ~r/Card\s+(?<card_id>\d+):\s+(?<winnings>(\d{1,2}\s*)+)\s+\|\s+(?<hand>(\d{1,2}\s*)+)/

  def parse_line(line) do
    %{"card_id" => card_id, "hand" => hand, "winnings" => winnings} =
      Regex.named_captures(@line, line)

    card_id = String.to_integer(card_id)
    hand = hand |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    winnings = winnings |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

    {card_id, winnings, hand}
  end

  def points(winnings, hand) do
    winning_count = hand |> Enum.filter(&(&1 in winnings)) |> length()

    case winning_count do
      0 -> 0
      n -> 2 ** (n - 1)
    end
  end
end

input =
  "input.txt"
  |> File.stream!()
  |> Enum.map(&String.trim/1)

input
|> Enum.map(&ScratchCards.parse_line/1)
|> Enum.map(fn {_, winnings, hand} -> ScratchCards.points(winnings, hand) end)
|> Enum.sum()
|> IO.inspect(label: "Part 1")
