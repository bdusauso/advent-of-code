defmodule Passphrase do

  def valid?(passphrase, func) do
    func.(passphrase)  
  end
  
  def has_duplicates?(passphrase) do
    words = String.split(passphrase)
    Enum.uniq(words) != words
  end

  def has_anagrams?(passphrase) do
    words = String.split(passphrase)
    Enum.any?(words, fn word_a ->
      without_a = List.delete(words, word_a)
      sorted_a  = sort(word_a)
      
      without_a |> Enum.any?(&(sort(&1) == sorted_a))
    end)
  end
  
  def from_file(file) do
    file
    |> File.read!()
    |> String.trim
    |> String.split("\n")
  end

  defp sort(word), do: word |> String.codepoints |> Enum.sort
end

ExUnit.start

defmodule PassphraseTest do
  use ExUnit.Case, async: true

  test "'aa bb cc dd ee' does not contain duplicates" do
    refute Passphrase.has_duplicates?("aa bb cc dd ee")
  end

  test "'aa bb cc dd aa' contains duplicates" do
    assert Passphrase.has_duplicates?("aa bb cc dd aa")
  end

  test "'aa bb cc dd aaa' does not contain duplicates" do
    refute Passphrase.has_duplicates?("aa bb cc dd aaa")
  end

  test "'abcde' is an anagram of 'ecdab'" do
    assert Passphrase.has_anagrams?("abcde xyz ecdab")
  end

  test "'a ab abc abd abf abj' does not contain anagrams" do
    refute Passphrase.has_anagrams?("a ab abc abd abf abj")
  end
  
  test "'iiii oiii ooii oooi oooo' does not contains anagrams" do
    refute Passphrase.has_anagrams?("iiii oiii ooii oooi oooo")
  end

  test "'oiii ioii iioi iiio' contains anagrams" do
    assert Passphrase.has_anagrams?("oiii ioii iioi iiio")
  end
end

passphrases = "input.txt" |> Passphrase.from_file

[&Passphrase.has_duplicates?/1, &Passphrase.has_anagrams?/1]
|> Enum.each(fn predicate ->
  passphrases
  |> Enum.reject(predicate)
  |> length
  |> IO.puts
end)
