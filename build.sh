#!/bin/bash
# Bash‚Ì•Ö—˜‚È\•¶‚¾‚ª‚æ‚­–Y‚ê‚Ä‚µ‚Ü‚¤‚à‚Ì‚Ì”õ–Y˜^ https://qiita.com/Ping/items/57fd75465dfada76e633
rm -rf build && mkdir build

#cd build && cmake .. -Tv140 "-GVisual Studio 15 2017 Win64" && cmake --build . --config release  2>&1 | tee -a build.log
cd build && cmake .. -Tv140 && cmake --build . --config release

cd src/caffe/ && ../../build/Depends/bin/ssd_detect.exe \
models/yolov3/mobilenet_yolov3_lite_deploy.prototxt models/yolov3/mobilenet_yolov3_lite_deploy.caffemodel \
data/VOC0712 -file_type image -wait_time 500 -mean_value 1.0,1.0,1.0 -normalize_value 0.007843 -confidence_threshold 0.3