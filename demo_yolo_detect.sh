yolo_detect models/tusimple/mobilenet_yolov3_lite_deploy.prototxt models/tusimple/mobilenet_yolov3_lite_deploy_iter_50000.caffemodel -detect_mode 2 -cpu_mode gpu -file_type image -wait_time 1 -mean_value 1.0,1.0,1.0 -normalize_value 0.007843 -confidence_threshold 0.3 -indir D:/dataset/aie/test_images

#yolo_detect models/tusimple/mobilenet_yolov3_lite_deploy.prototxt models/tusimple/mobilenet_yolov3_lite_deploy_iter_50000.caffemodel \
#-detect_mode 1 -cpu_mode gpu -file_type image -wait_time 1 -mean_value 1.751,1.983,2.10 -normalize_value 0.017 -confidence_threshold 0.3 \
#-seg_resize_scales 4 -seg_label_map data/bdd100k/labelmap.prototxt -indir D:/dataset/aie/test_images -ext jpg


yolo_detect D:/dataset/pelee/pelee_merged.prototxt D:/dataset/pelee/pelee_merged.caffemodel \
-detect_mode 1 -cpu_mode gpu -file_type image -wait_time 1 -mean_value 1.751,1.983,2.10 -normalize_value 0.017 -confidence_threshold 0.3 \
-seg_resize_scales 4 -seg_label_map data/bdd100k/labelmap.prototxt -indir D:/dataset/aie/test_images -ext jpg

