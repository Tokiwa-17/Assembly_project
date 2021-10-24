#include "game.h"
#include "app.h"

// singleton
static Game sGame;

void GameInit()
{
    // Config base info
    sGame.judgeLineY = 500; // TODO

    // Load game settings ?
    sGame.speedLevel = 8;
    sGame.judgeDelay = 0;
    sGame.keyMaps[0] = 'F';
    sGame.keyMaps[1] = 'G';
    sGame.keyMaps[2] = 'H';
    sGame.keyMaps[3] = 'J';

    // Load data
    sGame.levelCount = 0;
    sGame.levels = NULL;

    // state
    sGame.currentPage = GAME_PAGE_HOME;
    sGame.currentLevelID = 0;
    sGame.pCurLevel = NULL;
}

void GameShutdown()
{
    // Clear resources
}

#define LEVEL_START_DELAY 2000

// when GamePage changed from GAME_PAGE_CHOOSE to GAME_PAGE_PLAYING
void GameLevelReset(UINT levelIndex)
{
    sGame.currentLevelID = levelIndex;
    sGame.pCurLevel = &sGame.levels[levelIndex];
    sGame.levelState = GAME_LEVEL_RESET;
    for (UINT i = 0; i < GAME_KEY_COUNT; ++i)
    {
        SIZE_T count = sGame.pCurLevel->noteCounts[i];
        sGame.levelRecord.records[i] = (LevelNoteRecord *)malloc(sizeof(LevelNoteRecord) * count);
        memset(&sGame.levelRecord.records[i], 0, sizeof(LevelRecord) * count);
        sGame.levelRecord.currentIndices[i] = 0;
        sGame.keyPressing[i] = FALSE;
    }
    for (UINT i = 0; i < NOTE_JUDGE_COUNT; ++i)
        sGame.levelRecord.tapJudgesCount[i] = 0;
    sGame.levelRecord.catchJudgeCount[0] = 0;
    sGame.levelRecord.catchJudgeCount[1] = 0;

    // need delay ?
    // PlaySound async
    sGame.levelState = GAME_LEVEL_PLAYING;
    sGame.levelBeginTime = timeGetTime() - sGame.judgeDelay;
}

// level play end
void GameLevelEnd()
{
    for (UINT i = 0; i < GAME_KEY_COUNT; ++i)
        free(&sGame.levelRecord.records[i]);
    sGame.pCurLevel = NULL;
}

// -25ms ~ +25ms
#define NOTE_JUDGE_CRITICAL_PERFECT_LIMIT 25
// -50ms ~ +50ms
#define NOTE_JUDGE_PERFECT_LIMIT 50
// -100ms ~ +100ms
#define NOTE_JUDGE_GREAT_LIMIT 100
// miss: < -100ms or > +100ms

void NoteTapJudgement(UINT index)
{
    UINT curIndex = sGame.levelRecord.currentIndices[index];
    Time judgeTime = sGame.keyPressTime[index];
    while (curIndex < sGame.pCurLevel->noteCounts[index])
    {
        LevelNote *note = &sGame.pCurLevel->notes[index][curIndex];
        LevelNoteRecord *record = &sGame.levelRecord.records[index][curIndex];
        if (note->type == NOTE_CATCH)
            // handle in other place
            break;
        // is tap
        if (judgeTime > note->time)
        {
            Time diff = record->judgeTime - note->time;
            if (diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT)
                record->judgement = NOTE_JUDGE_CRITICAL_PERFECT;
            else if (diff <= NOTE_JUDGE_PERFECT_LIMIT)
                record->judgement = NOTE_JUDGE_PERFECT_LATE;
            else if (diff <= NOTE_JUDGE_GREAT_LIMIT)
                record->judgement = NOTE_JUDGE_GREAT_LATE;
            else
                record->judgement = NOTE_JUDGE_MISS;
        }
        else
        {
            Time diff = note->time - record->judgeTime;
            if (diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT)
                record->judgement = NOTE_JUDGE_CRITICAL_PERFECT;
            else if (diff <= NOTE_JUDGE_PERFECT_LIMIT)
                record->judgement = NOTE_JUDGE_PERFECT_EARLY;
            else if (diff <= NOTE_JUDGE_GREAT_LIMIT)
                record->judgement = NOTE_JUDGE_GREAT_EARLY;
            else
                break; // too early
        }
        record->judgeTime = judgeTime;
        ++sGame.levelRecord.tapJudgesCount[record->judgement];
        ++curIndex;
        if (record->judgement != NOTE_JUDGE_MISS)
            break; // !!! check next note
    }
    sGame.levelRecord.currentIndices[index] = curIndex;
}

