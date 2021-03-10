# lob_elixir

[![Build Status](https://travis-ci.org/lob/lob-elixir.svg?branch=master)](https://travis-ci.org/lob/lob-elixir)
[![Coverage Status](https://coveralls.io/repos/github/lob/lob-elixir/badge.svg?branch=master)](https://coveralls.io/github/lob/lob-elixir?branch=master)
[![Module Version](https://img.shields.io/hexpm/v/lob_elixir.svg)](https://hex.pm/packages/lob_elixir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/lob_elixir/)
[![Total Download](https://img.shields.io/hexpm/dt/lob_elixir.svg)](https://hex.pm/packages/lob_elixir)
[![License](https://img.shields.io/hexpm/l/lob_elixir.svg)](https://github.com/lob/lob_elixir/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/lob/lob-elixir.svg)](https://github.com/lob/lob-elixir/commits/master)

Elixir library for [Lob API](https://lob.com/).

## Installation

The package can be installed by adding `:lob_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lob_elixir, "~> 1.1.2"}
  ]
end
```

## Getting Started

This library implements the Lob API. Please read through the official [API Documentation](#api-documentation) to get a complete sense of what to expect from each endpoint.

### Registration

The library requires a valid Lob API key to work properly. To acquire an API key, first create an account at [Lob.com](https://dashboard.lob.com/#/register). Once you have created an account, you can access your API Keys from the [Settings Panel](https://dashboard.lob.com/#/settings).

### API Key Configuration
 The library will by default refer to the `:api_key` config when making authenticated requests. If that is not present, it will look for the `LOB_API_KEY` environment variable.

```elixir
# Configuring an API key with configs
config :lob_elixir,
  api_key: "your_api_key"
```

The `{:system, "ENV_VAR"}` syntax is also supported, allowing the API key to be fetched at runtime. For example, if the API key is stored in an environment variable named `LOB_KEY`, the library could be configured with:

```elixir
# Configuring an API key with configs
config :lob_elixir,
  api_key: {:system, "LOB_KEY"}
```

Similarly, the library allows users to optionally configure the API version through the `:api_version` config. If that is not present, it will look for the `LOB_API_VERSION` environment variable.

```elixir
# Configuring an API key and API version with configs
config :lob_elixir,
  api_key: "your_api_key",
  api_version: "2014-12-18"
```

### Usage

Requests return a 2-tuple or 3-tuple, depending on the response.

```elixir
# Successful response
{:ok, postcards, _headers} = Postcard.list()

# Unsuccessful response
{:error, %{message: ":nxdomain"}} = Postcard.list()

# Unsuccessful response with status code
{:error, %{message: "postcard not found", status_code: 404}} = Postcard.retrieve('nonexistent_resource')
```

## Testing

Tests are written using [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html), Elixir's built-in test framework.

Here's how you can run the tests:

    LOB_API_KEY=YOUR_TEST_API_KEY mix test

To run tests with a coverage report:

    LOB_API_KEY=YOUR_TEST_API_KEY mix coveralls.html

Then view the report at `cover/excoveralls.html`.

## Copyright and License

Copyright (c) 2019 Lob.com

Released under the MIT License, which can be found in the repository in [`LICENSE.txt`](https://github.com/lob/lob-elixir/blob/master/LICENSE).
