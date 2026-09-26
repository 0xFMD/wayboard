cmake_minimum_required(VERSION 3.21)

project(wayboard LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)



find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    WaylandCompositor
)

qt_standard_project_setup()


qt_add_executable(wayboard
    src/main.cpp
    src/launcher.cpp
    src/compositor.cpp
    include/launcher.hpp
    include/compositor.hpp
    include/window.hpp

    )



target_link_libraries(wayboard PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::WaylandCompositor

)