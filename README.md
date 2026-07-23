# Terminal Pet for Fish

A tiny blue cat that lives above your Fish shell prompt and reacts to what
happens in your terminal.

```text
 /ᐠ｡ꞈ｡ᐟ\
```

## Reactions

- Picks a random happy face after successful commands.
- Turns red when a command fails.
- Looks shocked after commands that commonly produce lots of output.
- Cries and points a laser toward failed compiler, build, package, and test
  commands.

## Requirements

- [Fish shell](https://fishshell.com/)
- A terminal font containing the Unicode characters used by the cat

No runtime dependencies are required.

## Install

```fish
mkdir -p ~/.config/fish/conf.d
curl -fsSL \
  https://raw.githubusercontent.com/arielportal2401-cyber/terminal-pet-fish/main/terminal-pet.fish \
  -o ~/.config/fish/conf.d/terminal-pet.fish
```

Open a new terminal or source the file:

```fish
source ~/.config/fish/conf.d/terminal-pet.fish
```

## Commands

```fish
pet on
pet off
pet status
```

The on/off state lasts for the current shell session.

## How detection works

Fish does not expose the number of output lines produced by the previous
command. To avoid intercepting output and breaking interactive programs, the
pet recognizes commands that are commonly verbose. Critical errors are detected
from a nonzero exit status combined with a known build, compiler, package, or
test command.

## License

MIT
