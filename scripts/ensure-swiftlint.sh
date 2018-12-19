#!/bin/bash

set -e
set -o pipefail
set -u

expected_version="$(cat .swiftlint-version)"

install() {
  mkdir -p ./tmp
  rm -f ./tmp/swiftlint ./tmp/swiftlint.tar.gz

  curl --location --fail --retry 5 \
    https://github.com/realm/SwiftLint/releases/download/"$expected_version"/portable_swiftlint.zip \
    --output ./tmp/swiftlint.zip

  (
    cd ./tmp
    unzip -o swiftlint.zip -d swiftlintdl > /dev/null
    mv swiftlintdl/swiftlint SwiftLint
    rm -rf swiftlint.zip swiftlintdl
  )

  echo "Installed SwiftLint locally"
}

if [ ! -x ./tmp/SwiftLint ]; then
  install
elif ! diff <(echo "$expected_version") <(./tmp/SwiftLint version) > /dev/null; then
  install
fi