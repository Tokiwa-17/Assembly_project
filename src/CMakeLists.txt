set(MUG_HEADERS
    window.inc
    timer.inc
    game.inc
)

set(MUG_SOURCES
    window.asm
    timer.asm
    game.asm
)


add_executable(${PROJECT_NAME} ${MUG_SOURCES} game.rc)
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE ASM_MASM)
target_include_directories(${PROJECT_NAME} PUBLIC ${MASM_HOME}/include)
target_link_directories(${PROJECT_NAME} PRIVATE ${MASM_HOME}/lib)
