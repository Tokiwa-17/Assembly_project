#include "level.h"

#include <fstream>

int LevelLoad(const TCHAR *filePath, Level* pLevel)
{
    std::ifstream ifs(filePath, std::ios::in | std::ios::binary);
    if (ifs.is_open())
        return ERROR_FILE_NOT_FOUND;
    ifs.read(reinterpret_cast<char *>(pLevel), sizeof(Level));
    return 0;
}
