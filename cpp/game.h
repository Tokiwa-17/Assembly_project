#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

#include "level.h"

    typedef struct LevelNoteRecord
    {
        Time judgeTime;
        NoteJudge judgement;
    } LevelNoteRecord;

    typedef struct LevelRecord
    {
        LevelNoteRecord *records[GAME_KEY_COUNT];
        // record indices within level
        UINT32 currentIndices[GAME_KEY_COUNT];
        // to calculate score
        UINT32 tapJudgesCount[NOTE_JUDGE_COUNT];
        UINT32 catchJudgeCount[2]; // catch : critical perfect or miss
    } LevelRecord;

    typedef enum GamePage
    {
        GAME_PAGE_HOME,
        GAME_PAGE_CHOOSE,
        GAME_PAGE_SETTING,
        GAME_PAGE_PLAYING,
    } GamePage;

    typedef enum GameLevelState
    {
        // just reset, prepare to start
        GAME_LEVEL_RESET,
        GAME_LEVEL_PLAYING,
        GAME_LEVEL_PAUSE,
        GAME_LEVEL_END,
        // etc.
    } GameLevelState;

    typedef struct Game
    {
        ///// information /////
        UINT32 judgeLineY;
        // UI design
        // etc.

        ///// settings /////
        UINT32 speedLevel;
        INT32 judgeDelay; // may be negative
        UINT8 keyMaps[GAME_KEY_COUNT];
        // volume
        // effect
        // etc.

        ///// data /////
        UINT32 levelCount;
        Level *levels;
        // brushes
        // pens
        // other pictures
        // other music
        // etc.

        ///// state /////
        GamePage currentPage;
        UINT32 currentLevelID;
        Level *pCurLevel;
        GameLevelState levelState;
        Time levelBeginTime;
        // TODO: record paused time ?
        LevelRecord levelRecord;
        BOOL keyPressing[GAME_KEY_COUNT];
        Time keyPressTime[GAME_KEY_COUNT];

        // TODO
    } Game;

    void GameInit();

    void GameShutdown();

    void GameKeyCallback(UINT8 keyCode, BOOL down, BOOL previousDown);

    void GameUpdate();

    void GameDraw(HDC hDC);

    //////// Utilities /////////

    UINT GameCalcNoteCenterY(Time noteTime, Time currentTime);

    // not implemented
    UINT GameLevelCalcScore();

#ifdef __cplusplus
}
#endif
