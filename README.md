# Devito
![](https://i.imgur.com/dEGXMrD.png)

 An Elixir and CubDB based url shortener.

## TODO

- make cubdb for test env that is created/deleted each run

## Configuration
Authorization is handled via an API token. You must pass `auth_token=<VALUE>` with each request, and that token will be matched against the ENV VAR `AUTH_TOKEN`. The values cannot be set to `nil`.

Configure the application's short_code_chars to a list of values you want the short_code to be generated from.

`config :devito,
  short_code_chars: []`

## Running Locally

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
