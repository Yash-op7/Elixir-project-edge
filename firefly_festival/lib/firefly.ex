defmodule Firefly do
  defstruct state: :off, clock: 0.0, neighbour: nil, id: nil

  def start(initialState) do
    myPid =
      spawn(fn ->
        Process.send_after(self(), :tick, 100)
        loop(initialState)
      end)

    myPid
  end

  defp loop(currentState) do
    receive do
      {:set_neighbour, neighbourPid} ->
        updatedState = %{currentState | neighbour: neighbourPid}
        loop(updatedState)

      :tick ->
        newerState = handle_tick(currentState)
        Process.send_after(self(), :tick, 100)
        loop(newerState)

      :blink ->
        afterBlinkState = handle_blink(currentState)
        loop(afterBlinkState)

      {:get_state, whoeverAsked} ->
        send(whoeverAsked, {:state, currentState.id, currentState.state})
        loop(currentState)
    end
  end

  defp handle_tick(currentState) do
    stateAfterClockDecrease = %{currentState | clock: currentState.clock - 0.1}

    cond do
      # OFF → ON transition
      stateAfterClockDecrease.state == :off and stateAfterClockDecrease.clock <= 0.0 ->
        turnOnState = %{stateAfterClockDecrease | state: :on, clock: 0.5}

        if turnOnState.neighbour != nil do
          send(turnOnState.neighbour, :blink)
        end

        turnOnState

      # ON → OFF transition
      stateAfterClockDecrease.state == :on and stateAfterClockDecrease.clock <= 0.0 ->
        %{stateAfterClockDecrease | state: :off, clock: 2.0}

      # otherwise just keep the updated clock
      true ->
        stateAfterClockDecrease
    end
  end

  defp handle_blink(currentState) do
    if currentState.state == :off do
      blinkAdjustment = 1.0
      newClockValue = max(currentState.clock - blinkAdjustment, 0.0)
      %{currentState | clock: newClockValue}
    else
      currentState
    end
  end
end
