#!/bin/bash

set -e
set -o pipefail
set -u

required_version="$(cat .xcodegen-version)"

install() {
  mkdir -p ./tmp
  rm -f ./tmp/XcodeGen ./tmp/xcodegen.tar.gz

  curl --location --fail --retry 5 \
    https://github.com/yonaskolb/XcodeGen/releases/download/"$required_version"/xcodegen.zip \
    --output ./tmp/xcodegen.zip

  (
    cd ./tmp
    unzip -o xcodegen.zip -d download > /dev/null
    mv download/xcodegen/bin/xcodegen XcodeGen
    rm -rf xcodegen.zip download
  )

  echo "Installed XcodeGen locally"
}

if [ ! -x ./tmp/XcodeGen ]; then
  install
elif ! diff <(echo "Version: $required_version") <(./tmp/XcodeGen version) > /dev/null; then
  install
fi