ARG ELIXIR_VERSION=1.15.1
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20230612-slim
ARG NODEJS_VERSION=18.16.1
ARG NODEJS_LINUX_X64_TAR_XZ_SHA256=ecfe263dbd9c239f37b5adca823b60be1bb57feabbccd25db785e647ebc5ff5e

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as base

# install build dependencies
RUN apt-get update -y \
    && apt-get install -y build-essential git curl \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install Node.js
ARG NODEJS_VERSION
ARG NODEJS_LINUX_X64_TAR_XZ_SHA256
RUN NODEJS_DOWNLOAD_URL="https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz" \
    && curl -fSL $NODEJS_DOWNLOAD_URL -o node-v${NODEJS_VERSION}-linux-x64.tar.xz \
    && echo "${NODEJS_LINUX_X64_TAR_XZ_SHA256}  node-v${NODEJS_VERSION}-linux-x64.tar.xz" | sha256sum -c - \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJC /usr/local/lib/nodejs -f node-v${NODEJS_VERSION}-linux-x64.tar.xz \
    && rm node-v${NODEJS_VERSION}-linux-x64.tar.xz
ENV PATH="$PATH:/usr/local/lib/nodejs/node-v${NODEJS_VERSION}-linux-x64/bin"
RUN npm install -g npm

FROM base as builder

# prepare build dir
WORKDIR /app

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# install NodeJS dependencies
COPY assets/package.json assets/package-lock.json assets/
RUN mix assets.setup

COPY priv priv

COPY lib lib

COPY assets assets

# compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/portfolio ./

USER nobody

CMD ["/app/bin/server"]
