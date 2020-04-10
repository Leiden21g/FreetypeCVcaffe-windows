# %DOWNLOAD%のフォルダ区切りは / を使うこと
#cmake .. -Tv140 "-GVisual Studio 15 2017 Win64"
#cmake --build . --config release

cmake_minimum_required(VERSION 3.0)
if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()
if(POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()
################################################################################################
# A function for automatic detection of GPUs installed  (if autodetection is enabled)
# Usage:
#   caffe_detect_installed_gpus(out_variable)
function(caffe_detect_installed_gpus out_variable)
  if(NOT CUDA_gpu_detect_output)
    set(__cufile ${PROJECT_BINARY_DIR}/detect_cuda_archs.cu)

    file(WRITE ${__cufile} ""
      "#include <cstdio>\n"
      "int main()\n"
      "{\n"
      "  int count = 0;\n"
      "  if (cudaSuccess != cudaGetDeviceCount(&count)) return -1;\n"
      "  if (count == 0) return -1;\n"
      "  for (int device = 0; device < count; ++device)\n"
      "  {\n"
      "    cudaDeviceProp prop;\n"
      "    if (cudaSuccess == cudaGetDeviceProperties(&prop, device))\n"
      "      std::printf(\"%d.%d \", prop.major, prop.minor);\n"
      "  }\n"
      "  return 0;\n"
      "}\n")

    execute_process(COMMAND "${CUDA_NVCC_EXECUTABLE}" "--run" "${__cufile}"
                    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}/CMakeFiles/"
                    RESULT_VARIABLE __nvcc_res OUTPUT_VARIABLE __nvcc_out
                    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(__nvcc_res EQUAL 0)
      # nvcc outputs text containing line breaks when building with MSVC.
      # The line below prevents CMake from inserting a variable with line
      # breaks in the cache
      string(REGEX MATCH "([1-9].[0-9])" __nvcc_out "${__nvcc_out}")
      set(CUDA_gpu_detect_output ${__nvcc_out} CACHE INTERNAL "Returned GPU architetures from caffe_detect_gpus tool" FORCE)      
    endif()
  endif()

  if(NOT CUDA_gpu_detect_output)
    message(STATUS "Automatic GPU detection failed. Building for all known architectures.")
    set(${out_variable} ${Caffe_known_gpu_archs} PARENT_SCOPE)
  else()
    set(${out_variable} ${CUDA_gpu_detect_output} PARENT_SCOPE)
  endif()
endfunction()

project(Test)
### Configure Dependency install path, include path and library path
set(DEPEND_LIB_ROOT ${PROJECT_BINARY_DIR}/Depends)
set(CMAKE_PREFIX_PATH ${DEPEND_LIB_ROOT})

include_directories(${CMAKE_INSTALL_PREFIX}/include ${DEPEND_LIB_ROOT}/include ${OpenCV_INCLUDE_DIRS})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${DEPEND_LIB_ROOT})

set(OpenCV_DIR  "${DEPEND_LIB_ROOT}/x64/vc14/lib")
set(zlibDIR     "${DEPEND_LIB_ROOT}/build/zlib")
set(opencvDIR   "${DEPEND_LIB_ROOT}/build/opencv")
set(freetypeDIR "${DEPEND_LIB_ROOT}/build/freetype")
set(freetype2DIR "${DEPEND_LIB_ROOT}/build/freetype2")
set(harfbuzzDIR "${DEPEND_LIB_ROOT}/build/harfbuzz")
set(caffeDIR    "${DEPEND_LIB_ROOT}/build/caffe")
set(opencvSRC   "${DEPEND_LIB_ROOT}/src/opencv")
set(FONTS_PATH ${CMAKE_INSTALL_PREFIX}/fonts)

message(STATUS "Env" )
message(STATUS "OpenCV_DIR : " $ENV{OpenCV_DIR} " , " ${OpenCV_DIR})
message(STATUS "Caffe_DIR  : "  $ENV{Caffe_DIR}  " , " ${Caffe_DIR})
message(STATUS "CMAKE_INSTALL_PREFIX"  ${CMAKE_INSTALL_PREFIX})
set(ENV{OpenCV_DIR} ${CMAKE_INSTALL_PREFIX})
set(ENV{Caffe_DIR}  ${CMAKE_INSTALL_PREFIX})

