# Godot 2D Rhythm Game

This demo is a rhythm game designed for the course [Godot 2D Secrets](https://www.kickstarter.com/projects/gdquest/godot-2d-secrets-level-up-your-game-creation-skills).

It's currently a work-in-progress, but it has some beat patterns to play with.

![In-game](img\screen-01.png)

## Editing beat patterns

At the minute, patterns are edited using `Patterns.tscn`. Each pattern should have 8 beats, including rests. The demo has three patterns that are repeated three times. The track is built by grabbing all available patterns in `Patterns.tscn` from top to bottom of the scene tree. This process repeats if there aren't enough patterns needed for the track.

![Pattern editor](img\screen-03.png)

➡ Follow us on [Twitter](https://twitter.com/NathanGDQuest) and [YouTube](https://www.youtube.com/c/gdquest/) for free game creation tutorials, tips, and news!
