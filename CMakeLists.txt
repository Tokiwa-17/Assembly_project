cmake_minimum_required(VERSION 3.10)

if (MASM_HOME)
    message(STATUS "Use masm directory: ${MASM_HOME}")
else()
    message(FATAL_ERROR "Please add configure arg -DMASM_HOME=<your masm directory>")
endif()

project(asm_mug LANGUAGES C CXX ASM_MASM)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

add_subdirectory(cpp)
add_subdirectory(level-build)

if (MSVC)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SAFESEH:NO")
endif()
add_subdirectory(src)
