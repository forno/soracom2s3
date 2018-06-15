cmake_minimum_required(VERSION 3.8.2)
project(coracom2s3)

set(CMAKE_CXX_STANDARD          17  CACHE STRING "CXX standard version")
set(CMAKE_CXX_STANDARD_REQUIRED ON  CACHE BOOL   "version required")
set(CMAKE_CXX_EXTENSIONS        OFF CACHE BOOL   "compiler extension")

add_executable(data_converter src/data_converter.cpp)
