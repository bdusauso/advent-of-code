defmodule Marker do
  def packet_index(buffer) do
    marker_index(buffer, 4)
  end

  def message_index(buffer) do
    marker_index(buffer, 14)
  end

  defp marker_index(buffer, count) do
    buffer
    |> String.to_charlist()
    |> Enum.chunk_every(count, 1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.find_index(&(length(&1) == count))
    |> Kernel.+(count)
  end
end

ExUnit.start()

defmodule MarkerTest do
  use ExUnit.Case

  import Marker

  describe "packet_index/1" do
    test "return the first packet index of the marker from the buffer" do
      assert packet_index("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
      assert packet_index("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
      assert packet_index("nppdvjthqldpwncqszvftbrmjlhg") == 6
      assert packet_index("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
      assert packet_index("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
    end
  end

  describe "message_index/1" do
    test "return the first message index of the marker from the buffer" do
      assert message_index("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
      assert message_index("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
      assert message_index("nppdvjthqldpwncqszvftbrmjlhg") == 23
      assert message_index("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
      assert message_index("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
    end
  end
end

buffer = File.read!("input.txt")

buffer
|> Marker.packet_index()
|> IO.inspect(label: "Part 1")

buffer
|> Marker.message_index()
|> IO.inspect(label: "Part 2")
