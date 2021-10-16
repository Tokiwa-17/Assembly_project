function (add_level level_name)
    add_executable(${level_name} ${level_name}.cpp)
    target_include_directories(${level_name} PRIVATE ${PROJECT_SOURCE_DIR}/cpp PRIVATE ./)
    set_target_properties(${level_name} PROPERTIES CXX_STANDARD 17)
endfunction()

add_level(cyaegha)
