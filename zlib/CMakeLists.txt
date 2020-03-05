# ----------------------------------------------------------------------------
#  CMake file for zlib. See root CMakeLists.txt
#
# ----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.0)
set(ZLIB_LIBRARY zlib)

project(${ZLIB_LIBRARY} C)

include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckCSourceCompiles)
include(CheckTypeSize)

#
# Check for fseeko
#
check_function_exists(fseeko HAVE_FSEEKO)
if(NOT HAVE_FSEEKO)
  add_definitions(-DNO_FSEEKO)
endif()

#
# Check for unistd.h
#
if(NOT MSVC)
  check_include_file(unistd.h Z_HAVE_UNISTD_H)
  if(Z_HAVE_UNISTD_H)
    add_definitions(-DZ_HAVE_UNISTD_H)
  endif()
endif()

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
  add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
endif()

#
# Check to see if we have large file support
#
check_type_size(off64_t OFF64_T)
if(HAVE_OFF64_T)
  add_definitions(-D_LARGEFILE64_SOURCE=1)
endif()

set(ZLIB_PUBLIC_HDRS
    zlib/zconf.h
    zlib/zlib.h
)
set(ZLIB_PRIVATE_HDRS
    zlib/crc32.h
    zlib/deflate.h
    zlib/gzguts.h
    zlib/inffast.h
    zlib/inffixed.h
    zlib/inflate.h
    zlib/inftrees.h
    zlib/trees.h
    zlib/zutil.h
)
set(ZLIB_SRCS
    zlib/adler32.c
    zlib/compress.c
    zlib/crc32.c
    zlib/deflate.c
    zlib/gzclose.c
    zlib/gzlib.c
    zlib/gzread.c
    zlib/gzwrite.c
    zlib/inflate.c
    zlib/infback.c
    zlib/inftrees.c
    zlib/inffast.c
    zlib/trees.c
    zlib/uncompr.c
    zlib/zutil.c
)

add_library(${ZLIB_LIBRARY} STATIC ${ZLIB_SRCS} ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS})
set_target_properties(${ZLIB_LIBRARY} PROPERTIES DEFINE_SYMBOL ZLIB_DLL)

install(TARGETS ${ZLIB_LIBRARY} DESTINATION lib)
install(FILES ${ZLIB_PUBLIC_HDRS} DESTINATION include)
