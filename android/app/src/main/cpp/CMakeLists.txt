cmake_minimum_required(VERSION 3.4.1)

add_library(
        root_check
        SHARED
        root_check.c
)

find_library(
        log-lib
        log
)

target_link_libraries(
        root_check
        ${log-lib}
)