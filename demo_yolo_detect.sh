yolo_detect E:/src/ws/Release/Depends/src/caffe/models/cityscapes/mobilenet_yolov3_deploy.prototxt \
D:/dataset/citycapes/mobilenet_yolov3_deploy_iter_46000.caffemodel \
-detect_mode 1 -cpu_mode gpu -file_type image -wait_time 1 -mean_value 1.0,1.0,1.0 -normalize_value 0.007843 -confidence_threshold 0.3 \
-indir D:/dataset/aie/test_images -ext jpg

