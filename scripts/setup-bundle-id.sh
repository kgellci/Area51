#!/bin/bash

set -e
set -o pipefail
set -u

if [ ! -e Configs/bundleIdentifier.xcconfig ]; then
    echo "PRODUCT_BUNDLE_IDENTIFIER = com.gellci.area51os" > Configs/bundleIdentifier.xcconfig
fi
