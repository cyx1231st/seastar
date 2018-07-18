#
# This file is open source software, licensed to you under the terms
# of the Apache License, Version 2.0 (the "License").  See the NOTICE file
# distributed with this work for additional information regarding copyright
# ownership.  You may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

#
# Copyright (C) 2018 Scylladb, Ltd.
#

set (_stdfilesystem_test_source ${CMAKE_CURRENT_LIST_DIR}/code_test/StdFilesystem_test.cc)

try_compile (StdFilesystem_test_stdc++fs
  ${CMAKE_CURRENT_BINARY_DIR}
  SOURCES ${_stdfilesystem_test_source}
  CMAKE_FLAGS -DCMAKE_CXX_FLAGS="-std=c++17"
  LINK_LIBRARIES stdc++fs)

if (StdFilesystem_test_stdc++fs)
  set (StdFilesystem_LIBRARY_NAME stdc++fs)
else ()
  # Try libc++.
  try_compile (StdFilesystem_test_c++experimental
    ${CMAKE_CURRENT_BINARY_DIR}
    SOURCES ${_stdfilesystem_test_source}
    CXX_STANDARD 17
    LINK_LIBRARIES libc++experimental)

  if (StdFilesystem_test_c++experimental)
    set (StdFilesystem_LIBRARY_NAME c++experimental)
  endif ()
endif ()

if (StdFilesystem_LIBRARY_NAME)
  set (StdFilesystem_FOUND ON)
endif ()

include (FindPackageHandleStandardArgs)

find_package_handle_standard_args (StdFilesystem
  FOUND_VAR StdFilesystem_FOUND
  REQUIRED_VARS
    StdFilesystem_LIBRARY_NAME)

if (StdFilesystem_FOUND AND NOT (TARGET StdFilesystem::filesystem))
  add_library (StdFilesystem::filesystem INTERFACE IMPORTED)

  set_target_properties (StdFilesystem::filesystem
    PROPERTIES
      INTERFACE_LINK_LIBRARIES ${StdFilesystem_LIBRARY_NAME})
endif ()

mark_as_advanced (StdFilesystem_LIBRARY_NAME)
