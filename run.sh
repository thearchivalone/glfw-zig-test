#!/bin/bash -e

DOCKER_EXE=$(which docker)

if [ -e "${DOCKER_EXE}" ]; then
  echo "Preparing Docker Build. Please Wait"
  sleep 1
  ${DOCKER_EXE} build -t glfw-zig-test .

  echo "Running Docker Container. Please Wait"
  sleep 1
  ${DOCKER_EXE} run --rm -v ./dist:/out -t glfw-zig-test:latest

  echo "Build finished. Please check dist folder for output."
  exit 0

else
  echo "Docker executable not found."
fi
