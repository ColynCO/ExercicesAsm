# CMakeList.txt : CMake project for AsmExercices, include source and define
# project specific logic here.
#

# Add source to this project's executable.
enable_language(ASM_MASM)

add_executable (AsmExercices "AsmExercices.cpp" "functions.asm")

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET AsmExercices PROPERTY CXX_STANDARD 20)
endif()

# TODO: Add tests and install targets if needed.
