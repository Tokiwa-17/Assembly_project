set(MUG_HEADERS
    audio.inc
    draw.inc
    level.inc
    game.inc
)

set(MUG_SOURCES
    audio.asm
    draw.asm
    level.asm
    game.asm
    main.asm
)

source_group("headers" FILES ${MUG_HEADERS})
source_group("sources" FILES ${MUG_SOURCES})

add_executable(${PROJECT_NAME} ${MUG_SOURCES} resource.rc settings.rc)
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE ASM_MASM)
target_include_directories(${PROJECT_NAME} PUBLIC ${MASM_HOME}/include)
target_link_directories(${PROJECT_NAME} PRIVATE ${MASM_HOME}/lib)


