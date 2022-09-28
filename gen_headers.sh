#!/bin/bash -x
cd godot-cpp
scons platform=linux generate_bindings=yes use_custom_api_file=yes custom_api_file=../api.json -j4
cd ..

