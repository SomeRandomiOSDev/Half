#!/usr/bin/env bash
#
# resolvepath.sh
# Copyright © 2023 SomeRandomiOSDev. All rights reserved.
#
# Usage example: ./resolvepath.sh "./some/random/path/../../"

cd "$(dirname "$1")" &>/dev/null && echo "$PWD/${1##*/}"
