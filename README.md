# CppExtendedEnum

## [EnumGenerator.cmake](./EnumGenerator.cmake)

- Provides the Generate_Enum function, which will create targets containing the
appropriate header and source files for the given enums that other targets
can link to.
- The created target will be created as: `<top_level_project>::<enum_name>`.
For convenience, the CMake variable `<project_name>_GENERATED_ENUMS` will be
set to the list of generated targets.

- Example usage:

```cmake
include(script/EnumGenerator/EnumGenerator.cmake)

set(ENUM_JSONS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/Enum1.json"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/Enum2.json")

Generate_Enum(${ENUM_JSONS})

target_link_libraries(DBFLib PRIVATE Foo::Enum1 Foo::Enum2)
# OR
target_link_libraries(DBFLib PRIVATE ${Foo_GENERATED_ENUMS})
```