add_definitions( /DFONTS_PATH="${FONTS_PATH}" /wd"4244" /wd"4267" /wd"4818" /wd"4819" /wd"4793")
link_directories(${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/x64/vc14/lib ${DEPEND_LIB_ROOT}/lib ${DEPEND_LIB_ROOT}/x64/vc14/lib)

find_package(CUDA REQUIRED)
if(CUDA_FOUND)
	message(STATUS "CUDA_FOUND")
	add_definitions(/DCUDA_FOUND)
	if(ALL_BUILD)
	  set(caffeCPU_ONLY "-DCPU_ONLY:BOOL=OFF")
	else()
	  set(caffeCPU_ONLY "-DCPU_ONLY:BOOL=ON")
	endif()
	caffe_detect_installed_gpus(__cuda_arch_bin)
	set(OpencvCUDA -DWITH_CUDA=ON -DCUDA_ARCH_BIN:STRING="${__cuda_arch_bin}" -DWITH_CUDNN=OFF)
	  # remove dots and convert to lists
	  string(REGEX REPLACE "\\." "" _cuda_arch_bin "${__cuda_arch_bin}")
	message(STATUS "__cuda_arch_bin :" ${__cuda_arch_bin})
else()
	message(STATUS "CUDA NOT FOUND")
	set(CPU_ONLY "-DCPU_ONLY:BOOL=ON")
endif()

if( (EXISTS $ENV{DOWNLOAD}/caffe/.git) AND
	(EXISTS $ENV{DOWNLOAD}/freetype/.git) AND
	(EXISTS $ENV{DOWNLOAD}/harfbuzz/.git) AND
	(EXISTS $ENV{DOWNLOAD}/opencv/.git) AND
	(EXISTS $ENV{DOWNLOAD}/opencv_contrib/.git) )
    set(caffeREPOSITORY $ENV{DOWNLOAD}/caffe)
	set(opencvREPOSITORY $ENV{DOWNLOAD}/opencv)
	set(freetypeREPOSITORY $ENV{DOWNLOAD}/freetype)
	set(harfbuzzREPOSITORY $ENV{DOWNLOAD}/harfbuzz)
	set(opencv_contribREPOSITORY $ENV{DOWNLOAD}/opencv_contrib)
else()
    set(caffeREPOSITORY  "https://github.com/eric612/MobileNet-YOLO.git")
	set(opencvREPOSITORY "https://github.com/opencv/opencv.git")
	set(freetypeREPOSITORY "https://github.com/aseprite/freetype2.git")
	set(harfbuzzREPOSITORY "https://github.com/harfbuzz/harfbuzz.git")
	set(opencv_contribREPOSITORY "https://github.com/opencv/opencv_contrib.git")
endif()
message(STATUS "opencvREPOSITORY" ${opencvREPOSITORY})
message(STATUS "freetypeREPOSITORY" ${freetypeREPOSITORY})
message(STATUS "harfbuzzREPOSITORY" ${harfbuzzREPOSITORY})
message(STATUS "opencv_contribREPOSITORY" ${opencv_contribREPOSITORY})

### Create Target "Test"
add_executable(Test src/main.cpp)

### Load External Project
include(ExternalProject)

ExternalProject_Add( download_opencv
  GIT_REPOSITORY ${opencvREPOSITORY}
  GIT_TAG 4.2.0
  SOURCE_DIR ${opencvSRC}
  BUILD_IN_SOURCE true
  CONFIGURE_COMMAND	"" 
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

ExternalProject_Add( zlib
  DEPENDS download_opencv
  DOWNLOAD_COMMAND "" # Disable download step 
  SOURCE_DIR ${opencvSRC}/3rdparty
  BINARY_DIR ${zlibDIR}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/zlib/CMakeLists.txt ${opencvSRC}/3rdparty
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
)
set(ZLIB_LIBRARY  ${CMAKE_INSTALL_PREFIX})
set(ZLIB_ARG -DZLIB_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
 -DZLIB_LIBRARY_DEBUG:FILEPATH=${CMAKE_INSTALL_PREFIX}/lib/zlib.lib
 -DZLIB_LIBRARY_RELEASE:FILEPATH=${CMAKE_INSTALL_PREFIX}/lib/zlib.lib)

ExternalProject_Add( freetype
  DEPENDS zlib
  GIT_REPOSITORY ${freetypeREPOSITORY}
  GIT_TAG VER-2-10-0
  SOURCE_DIR ${DEPEND_LIB_ROOT}/src/freetype
  BINARY_DIR ${freetypeDIR}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${ZLIB_ARG}
  	-DFT_WITH_HARFBUZZ:BOOL=OFF
	-DFT_WITH_ZLIB:BOOL=OFF
	-DCMAKE_C_FLAGS:STRING="/DWIN32 /D_WINDOWS /W3 /wd4244 /wd4267 /wd4818 /wd4819 /wd4793"
#  BUILD_COMMAND ${CMAKE_COMMAND} --build ${freetypeDIR} --target install
#  INSTALL_COMMAND	""
)

ExternalProject_Add( harfbuzz
  DEPENDS freetype
  GIT_REPOSITORY ${harfbuzzREPOSITORY}
  GIT_TAG 2.6.4
  SOURCE_DIR ${DEPEND_LIB_ROOT}/src/harfbuzz
  BINARY_DIR ${harfbuzzDIR}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DHB_BUILD_TESTS:BOOL=OFF
  -DHB_BUILD_SUBSET:BOOL=OFF
  -DHB_HAVE_FREETYPE:BOOL=ON
  -DCMAKE_C_FLAGS:STRING="/DWIN32 /D_WINDOWS /W3 /wd4244 /wd4267 /wd4818 /wd4819 /wd4793"
)

ExternalProject_Add( freetype2
  DEPENDS harfbuzz zlib
  GIT_REPOSITORY ${freetypeREPOSITORY}
  GIT_TAG VER-2-10-0
  SOURCE_DIR ${DEPEND_LIB_ROOT}/src/freetype
  BINARY_DIR ${freetype2DIR}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${ZLIB_ARG}
  	-DFT_WITH_HARFBUZZ:BOOL=ON
    -DFT_WITH_ZLIB:BOOL=OFF
    -DCMAKE_C_FLAGS:STRING="/DWIN32 /D_WINDOWS /W3 /wd4244 /wd4267 /wd4818 /wd4819 /wd4793"
)

ExternalProject_Add( opencv_contrib
  GIT_REPOSITORY ${opencv_contribREPOSITORY}
  GIT_TAG 4.2.0
  SOURCE_DIR ${DEPEND_LIB_ROOT}/src/opencv_contrib
  PATCH_COMMAND patch -p1 -i "${CMAKE_SOURCE_DIR}/src/opencv_contrib.patch" || true
  BUILD_IN_SOURCE true
  CONFIGURE_COMMAND	""
  BUILD_COMMAND		""
  INSTALL_COMMAND	""
)

if(ALL_BUILD)
  set(OPENCV_ARGS
	-DBUILD_EXAMPLES=ON -DINSTALL_C_EXAMPLES=ON)
else()
  set(OPENCV_ARGS
 -DBUILD_EXAMPLES=OFF -DINSTALL_C_EXAMPLES=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF
 -DBUILD_opencv_apps:BOOL=OFF
 -DBUILD_opencv_aruco:BOOL=OFF -DBUILD_opencv_bgsegm:BOOL=OFF
 -DBUILD_opencv_bioinspired:BOOL=OFF -DBUILD_opencv_calib3d:BOOL=OFF
 -DBUILD_opencv_ccalib:BOOL=OFF -DBUILD_opencv_datasets:BOOL=OFF
 -DBUILD_opencv_dnn:BOOL=OFF -DBUILD_opencv_dnn_objdetect:BOOL=OFF -DBUILD_opencv_dnn_superres:BOOL=OFF
 -DBUILD_opencv_dpm:BOOL=OFF -DBUILD_opencv_face:BOOL=OFF -DBUILD_opencv_features2d:BOOL=OFF
 -DBUILD_opencv_flann:BOOL=OFF -DBUILD_opencv_fuzzy:BOOL=OFF -DBUILD_opencv_gapi:BOOL=OFF
 -DBUILD_opencv_hfs:BOOL=OFF -DBUILD_opencv_img_hash:BOOL=OFF
 -DBUILD_opencv_java_bindings_generator:BOOL=OFF -DBUILD_opencv_line_descriptor:BOOL=OFF
 -DBUILD_opencv_ml:BOOL=OFF -DBUILD_opencv_objdetect:BOOL=OFF -DBUILD_opencv_optflow:BOOL=OFF
 -DBUILD_opencv_phase_unwrapping:BOOL=OFF -DBUILD_opencv_plot:BOOL=OFF
 -DBUILD_opencv_python_bindings_generator:BOOL=OFF -DBUILD_opencv_python_tests:BOOL=OFF
 -DBUILD_opencv_quality:BOOL=OFF -DBUILD_opencv_reg:BOOL=OFF -DBUILD_opencv_rgbd:BOOL=OFF
 -DBUILD_opencv_saliency:BOOL=OFF -DBUILD_opencv_sfm:BOOL=OFF -DBUILD_opencv_shape:BOOL=OFF
 -DBUILD_opencv_stereo:BOOL=OFF -DBUILD_opencv_stitching:BOOL=OFF
 -DBUILD_opencv_structured_light:BOOL=OFF -DBUILD_opencv_superres:BOOL=OFF
 -DBUILD_opencv_surface_matching:BOOL=OFF -DBUILD_opencv_text:BOOL=OFF -DBUILD_opencv_tracking:BOOL=OFF
 -DBUILD_opencv_xfeatures2d:BOOL=OFF -DBUILD_opencv_ximgproc:BOOL=OFF -DBUILD_opencv_xobjdetect:BOOL=OFF
 -DBUILD_opencv_xphoto:BOOL=OFF)
endif()
ExternalProject_Add( opencv
  DEPENDS opencv_contrib freetype2 zlib
  DOWNLOAD_COMMAND "" # Disable download step 
  SOURCE_DIR ${opencvSRC}
  BINARY_DIR ${opencvDIR}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
	-DOPENCV_EXTRA_MODULES_PATH=${DEPEND_LIB_ROOT}/src/opencv_contrib/modules
	-DBUILD_ZLIB:BOOL=OFF -DBUILD_opencv_freetype:BOOL=ON -DWITH_FREETYPE:BOOL=ON
	${OpencvCUDA}	-DWITH_TBB:BOOL=ON -DMKL_WITH_TBB:BOOL=ON -DMKL_WITH_OPENMP:BOOL=ON -DWITH_OPENGL=ON
    -DBUILD_opencv_viz=OFF -DWITH_VTK:BOOL=OFF
	${OPENCV_ARGS} ${ZLIB_ARG} 
	-DCUDA_NVCC_FLAGS:STRING=-w
	-DCMAKE_CXX_FLAGS:STRING="/DWIN32 /D_WINDOWS /W3 /GR /EHsc /wd4819 /wd4706 /wd4702 /wd4505 /wd4793 /wd4267 /wd4244 /wd5999 /wd4661"
)
#  TEST_AFTER_INSTALL true
#  TEST_COMMAND ${CMAKE_COMMAND} --build ${opencvDIR} --config Release --target RUN_TESTS

# 1つのソースコードに対するパッチを作成する
# diff -up [オリジナルソース] [修正後ソース]
# ディレクトリ以下のソースコードに対するパッチを作成する
# diff -uprN [オリジナルソースディレクトリ] [修正後ソースディレクトリ]
ExternalProject_Add( fonts
  SOURCE_DIR ${FONTS_PATH}
  URL               https://osdn.net/projects/mplus-fonts/downloads/62344/063-OTF.tar.xz
  URL_HASH          MD5=6286ab8f44f796904350c63984055756
  BUILD_IN_SOURCE true
  CONFIGURE_COMMAND	""
  BUILD_COMMAND		""
  INSTALL_COMMAND	""
)

ExternalProject_Add( caffe
  DEPENDS opencv
  GIT_REPOSITORY ${caffeREPOSITORY}
  PATCH_COMMAND patch -p1 -i "${CMAKE_SOURCE_DIR}/src/caffe.patch" || true
  GIT_TAG f1f15be22ea7f2d9f32e3a515ff8500dea22c524
  SOURCE_DIR ${DEPEND_LIB_ROOT}/src/caffe
  BINARY_DIR ${caffeDIR}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    ${caffeCPU_ONLY}
    -DBLAS=open
	-Dpython_version=3
#	-DBUILD_python:BOOL=ON
	-DBUILD_python_layer:BOOL=OFF
	-DUSE_CUDNN:BOOL=ON
	-DCUDA_ARCH_NAME:STRING=Manual
	-DCUDA_ARCH_BIN:STRING=${_cuda_arch_bin} -DCUDA_ARCH_PTX:STRING=${_cuda_arch_bin}
	-DCUDA_NVCC_FLAGS:STRING=-w
)
# $ cd build/Depends/src/caffe/ && git diff f1f15be22ea7f2d9f32e3a515ff8500dea22c524 >  ../../../../ws/src/caffe.patch

#  TEST_BEFORE_INSTALL true
#  TEST_COMMAND ${CMAKE_COMMAND} --build ${caffeDIR} --config Release --target runtest

### Test depends
add_dependencies(Test fonts caffe opencv )
 find_package(OpenCV QUIET COMPONENTS core highgui imgproc imgcodecs videoio freetype)
target_link_libraries(Test ${OpenCV_LIBRARIES} ${Caffe_LIBRARIES} )
install(TARGETS Test DESTINATION bin)
