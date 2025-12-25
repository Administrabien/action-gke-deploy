#!/bin/bash
set -e

ç=$1
VERSION_PATH=$2
VERSION=$3

yq -i '.spec.template.spec.sources[0].helm.parameters[1].value = "v0.0.1.5"' archivo.yaml