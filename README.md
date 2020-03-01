# IG wrapper

[![Build Status](https://travis-ci.com/frathon/ig.svg?branch=master)](https://travis-ci.com/frathon/ig)

Wrapper for the [IG API](https://labs.ig.com/rest-trading-api-guide).

## Work in progress!!

## Contributing

### Setting up environment

* Clone the repository
* cd into main directory and run `mix deps.get`
* go to config/config.exs and uncomment line at the bottom (`import_config "secret.exs"`)
* copy across `:ig :users` config into `secret.exs`
* amend the details inside `secret.exs` so they are real IG's details

### Confirming setup

* run `mix test` inside main directory - it should be green
* run `iex -S mix` inside main directory and you should get the following results:
  ```
    iex(1)> {:ok, pid} = Ig.start_link()
    {:ok, #PID<0.1351.0>}
    iex(2)> {:ok, user_pid} = Ig.get_user(:user_name, pid)
    {:ok, #PID<0.1352.0>}
    iex(3)> {:ok, %Ig.User.State{}} = Ig.User.login(user_pid)
    {:ok,
        %Ig.User.State{
        ...
        }
    }
    iex(3)> {:ok, [%Ig.Account{}|_]} = Ig.User.accounts(user_pid)
    {:ok,
      [
        %Ig.Account{
          ...
        },
        %Ig.Account{
          ...
        }
      ]
    }
  ```

  Above confirms that you are able to start IG processes tree, login and run sample call requiring that login.

### Adding tests

* go to `test/ig_test.exs` and copy single test for example one starting with `test "fetch accounts" do`
* change the test description
* change the cassette name named inside `use_cassette`
* write your test
* after first time `vcr` package will record the request / response to file inside `/fixture` directory
* all next requests will be using the cassette

## License

MIT
