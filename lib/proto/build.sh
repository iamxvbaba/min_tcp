#!/bin/bash
DST_DIR=./
FILE=*.proto
PLUGIN_PATH=C:/Users/0000/AppData/Local/Pub/Cache/bin/protoc-gen-dart.bat #local plugin
protoc --dart_out=${DST_DIR} ${FILE} --plugin=protoc-gen-dart=${PLUGIN_PATH}