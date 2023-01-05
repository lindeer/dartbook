#!/bin/bash

if [ ! -d web/materialize ]; then
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
cp build/materialize.js $assetDir/materialize.js
cp build/styles.css $assetDir/style.css

resourceDir='public'
targetAssetDir="$resourceDir/_assets"
rm -rf $targetAssetDir/website && cp -r $assetDir $targetAssetDir
cp resource/_layouts/website/*.html $resourceDir/_layouts/website
