set(MUG_CPP_HEADERS
    resource.h
    app.h
    game.h
)

set(MUG_CPP_SOURCES
    app.c
    game.c
)

add_executable(mug-cpp ${MUG_CPP_HEADERS} ${MUG_CPP_SOURCES} resource.rc)

cmake_policy(PUSH)
cmake_policy(SET CMP0076 NEW)
target_sources(mug-cpp INTERFACE ${MUG_CPP_HEADERS})
cmake_policy(POP)
