#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/renesis.ico

convert ../../src/qt/res/icons/renesis-16.png ../../src/qt/res/icons/renesis-32.png ../../src/qt/res/icons/renesis-48.png ${ICON_DST}
