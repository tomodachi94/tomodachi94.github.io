---
title: "Unit testing with ComputerCraft, McFly, and CraftOS-PC"
date: 2025-02-09
draft: false
tags:
- "ComputerCraft"
- "McFly"
- "CraftOS-PC"
- "Unit testing"
- "Lua"
- "Continuous integration"
comments:
    host: floss.social
    username: tomodachi94
    id: 113976370639461037
categories:
- "Guides"
---

[Unit testing is awesome](https://www.howtogeek.com/devops/what-is-unit-testing-and-why-is-it-important/) .
It helps you catch bugs early by ensuring all of the components of your program work as expected.

**Note: This guide is targeted towards *experts* who have advanced knowledge of ComputerCraft and know a few things about unit tests.**
Experience with unit tests in another language is helpful too, but isn't required.

[CC: Tweaked](https://computercraft.cc) contains a little-known unit testing framework called **McFly**, which describes itself as "a very basic test framework for ComputerCraft" drawing inspiration from the [Busted](https://lunarmodules.github.io/busted/) framework for Lua.
This post will function as an introduction to McFly, in the process providing instructions for running the tests inside of the [CraftOS-PC emulator](https://craftos-pc.cc), suitable for running in a continuous integration pipeline.

This post assumes you have a functional library or program that you want to test, located in a locally-cloned Git repository.
It also assumes that you know how to write and execute shell scripts in Bash.

This guide assumes you have a library, located at `my_library.lua`.

## Getting McFly

McFly is available [through the CC: Tweaked GitHub repository](https://raw.githubusercontent.com/cc-tweaked/CC-Tweaked/refs/heads/mc-1.20.x/projects/core/src/test/resources/test-rom/mcfly.lua).
Download it to a memorable location inside of your repository; we chose `test/mcfly.lua`.

## Getting CraftOS-PC

This guide assumes that you want to use CraftOS-PC to run the tests outside of the game.

To install CraftOS-PC, follow the [guide on its documentation](https://www.craftos-pc.cc/docs/installation).
(I'm partial to Nix as a maintainer of its package, but I won't judge if you pick another method.)

## Make a simple test

Create a simple McFly test at `test/addition_spec.lua` (the `_spec` part is important). This will help us know if our setup works. Feel free to delete this file later once you have some tests.

```lua
-- "addition" is the name of the component you're testing,
-- usually a function.
describe("addition", function()
   it("adds two numbers correctly", function()
     expect(2 + 2):equals(4)
   end)
end)
```

## Setting up the testing environment

CraftOS-PC has [many CLI options](https://www.craftos-pc.cc/docs/cli). The ones that interest us are `--directory`, `--headless`, and `--exec`.
The first allows us to override CraftOS-PC's data directory, the second allows us to run CraftOS-PC without opening a GUI, and the third allows us to run arbitrary Lua code.

Create a new shell script with the following contents. We named it `test/test.sh`, but feel free to name it something else or integrate it into a preexisting command running solution.

```sh
#!/usr/bin/env bash
set -euo pipefail
# This script is CC0; feel free to remove this notice and modify the script however you like, with or without attribution.

# Get the root of your Git repository, for copying files into the environment later.
SOURCE_DIR="$(git rev-parse --show-toplevel)"

# Create a temporary directory for storing CraftOS-PC data.
DATA_DIR="$(mktemp -d)"
mkdir -p "$DATA_DIR/computer/0"
COMPUTER_DIR="$DATA_DIR/computer/0"

# Copy your library into the testing environment.
cp "$SOURCE_DIR/my_library.lua" "$COMPUTER_DIR"
# And your tests!
cp -r "$SOURCE_DIR/test" "$COMPUTER_DIR"

# Run CraftOS-PC in headless mode (no GUI) and with the data directory set to $DATA_DIR.
craftos --directory "$DATA_DIR" --exec 'shell.run("test/mcfly.lua test"); os.shutdown()'
```

Make sure to mark it executable with `chmod +x ./test/test.sh`.

You should see something like this in your terminal when running `test/test.sh`:

```
$ test/test.sh
Ran 1 test(s), of which 1 passed (100%).
```

Progress! We now have McFly running our tests whenever we run our script.

## Writing our tests

All that's left to do is write our tests.

I recommend incrementally writing tests for your code; if you try to write all of your tests all at once, **you will burn out** unless your library is very small.

Tests come in this general format:

```lua
describe("identify_sound", function()
   it("can identify meow", function()
     -- Load your library.
     local my_library = require("my_library")
     expect(
       -- Call your function with its parameters.
       my_library.identify_sound("meow")
     -- This is what you expect the result to be.
     -- McFly has many of these functions; see the documentation in its source code for more.
     ):equals("cat")
   end)
end)
```

McFly expects tests to be named in the format `*_spec.lua`.

If you get an error about `require`, see the next section.

## A tangent: `package.path` and `require` failing to find your library

Don't fret! If your tests fail to find your library, add this one-liner to the top of your test:

```lua
package.path = "/?.lua;/?/init.lua;" .. package.path
```

This one-liner prepends the root (`/`) directory to [`package.path`, which serves as the search path for `require`](https://www.lua.org/manual/5.1/manual.html#pdf-require).

## Running tests in GitHub Actions

This became a little bit tricky, because GitHub Actions' Ubuntu runner does not contain a `libncurses5` library.

I opted to [use Nix when I was setting up testing for libunicornpkg](https://github.com/unicornpkg/libunicornpkg/blob/cbc4beb8d2542beb016a145e44befa0360320797/.github/workflows/ci.yaml), but not everybody knows Nix so this isn't feasible for most people.

If you manage to get something non-Nix working on GitHub Actions, please let me know!

## Conclusion

Thanks for sticking with me through this abnormally large post!

If something doesn't work, I got something wrong, or I left something important out, please reach out.
