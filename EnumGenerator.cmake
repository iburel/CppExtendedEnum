################################################################################
# File: EnumGenerator.cmake
# Created Date: Tue Jan 04 2022
# Author: Nicolas IRAGNE (nicolas.iragne@alyce.fr)
# -----
# Provides the Generate_Enum function, which will create targets containing the
# appropriate header and source files for the given enums that other targets
# can link to.
# The created target will be created as: <top_level_project>::<enum_name>.
# -----
################################################################################

cmake_minimum_required(VERSION 3.17)

if (NOT Python3_EXECUTABLE)
    Find_Package(Python3 COMPONENTS Interpreter REQUIRED)
endif()

function(Generate_Enum)

set(GENERATOR ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/EnumGenerator.py)
set(GENERATOR_HEADERS ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/EnumPattern.h.in)
set(GENERATOR_SOURCES ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/EnumPattern.cpp.in)
set(GENERATED_SOURCES_FOLDER "${CMAKE_CURRENT_BINARY_DIR}/generated-src")

message(STATUS "Generating enum files...")
foreach(ENUM_JSON ${ARGN})
    get_filename_component(FILENAME ${ENUM_JSON} NAME_WE)
    set(HEADER_OUT ${GENERATED_SOURCES_FOLDER}/${FILENAME}.h)
    set(CPP_OUT ${GENERATED_SOURCES_FOLDER}/${FILENAME}.cpp)
    list(APPEND GENERATED_SOURCES ${HEADER_OUT} ${CPP_OUT})
    add_custom_command(
        OUTPUT ${HEADER_OUT} ${CPP_OUT}
        DEPENDS ${ENUM_JSON} ${GENERATOR} ${GENERATOR_HEADERS} ${GENERATOR_SOURCES}
        COMMAND ${Python3_EXECUTABLE} ${GENERATOR} ${ENUM_JSON} ${GENERATED_SOURCES_FOLDER}
        COMMENT "Generating ${HEADER_OUT} and ${CPP_OUT} from ${ENUM_JSON}")
    add_library(${FILENAME} ${HEADER_OUT} ${CPP_OUT})
    set_target_properties(${FILENAME} PROPERTIES PUBLIC_HEADER ${HEADER_OUT})
    target_include_directories(
        ${FILENAME} PUBLIC
        $<BUILD_INTERFACE:${GENERATED_SOURCES_FOLDER}>
        $<INSTALL_INTERFACE:include>
    )
    set_property(TARGET ${FILENAME} PROPERTY CXX_STANDARD 20)
    add_library(${CMAKE_PROJECT_NAME}::${FILENAME} ALIAS ${FILENAME})
    install(TARGETS ${FILENAME}
        LIBRARY DESTINATION bin
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include
        )

endforeach(ENUM_JSON)

endfunction(Generate_Enum)
