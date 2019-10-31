FROM gitpod/workspace-postgres:latest

USER root
# Install custom tools, runtime, etc.
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb

RUN apt-get update && apt-get -yq install esl-erlang
RUN apt-get -yq install elixir

RUN apt-get update && apt-get install -y && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

USER gitpod
# Apply user-specific settings
RUN mix archive.install hex phx_new 1.4.10

# Give back control
USER root