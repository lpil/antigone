# antigone

Argon2 password hashing for Gleam.

[![Package Version](https://img.shields.io/hexpm/v/antigone)](https://hex.pm/packages/antigone)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/antigone/)

This package uses the [elixir_argon2](https://github.com/riverrun/argon2_elixir)
library, so you will need to have Elixir installed and be running on Erlang to
use this package.

```sh
gleam add antigone
```
```gleam
import antigone

pub fn main() {
  // You've got a password or token you wish to hash so that you can verify it
  // later without having to store the password or hash itself.
  let password = "blink182"

  // Hash the password with the default configuration:
  antigone.hash(antigone.hasher(), password)
  // -> "$argon2id$v=19$m=65536,t=3,p=4$h1bn4Va1EXJ+kReN0/q45Q$KMj1OQV0tueWPFKw97bB+RVGsYgdPpiVxZibzbc3dBw"

  // Alternatively you can specify your own configuration.
  // Here we are lowering the costs to make the hashing faster. You may want to
  // do this in your tests, but you must never do this in production.
  antigone.hasher()
  |> antigone.time_cost(1)
  |> antigone.memory_cost(8)
  |> antigone.hash(password)
  // -> "$argon2id$v=19$m=256,t=1,p=4$Q7MevutDdDKNtKFvygG7QQ$Ta+IOOaBq6iOfvUqBvehHmnVUzjpzOV7g3B+3VKqLfo"
}
```

Further documentation can be found at <https://hexdocs.pm/antigone>.

### Why it is called Antigone?

I really liked X2: The Threat as a kid.
