#!/bin/sh

init() {
  docker pull moby/buildkit:latest
  if ! docker network inspect 'aoc_2023' > /dev/null 2>&1 ; then
    docker network create 'aoc_2023'
  fi

  docker build --file '.devcontainer/Dockerfile-builder' \
               --tag 'aoc_2023_builder_image' \
               .devcontainer

  if ! docker buildx inspect 'aoc_2023_builder' > /dev/null 2>&1 ; then
    docker buildx create --driver docker-container \
                         --driver-opt image=aoc_2023_builder_image \
                         --driver-opt network=aoc_2023 \
                         --name 'aoc_2023_builder'
  fi

  docker buildx build --builder 'aoc_2023_builder' \
                      --load \
                      --tag 'aoc_2023_devcontainer' \
                      .devcontainer
}

init "$@"
