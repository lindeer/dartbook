#!/bin/bash

cd web && sass --style=compressed styles.scss styles.css && cd -
webdev build

if [ ! -d resource/_assets/website ]; then
  mkdir -p resource/_assets/website
fi

cp build/main.dart.js resource/_assets/website/dartbook.js
cp build/materialize.js resource/_assets/website/materialize.js
cp build/styles.css resource/_assets/website/style.css