void NoteCatchJudgement(UINT index, Time currentTime)
{
    UINT curIndex = sGame.levelRecord.currentIndices[index];
    while (curIndex < sGame.pCurLevel->noteCounts[index])
    {
        LevelNote *note = &sGame.pCurLevel->notes[index][curIndex];
        LevelNoteRecord *record = &((sGame.levelRecord).records[index][curIndex]);
        if (note->type == NOTE_TAP)
            // handle in other place
            break;
        // is catch
        if (note->time > currentTime + NOTE_JUDGE_PERFECT_LIMIT)
            break; // too early
        if (note->time + NOTE_JUDGE_PERFECT_LIMIT >= sGame.keyPressTime[index])
        {
            record->judgeTime = note->time;
            record->judgement = NOTE_JUDGE_CRITICAL_PERFECT;
            ++sGame.levelRecord.catchJudgeCount[0];
        }
        {
            record->judgeTime = currentTime;
            record->judgement = NOTE_JUDGE_MISS;
            ++sGame.levelRecord.catchJudgeCount[1];
        }
        ++curIndex;
    }
    sGame.levelRecord.currentIndices[index] = curIndex;
}

void GameKeyCallback(UINT8 keyCode, BOOL down, BOOL previousDown)
{
    switch (sGame.currentPage)
    {
    case GAME_PAGE_HOME:
        // TODO
        break;
    case GAME_PAGE_CHOOSE:
        // TODO
        break;
    case GAME_PAGE_SETTING:
        // TODO
        break;
    case GAME_PAGE_PLAYING:
        for (UINT index = 0; index < GAME_KEY_COUNT; ++index)
        {
            if (sGame.keyMaps[index] == keyCode)
            {
                if (down)
                {
                    sGame.keyPressing[index] = TRUE;
                    if (!previousDown)
                    {
                        sGame.keyPressTime[index] = timeGetTime() - sGame.levelBeginTime;
                        NoteTapJudgement(index);
                    }
                }
                else
                {
                    sGame.keyPressing[index] = FALSE;
                    NoteCatchJudgement(index, timeGetTime() - sGame.levelBeginTime);
                }
                break;
            }
        }
        break;
    default:
        break;
    }
}

void GameUpdate()
{
    switch (sGame.currentPage)
    {
    case GAME_PAGE_HOME:
        // TODO
        break;
    case GAME_PAGE_CHOOSE:
        // TODO
        break;
    case GAME_PAGE_SETTING:
        // TODO
        break;
    case GAME_PAGE_PLAYING:
        Time currentTime = timeGetTime() - sGame.levelBeginTime;
        for (UINT i = 0; i < GAME_KEY_COUNT; ++i)
            if (sGame.keyPressing[i])
                NoteCatchJudgement(i, currentTime);
        // TODO
        break;
    default:
        break;
    }
}

void GameDraw(HDC hDC)
{
    LONG width, height;
    AppGetInnerSize(&width, &height);
    RECT rect = {0, 0, width, height};
    FillRect(hDC, &rect, (HBRUSH)GetStockObject(GRAY_BRUSH));

    switch (sGame.currentPage)
    {
    case GAME_PAGE_HOME:
        // TODO
        break;
    case GAME_PAGE_CHOOSE:
        // TODO
        break;
    case GAME_PAGE_SETTING:
        // TODO
        break;
    case GAME_PAGE_PLAYING:
        // TODO
        break;
    default:
        break;
    }
}

//////// Utilities /////////

UINT GameCalcNoteCenterY(Time noteTime, Time currentTime)
{
    if (currentTime > noteTime)
        return sGame.judgeLineY + (currentTime - noteTime) * sGame.speedLevel / 16;
    else
        return sGame.judgeLineY - (noteTime - currentTime) * sGame.speedLevel / 16;
}
