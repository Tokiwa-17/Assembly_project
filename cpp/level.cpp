#include "level.h"

#include <fstream>

int LevelLoad(const TCHAR *filePath, Level* pLevel)
{
    std::ifstream ifs(filePath, std::ios::in | std::ios::binary);
    if (ifs.is_open())
        return ERROR_FILE_NOT_FOUND;
    ifs.read(reinterpret_cast<char *>(pLevel), sizeof(Level));
    for (size_t i = 0; i < GAME_KEY_COUNT; ++i)
    {
        // size_t offset = (size_t)pLevel->notes[i];
        pLevel->notes[i] = new LevelNote[pLevel->noteCounts[i]];
        ifs.read(reinterpret_cast<char *>(pLevel->notes[i]), sizeof(LevelNote) * pLevel->noteCounts[i]);
    }
    return 0;
}

void LevelDestroy(Level *pLevel)
{
    for (size_t i = 0; i < GAME_KEY_COUNT; ++i)
        delete pLevel->notes[i];
}
