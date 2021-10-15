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

    // home page
    sGame.currentPage = GAME_PAGE_HOME;
}

void GameShutdown()
{
    // Clear resources
}

#define LEVEL_START_DELAY 2000

// when GamePage changed from GAME_PAGE_CHOOSE to GAME_PAGE_PLAYING
void LevelReset(UINT levelIndex)
{
    sGame.currentLevelID = levelIndex;
    sGame.pCurLevel = &sGame.levels[levelIndex];
    sGame.levelState = GAME_LEVEL_RESET;
    for (UINT i = 0; i < sGame.pCurLevel->tpCount; ++i)
        for (UINT j = 0; j < GAME_KEY_COUNT; ++j)
            sGame.pCurLevel->timePoints[i].judgeTime[j] = 0;
    for (UINT i = 0; i < GAME_KEY_COUNT; ++i)
    {
        sGame.pCurLevel->currentTPs[i] = 0;
        sGame.keyPressing[i] = FALSE;
    }
    for (UINT i = 0; i < NOTE_JUDGE_COUNT; ++i)
        sGame.pCurLevel->tapJudgesCount[i] = 0;
    sGame.pCurLevel->catchJudgeCount[0] = 0;
    sGame.pCurLevel->catchJudgeCount[1] = 0;

    // need delay ?
    // PlaySound async
    sGame.levelState = GAME_LEVEL_PLAYING;
    sGame.levelBeginTime = timeGetTime() - sGame.judgeDelay;
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
    UINT tpIndex = sGame.pCurLevel->currentTPs[index];
    Time judgeTime = sGame.keyPressTime[index];
    while (tpIndex < sGame.pCurLevel->tpCount)
    {
        LevelTimePoint *tp = &sGame.pCurLevel->timePoints[tpIndex];
        if (tp->notes[index] == NOTE_CATCH)
            // handle in other place
            break;
        if (tp->notes[index] != NOTE_TAP)
        {
            ++tpIndex;
            continue;
        }
        NoteJudge *pJudgement = &tp->judgements[index];
        if (judgeTime > tp->time)
        {
            Time diff = tp->judgeTime[index] - tp->time;
            if (diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT)
                *pJudgement = NOTE_JUDGE_CRITICAL_PERFECT;
            else if (diff <= NOTE_JUDGE_PERFECT_LIMIT)
                *pJudgement = NOTE_JUDGE_PERFECT_LATE;
            else if (diff <= NOTE_JUDGE_GREAT_LIMIT)
                *pJudgement = NOTE_JUDGE_GREAT_LATE;
            else
                *pJudgement = NOTE_JUDGE_MISS;
        }
        else
        {
            Time diff = tp->time - tp->judgeTime[index];
            if (diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT)
                *pJudgement = NOTE_JUDGE_CRITICAL_PERFECT;
            else if (diff <= NOTE_JUDGE_PERFECT_LIMIT)
                *pJudgement = NOTE_JUDGE_PERFECT_EARLY;
            else if (diff <= NOTE_JUDGE_GREAT_LIMIT)
                *pJudgement = NOTE_JUDGE_GREAT_EARLY;
            else
                break; // too early
        }
        tp->judgeTime[index] = judgeTime;
        ++sGame.pCurLevel->tapJudgesCount[*pJudgement];
        ++tpIndex;
        if (*pJudgement != NOTE_JUDGE_MISS)
            break; // !!!
    }
    sGame.pCurLevel->currentTPs[index] = tpIndex;
}

void NoteCatchJudgement(UINT index, Time currentTime)
{
    UINT tpIndex = sGame.pCurLevel->currentTPs[index];
    while (tpIndex < sGame.pCurLevel->tpCount)
    {
        LevelTimePoint *tp = &sGame.pCurLevel->timePoints[tpIndex];
        if (tp->notes[index] == NOTE_TAP)
            // handle in other place
            break;
        else if (tp->notes[index] == NOTE_CATCH)
        {
            if (tp->time + NOTE_JUDGE_CRITICAL_PERFECT_LIMIT < sGame.keyPressTime[index])
                break; // too early
            if (tp->time <= currentTime + NOTE_JUDGE_CRITICAL_PERFECT_LIMIT)
            {
                tp->judgeTime[index] = tp->time;
                tp->judgements[index] = NOTE_JUDGE_CRITICAL_PERFECT;
                ++sGame.pCurLevel->catchJudgeCount[0];
            }
            else
            {
                tp->judgements[index] = currentTime;
                tp->judgements[index] = NOTE_JUDGE_MISS;
                ++sGame.pCurLevel->catchJudgeCount[1];
            }
        }
        ++tpIndex;
    }
    sGame.pCurLevel->currentTPs[index] = tpIndex;
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
