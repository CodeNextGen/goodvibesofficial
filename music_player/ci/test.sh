#!/usr/bin/env bash

# exit on the first error
set -e

echo "Get flutter dependencies"
flutter packages get

pub global activate grinder

grind test
