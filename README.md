# Portfolio

Portfolio allows you to track the performance of your investment portfolio.

:construction: At the moment, Portfolio is at a very early stage of development and is not suitable for practical use.

## Development

### Requirements

- PostgreSQL
- Runtimes listed in [.tool-versions](.tool-versions)

### Setup

1. Run `mix setup` to install and setup dependencies.

2. Run linters and tests with:

   ```shell
   mix format --check-formatted \
      && (cd assets && npm run eslint:check) \
      && (cd assets && npm run prettier:check) \
      && mix test \
      && (cd assets && npm test)
   ```

3. Start Phoenix endpoint with `mix phx.server` (or inside IEx with `iex -S mix phx.server`).

4. Visit [`localhost:4000`](http://localhost:4000) from your browser.

## Copyright

Copyright (C) 2023 Marek Ciupak
