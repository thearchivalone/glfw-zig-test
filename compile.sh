#!/bin/bash -e

ZIG_EXE=$(which zig)

if [ -e "${ZIG_EXE}" ]; then
  echo "Building native GLFW test. Please Wait"
  sleep 1
  ${ZIG_EXE} build --verbose -p zig-out/linux/native

  echo "Building cross GLFW test. Please Wait"
  sleep 1
  ${ZIG_EXE} build --verbose -Dtarget=x86_64-linux -p zig-out/linux/x86_64

else
  echo "Zig executable not found\n"
fi
