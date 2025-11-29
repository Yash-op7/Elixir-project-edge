
defmodule FireflyFestival do
  @defaultFireflyCount 50
  @displayFps 30
  @frameDelay div(1000, @displayFps)

def start(), do: start([])

def start(options) do
    totalFireflies = Keyword.get(options, :count, @defaultFireflyCount)

    fireflyPids =
      Enum.map(0..(totalFireflies - 1), fn index ->
        randomClock = :rand.uniform() * 2.0

        initialFireflyState = %Firefly{
          state: :off,
          clock: randomClock,
          neighbour: nil,
          id: index
        }

        Firefly.start(initialFireflyState)
      end)

    Enum.each(0..(totalFireflies - 1), fn index ->
      currentPid = Enum.at(fireflyPids, index)
      rightNeighbourPid = Enum.at(fireflyPids, rem(index + 1, totalFireflies))
      send(currentPid, {:set_neighbour, rightNeighbourPid})
    end)

    display_loop(fireflyPids)
  end

  defp display_loop(fireflyPids) do
    fireflyStates =
      Enum.map(fireflyPids, fn fireflyPid ->
        send(fireflyPid, {:get_state, self()})

        receive do
          {:state, _id, currentStatus} -> currentStatus
        after
          50 -> :off
        end
      end)

    outputLine =
      fireflyStates
      |> Enum.map(fn
        :on -> "B"
        :off -> " "
      end)
      |> Enum.join("")

    IO.write("\e[H\e[J") #? from https://unix.stackexchange.com/questions/724177/how-to-interpret-eh-e2j-ansi-escapes-sequence-from-linux-terminal?utm_source=chatgpt.com
    IO.puts(outputLine)

    Process.sleep(@frameDelay)

    display_loop(fireflyPids)
  end
end
