#!/bin/bash

function checkCommand() {
  cmd=$1
  if ! command -v $cmd &> /dev/null
  then
    echo "'$cmd' command could not be found!"
    echo "run 'dart pub global activate $cmd'"
    exit 1
  fi
}

checkCommand webdev && checkCommand sass

if [ ! -d web/materialize ]; then
  wget -P ~/Downloads https://mirror.ghproxy.com/https://github.com/materializecss/materialize/releases/download/1.2.0/materialize-src-v1.2.0.zip
  unzip ~/Downloads/materialize-src-v1.2.0.zip
  mv materialize-src/sass web/materialize
  rm -rf materialize-src
fi
cd web && sass --style=compressed styles.scss styles.css && cd -
webdev build

assetDir=resource/_assets/website

if [ ! -d $assetDir ]; then
  mkdir -p $assetDir
fi

cp build/main.dart.js $assetDir/dartbook.js
cp build/styles.css $assetDir/style.css
cp -r build/{materialize.js,icons.css,fonts} $assetDir

resourceDir='../lib/theme-res'
targetAssetDir="$resourceDir/_assets"
rm -rf $targetAssetDir/website && cp -r $assetDir $targetAssetDir
cp resource/_layouts/website/*.html $resourceDir/_layouts/website
