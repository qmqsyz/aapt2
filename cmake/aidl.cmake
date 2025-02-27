find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

if(NOT BISON_FOUND)
    message(FATAL_ERROR "can't find the bison")
endif()

if(NOT FLEX_FOUND)
    message(FATAL_ERROR "can't find the flex")
endif()

# generate aidl_language_y.h and aidl_language_y.cpp
bison_target(
    LangParser ${SRC_PATH}/aidl/aidl_language_y.yy ${SRC_PATH}/aidl/aidl_language_y.cpp
    DEFINES_FILE ${SRC_PATH}/aidl/aidl_language_y.h)

# generate aidl_language_l.h and aidl_language_l.cpp
flex_target(
    LangScanner ${SRC_PATH}/aidl/aidl_language_l.ll ${SRC_PATH}/aidl/aidl_language_l.cpp
    DEFINES_FILE ${SRC_PATH}/aidl/aidl_language_l.h)

# add dependency
add_flex_bison_dependency(LangScanner LangParser)

message(STATUS ${FLEX_LangScanner_OUTPUTS})          
message(STATUS ${BISON_LangParser_OUTPUTS})

add_executable(aidl
    ${SRC_PATH}/aidl/aidl_checkapi.cpp
    ${SRC_PATH}/aidl/aidl_const_expressions.cpp
    ${SRC_PATH}/aidl/aidl_dumpapi.cpp
    ${SRC_PATH}/aidl/aidl_language_l.ll
    ${SRC_PATH}/aidl/aidl_language_y.yy
    ${SRC_PATH}/aidl/aidl_language.cpp
    ${SRC_PATH}/aidl/aidl_to_cpp_common.cpp
    ${SRC_PATH}/aidl/aidl_to_cpp.cpp
    ${SRC_PATH}/aidl/aidl_to_java.cpp
    ${SRC_PATH}/aidl/aidl_to_ndk.cpp
    ${SRC_PATH}/aidl/aidl_to_rust.cpp
    ${SRC_PATH}/aidl/aidl_typenames.cpp
    ${SRC_PATH}/aidl/aidl.cpp
    ${SRC_PATH}/aidl/ast_java.cpp
    ${SRC_PATH}/aidl/check_valid.cpp
    ${SRC_PATH}/aidl/code_writer.cpp
    ${SRC_PATH}/aidl/comments.cpp
    ${SRC_PATH}/aidl/diagnostics.cpp
    ${SRC_PATH}/aidl/generate_aidl_mappings.cpp
    ${SRC_PATH}/aidl/generate_cpp.cpp
    ${SRC_PATH}/aidl/generate_java_binder.cpp
    ${SRC_PATH}/aidl/generate_java.cpp
    ${SRC_PATH}/aidl/generate_ndk.cpp
    ${SRC_PATH}/aidl/generate_rust.cpp
    ${SRC_PATH}/aidl/import_resolver.cpp
    ${SRC_PATH}/aidl/io_delegate.cpp
    ${SRC_PATH}/aidl/location.cpp
    ${SRC_PATH}/aidl/logging.cpp
    ${SRC_PATH}/aidl/options.cpp
    ${SRC_PATH}/aidl/parser.cpp
    ${SRC_PATH}/aidl/permission.cpp
    ${SRC_PATH}/aidl/preprocess.cpp
    ${SRC_PATH}/aidl/main.cpp
    ${BISON_LangParser_OUTPUTS}
    ${FLEX_LangScanner_OUTPUTS})

target_include_directories(aidl PRIVATE
    ${SRC_PATH}/libbase/include
    ${SRC_PATH}/fmtlib/include
    ${SRC_PATH}/googletest/googletest/include)
    
target_link_libraries(aidl
    libbase
    liblog
    gtest
    fmt::fmt)