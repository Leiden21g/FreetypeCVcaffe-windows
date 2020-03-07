# FreetypeCVcaffe-windows

A mixed build scripts

## Requierd

* Visual Studio 2017,2019(with VC v140 tool chain)

* git bash


## Setting

* Open  Visual Studio 201X Tools Command prompt

* Set Environment 
  
  ```Shell
  set DOWNLOAD=C:/Users/%USERNAME%/.download
  set INSTALL=C:/Users/%USERNAME%/.install
  set PATH=C:\Program Files\Git\usr\bin;%PATH%
  call "C:\Program Files\Git\git-cmd.exe" --no-cd --command=usr/bin/bash.exe -l -i
  ```
  
* Build quick

  ```Shell
  nmake 
  ```
* Build all

  ```Shell
  nmake all
  ```
  
## Reference

> https://github.com/weiliu89/caffe/tree/ssd

> https://pjreddie.com/darknet/yolo/

> https://github.com/chuanqi305/MobileNet-SSD

> https://github.com/gklz1982/caffe-yolov2

> https://github.com/yonghenglh6/DepthwiseConvolution

> https://github.com/alexgkendall/caffe-segnet

> https://github.com/BVLC/caffe/pull/6384/commits/4d2400e7ae692b25f034f02ff8e8cd3621725f5c

> https://www.cityscapes-dataset.com/

> https://github.com/TuSimple/tusimple-benchmark/wiki

> https://github.com/Robert-JunWang/Pelee

> https://github.com/hujie-frank/SENet

> https://github.com/lusenkong/Caffemodel_Compress

> https://github.com/eric612/Caffe-YOLOv3-Windows
