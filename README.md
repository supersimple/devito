# Devito
![](https://github.com/supersimple/devito/blob/main/devito-sm.png?raw=true)

 An Elixir and CubDB based url shortener.

## Interface
Devito is designed to be used with the [Devito CLI](https://github.com/supersimple/devito_cli/). Although you can also interface it using HTTP.

## Configuration
Authorization is handled via an API token. You must pass `auth_token=<VALUE>` with each request, and that token will be matched against the ENV VAR `AUTH_TOKEN`. The values cannot be set to `nil`.

Configure the application's short_code_chars to a list of values you want the short_code to be generated from.

`config :devito,
  short_code_chars: []`

## Endpoints
| Method | Path | Description | Required Params | Optional Params |
|--------|------|-------------|-----------------|-----------------|
| GET | /api/ | Index of all links | auth_token=TOKEN | download=true |
| POST | /api/link | Create a new link | auth_token=TOKEN; short_code=SHORTCODE; auth_token=TOKEN |
| GET | /api/SHORTCODE | Shows info about a link | - | - |
| POST | /api/import | imports JSON links | auth_token=TOKEN; body=JSON | - |

## Initial Deployment to Gigalixir
_If you are unfamiliar with Gigalixir, they are a hosting service designed for Elixir._
_This app will work on the free tier and has no need for a postgres database._
_Watch [this tutorial](https://elixircasts.io/deploying-with-gigalixir-%28revised%29) for more information._

1. [Sign up](https://www.gigalixir.com/) for an account.
2. Follow the steps in the [Getting Started Guide](https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html#).
_Note: The buildpack config are already included in this repo. Also, there is no need to provision a database._
3. Create a new app.
4. Set your AUTH_TOKEN from the Gigalixir console > configuration
_Note: Your auth token will be used to authenticate all API requests_
5. Deploy the app - It is designed to be deployed using [Elixir Releases](https://gigalixir.readthedocs.io/en/latest/modify-app/releases.html#)
6. Download the [Devito CLI](https://github.com/supersimple/devito_cli/)
7. Configure the CLI (`./devito config --apiurl <APP URL> --authtoken <TOKEN FROM STEP 4>`)
8. Test it out. `./devito https://supersimple.org sprsmpl`

## Update Deployments
Gigalixir requires monthly deployments on the free tier. *Before deploying, you will need to migrate your existing data*.
To migrate data:
1. export your current data `devito export ~/Desktop`
2. deploy `git push gigalixir +HEAD:master`
3. import data `POST api/import`
  - fish `curl -X POST -H "Content-Type: application/json" -d (cat ~/Desktop/devito_links.json) "<APP URL>/api/import?auth_token=<AUTH TOKEN>"
  - bash `curl -X POST -H "Content-Type: application/json" -d "$(cat ~/Desktop/devito_links.json)" "<APP URL>/api/import?auth_token=<AUTH TOKEN>"`

## Help Video
An [Install walk-through video](https://www.youtube.com/embed/7A7jtQfFB00) is available.

## Logo Credit
Devito Logo by [Mark Farris](https://markfarrisdesign.com)

## Upgrading
Before upgrading or redploying, make sure to backup your existing data.
You will need to re-import your links after releasing your code.


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
