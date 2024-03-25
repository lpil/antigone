//// Argon2 is the winner of the [Password Hashing Competition (PHC)](https://password-hashing.net).
////
//// Argon2 is a memory-hard password hashing function which can be used to hash
//// passwords for credential storage, key derivation, or other applications.
////
//// Argon2 has the following three variants (Argon2id is the default):
////
//// - Argon2d - suitable for applications with no threats from side-channel
////   timing attacks (eg. cryptocurrencies)
//// - Argon2i - suitable for password hashing and password-based key derivation
//// - Argon2id - a hybrid of Argon2d and Argon2i
////
//// Argon2i, Argon2d, and Argon2id are parametrized by:
////
//// - A **time** cost, which defines the amount of computation realized and
////   therefore the execution time, given in number of iterations
//// - A **memory** cost, which defines the memory usage, given in kibibytes
//// - A **parallelism** degree, which defines the number of parallel threads
////
//// More information can be found at the [Argon2 reference C implementation
//// repository](https://github.com/P-H-C/phc-winner-argon2) and in the
//// documentation for the [elixir_argon2](https://hex.pm/packages/argon2_elixir)
//// package.
////
//// ## Comparison with Bcrypt / Pbkdf2
////
//// Argon2 has better password cracking resistance than Bcrypt and Pbkdf2.
//// Its main advantage is that, as it is a memory-hard function, it is designed
//// to withstand parallel attacks that use GPUs or other dedicated hardware.

pub opaque type Hasher {
  Hasher(
    time_cost: Int,
    memory_cost: Int,
    parallelism: Int,
    hash_length: Int,
    argon2_type: Argon2Type,
  )
}

pub type Argon2Type {
  /// Suitable for applications with no threats from side-channel timing attacks (eg. cryptocurrencies)
  Argon2d
  /// Suitable for password hashing and password-based key derivation.
  Argon2i
  /// A hybrid of Argon2d and Argon2i. The default type.
  Argon2id
}

/// Create a new hasher with the default configuration. This can then be
/// optionally configured with the various functions of this module, and then
/// used to hash data with the `hash` function.
///
pub fn hasher() -> Hasher {
  Hasher(
    time_cost: 3,
    memory_cost: 16,
    parallelism: 4,
    hash_length: 32,
    argon2_type: Argon2id,
  )
}

/// The time cost is the number of iterations that the algorithm will
/// perform.
///
/// The default value is 3. In your tests you may to decrease this value to 1 so
/// your tests run faster. You must not decrease this value in production.
///
pub fn time_cost(hasher: Hasher, time_cost: Int) -> Hasher {
  Hasher(..hasher, time_cost: time_cost)
}

/// The memory usage cost, given in kibibytes.
///
/// The default value is 16, this will produce a memory usage of 64 MiB (2 ^ 16
/// KiB). In your tests you may to decrease this value to 8 so your tests will
/// use less memory. You must not decrease this value in production.
///
pub fn memory_cost(hasher: Hasher, memory_cost: Int) -> Hasher {
  Hasher(..hasher, memory_cost: memory_cost)
}

/// The number of threads that the algorithm will use.
///
/// The default value is 4.
///
pub fn parallelism(hasher: Hasher, parallelism: Int) -> Hasher {
  Hasher(..hasher, parallelism: parallelism)
}

/// The length of the hash in bytes.
///
pub fn hash_length(hasher: Hasher, hash_length: Int) -> Hasher {
  Hasher(..hasher, hash_length: hash_length)
}

/// The Argon2 type to use. The default is Argon2id.
///
pub fn argon2_type(hasher: Hasher, argon2_type: Argon2Type) -> Hasher {
  Hasher(..hasher, argon2_type: argon2_type)
}

/// Hash the given data with a randomly generated salt.
///
pub fn hash(hasher: Hasher, data: BitArray) -> String {
  elixir_hash(data, gen_salt(), [
    TCost(hasher.time_cost),
    MCost(hasher.memory_cost),
    HashLen(hasher.hash_length),
    Parallelism(hasher.parallelism),
    Argon2Type(case hasher.argon2_type {
      Argon2d -> 0
      Argon2i -> 1
      Argon2id -> 2
    }),
  ])
}

/// Verify in constant time that the given data matches the given hash.
///
@external(erlang, "Elixir.Argon2", "verify_pass")
pub fn verify(data: BitArray, hash: String) -> Bool

type ElixirOption {
  TCost(Int)
  MCost(Int)
  Parallelism(Int)
  HashLen(Int)
  Argon2Type(Int)
}

@external(erlang, "Elixir.Argon2.Base", "hash_password")
fn elixir_hash(
  password password: BitArray,
  salt salt: BitArray,
  options options: List(ElixirOption),
) -> String

@external(erlang, "Elixir.Argon2.Base", "gen_salt")
fn gen_salt() -> BitArray
