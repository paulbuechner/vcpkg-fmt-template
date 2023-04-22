########################################################################
#
# Helper functions for creating build targets.

# cxx_executable_with_flags(name cxx_flags libs srcs...)
#
# creates a named C++ executable that depends on the given libraries and
# is built from the given source files with the given compiler flags.
function (cxx_executable_with_flags name cxx_flags libs)
  add_executable(${name} ${ARGN})
  if (cxx_flags)
    set_target_properties(${name}
                          PROPERTIES
                          COMPILE_FLAGS "${cxx_flags}")
  endif ()
  # To support mixing linking in static and dynamic libraries, link each
  # library in with an extra call to target_link_libraries.
  foreach (lib ${libs})
    target_link_libraries(${name} ${lib})
  endforeach ()
endfunction ()

# cxx_executable(name dir lib srcs...)
#
# creates a named target that depends on the given libs and is built
# from the given source files.  dir/name.cc is implicitly included in
# the source file list.
function (cxx_executable name dir libs)
  cxx_executable_with_flags(
    ${name} "${cxx_default}" "${libs}" "${dir}/${name}.cc" ${ARGN})
endfunction ()


#######################################################################
#
# Configure compiler warnings

# Turn on warnings on the given target
function (target_enable_warnings target_name)
  if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    list(APPEND MSVC_OPTIONS "/W4")
    if (MSVC_VERSION GREATER 1900) # Allow non fatal security warnings for msvc 2015
      list(APPEND MSVC_OPTIONS "/WX")
    endif ()
  endif ()

  target_compile_options(
    ${target_name}
    PRIVATE $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
    -Wall
    -Wextra
    -Wconversion
    -pedantic
    -Werror
    -Wfatal-errors>
    $<$<CXX_COMPILER_ID:MSVC>:${MSVC_OPTIONS}>)
endfunction ()

########################################################################
#
# Configure installation

# Install 3rd party copyright notices
function (build_3rd_party_copyright)
  set(LICENSE_3RD_PARTY_FILE ${CMAKE_CURRENT_BINARY_DIR}/LICENSE-3RD-PARTY.txt)
  file(REMOVE ${LICENSE_3RD_PARTY_FILE}) # Delete the old file

  file(GLOB SEARCH_RESULT "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/share/**/copyright")
  set(COPYRIGHT_FILES ${SEARCH_RESULT} CACHE INTERNAL "copyright files")

  # Handle duplicate copyright files
  # remove_duplicate_by_file_content("${COPYRIGHT_FILES}" "COPYRIGHT_FILES" "...")

  # Exclude libraries by name
  set(EXCLUDED_LIBRARIES "vcpkg-*")

  foreach (copyright_file ${COPYRIGHT_FILES})
    string(REGEX MATCH ".*/(.*)/copyright" _ ${copyright_file})
    if ("${CMAKE_MATCH_1}" STREQUAL "")
      string(REGEX MATCH ".*/(.*)/LICENSE" _ ${copyright_file})
    endif ()
    set(LIBRARY_NAME ${CMAKE_MATCH_1})

    # Check if the library name matches any of the excluded patterns
    set(EXCLUDE_LIBRARY FALSE)
    foreach (pattern IN ITEMS ${EXCLUDED_LIBRARIES})
      if (LIBRARY_NAME MATCHES ${pattern})
        set(EXCLUDE_LIBRARY TRUE)
        break() # Exit the inner loop
      endif ()
    endforeach ()

    if (EXCLUDE_LIBRARY)
      continue() # Skip the current iteration
    endif ()

    file(APPEND ${LICENSE_3RD_PARTY_FILE} "-------------------------------------------------\n")
    file(APPEND ${LICENSE_3RD_PARTY_FILE} "${LIBRARY_NAME}\n")
    file(APPEND ${LICENSE_3RD_PARTY_FILE} "-------------------------------------------------\n")
    file(READ ${copyright_file} COPYRIGHT_CONTENTS)
    file(APPEND ${LICENSE_3RD_PARTY_FILE} "${COPYRIGHT_CONTENTS}\n")
  endforeach ()
endfunction ()

# Remove duplicate from list by content
function (remove_duplicate_by_file_content list list_name filter_by)
  set(INCLUDED OFF)
  foreach (file ${list})
    file(STRINGS ${file} content)
    string(FIND "${content}" ${filter_by} FOUND)
    if (NOT ${FOUND} EQUAL -1)
      if (INCLUDED)
        list(REMOVE_ITEM list ${file})
      else ()
        set(INCLUDED ON)
      endif ()
    endif ()
  endforeach ()
  set(${list_name} ${list} PARENT_SCOPE)
endfunction ()
