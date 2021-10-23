set(MUG_HEADERS
    utils.inc,
    resource.inc,
    game.inc
)

set(MUG_SOURCES
    main.asm
    game.asm
    utils.asm
)

add_executable(${PROJECT_NAME} ${MUG_SOURCES} resource.rc)
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE ASM_MASM)
target_include_directories(${PROJECT_NAME} PUBLIC ${MASM_HOME}/include)
target_link_directories(${PROJECT_NAME} PRIVATE ${MASM_HOME}/lib)


