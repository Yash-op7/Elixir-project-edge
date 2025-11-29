# FireflyFestival

Round 2 take home assignment, by Yash Meena for EDGE industries

What I did:
1. Read the docs, and understood the concepts using GPT. (starting from https://hexdocs.pm/elixir/introduction.html till https://hexdocs.pm/elixir/processes.html), practiced basic examples for each page.
2. Started implementation by creating a new project with `mix new firefly_festival`
3. Modelled the problem into 2 modules, the FireflyFestival and the Firefly, the firefly festival is where the fireflies will be spawned and interact and observed, whereas the Firefly module encapsulates individual firefly's logic.
4. Since each firefly only listens to its left neighbour, I only track and send data to the right firefly instead of broadcasting.

## Summary

This project simulates 50 fireflies arranged in a ring, each running as its own Elixir process. Every firefly keeps track of its internal timer, switches between ON/OFF states, and reacts to blink messages from its left neighbour. Over time, the system naturally synchronizes.

## What I did

Implemented a Firefly process loop handling :tick, :blink, and neighbour updates.

Spawned 50 fireflies, assigned neighbours in a ring, and gave each random initial clocks between 0–2 seconds.

Added a central display loop that queries all fireflies ~30 times per second and prints a single line showing ON (B) vs OFF.

## How to run

```sh
mix compile
iex -S mix
FireflyFestival.start()
```

Press Ctrl+C twice to stop.

## Final Notes:
I used formatter to format the code and the fireflies dont seem to synchronize even after a while.

I apologize if this document and/or the project seems ad/hoc, I didnt have much time due to my current daily work. Hope to hear back from you and schedule the discussion round.