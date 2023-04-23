cmake_minimum_required(VERSION 3.25)

set(VCPKG_FMT_TEMPLATE_VERSION 0.0.0)
project(vcpkg-fmt-template VERSION ${VCPKG_FMT_TEMPLATE_VERSION} LANGUAGES CXX)

# Set default build to release
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose Release or Debug" FORCE)
endif ()

# Compiler config
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# make sure __cplusplus is defined when using msvc and enable parallel build
if (MSVC)
  string(APPEND CMAKE_CXX_FLAGS " /Zc:__cplusplus /MP")
endif ()

set(CMAKE_CXX_EXTENSIONS OFF)

if (CMAKE_SYSTEM_NAME MATCHES "CYGWIN" OR CMAKE_SYSTEM_NAME MATCHES "MSYS")
  set(CMAKE_CXX_EXTENSIONS ON)
endif ()

# warning options
option(VCPKG_FMT_TEMPLATE_BUILD_WARNINGS "Enable compiler warnings" OFF)

include(GNUInstallDirs)

# Define helper functions and macros used by occutils
include(cmake/internal_utils.cmake)

# Licensing
build_3rd_party_copyright()

# Dependencies
find_package(fmt CONFIG REQUIRED)

# Set libs to link against
list(APPEND VCPKG_FMT_TEMPLATE_LIBS fmt::fmt)

# Build
cxx_executable(${PROJECT_NAME} src "${VCPKG_FMT_TEMPLATE_LIBS}")

if (VCPKG_FMT_TEMPLATE_BUILD_WARNINGS)
  target_enable_warnings(${PROJECT_NAME})
endif ()

# Configure install
include(InstallRequiredSystemLibraries)
install(TARGETS ${PROJECT_NAME}
        DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES
        ${CMAKE_CURRENT_LIST_DIR}/README.md
        ${CMAKE_CURRENT_LIST_DIR}/LICENSE
        ${CMAKE_BINARY_DIR}/LICENSE-3RD-PARTY.txt
        DESTINATION ${CMAKE_INSTALL_DOCDIR})

# Packaging
include(cmake/vcpkg-fmt-template-cpack.cmake)
