#!/bin/bash

cd web && sass --style=compressed styles.scss styles.css && cd -
webdev build

assetDir=resource/_assets/website

if [ ! -d $assetDir ]; then
  mkdir -p $assetDir
fi

cp build/main.dart.js $assetDir/dartbook.js
cp build/materialize.js $assetDir/materialize.js
cp build/styles.css $assetDir/style.css

rm -rf ../cli/theme/_assets/website && cp -r $assetDir ../cli/theme/_assets
cp resource/_layouts/website/*.html ../cli/theme/_layouts/website
