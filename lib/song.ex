defmodule Song do

  def bottle(0), do: "no green bottles"
  def bottle(1), do: "1 green bottle"
  def bottle(n), do: "#{n} green bottles"

  def green_bottle(0), do: :ok
  def green_bottle(n) do
    IO.puts ~s{
      #{bottle(n)} hanging on the wall,
      #{bottle(n)} hanging on the wall,
      and if 1 green bottle,
      should accidentally fall,
      there'd be #{bottle(n-1)} hanging on the wall.
    }
    green_bottle(n-1)
  end


end
