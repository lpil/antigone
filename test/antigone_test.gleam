import antigone
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn hash_verify_test() {
  let hash =
    antigone.hasher()
    |> antigone.hash(<<"blink182":utf8>>)
  let assert True = antigone.verify(<<"blink182":utf8>>, hash)
  let assert False = antigone.verify(<<"hunter2":utf8>>, hash)
}

pub fn hash_verify_unicode_test() {
  let hash =
    antigone.hasher()
    |> antigone.hash(<<"hunter2😎":utf8>>)
  let assert True = antigone.verify(<<"hunter2😎":utf8>>, hash)
  let assert False = antigone.verify(<<"hunter2🤔":utf8>>, hash)
}

pub fn hash_verify_nonunicode_test() {
  let password = <<0, 0, 0>>
  let hash = antigone.hash(antigone.hasher(), password)
  let assert True = antigone.verify(password, hash)
  let assert False = antigone.verify(<<0>>, hash)
}

pub fn configure_test() {
  let hash =
    antigone.hasher()
    |> antigone.parallelism(2)
    |> antigone.memory_cost(9)
    |> antigone.time_cost(2)
    |> antigone.hash_length(64)
    |> antigone.hash(<<"hunter2😎":utf8>>)
  let assert "$argon2id$v=19$m=512,t=2,p=2$" <> _ = hash
}

pub fn readme_low_cost_example_test() {
  let password = "blink182"
  let hash =
    antigone.hasher()
    |> antigone.time_cost(1)
    |> antigone.memory_cost(8)
    |> antigone.hash(<<password:utf8>>)
  let assert "$argon2id$v=19$m=256,t=1,p=4$" <> _ = hash
}

pub fn fake_verify_test() {
  // Check fake_verify is callable without failure
  antigone.hasher()
  |> antigone.time_cost(1)
  |> antigone.memory_cost(8)
  |> antigone.fake_verify()
}
