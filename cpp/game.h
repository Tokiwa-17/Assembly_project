#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>

#define GAME_KEY_COUNT 4

    typedef DWORD Time;

    /////////////// Data Struct ///////////////

    typedef enum LevelDifficulty
    {
        DIFFICULTY_EASY,
        DIFFICULTY_NORMAL,
        DIFFICULTY_HARD,
        DIFFICULTY_EXPERT,
    } LevelDifficulty;

    typedef enum NoteType
    {
        NOTE_NONE,
        NOTE_TAP,
        NOTE_CATCH,
    } NoteType;

    typedef enum NoteJudge
    {
        NOTE_JUDGE_CRITICAL_PERFECT,
        NOTE_JUDGE_PERFECT_EARLY,
        NOTE_JUDGE_PERFECT_LATE,
        NOTE_JUDGE_GREAT_EARLY,
        NOTE_JUDGE_GREAT_LATE,
        NOTE_JUDGE_MISS,
        NOTE_JUDGE_COUNT,
    } NoteJudge;

    typedef struct LevelTimePoint
    {
        Time time;
        NoteType notes[GAME_KEY_COUNT];

        ///// playing state ////
        Time judgeTime[GAME_KEY_COUNT];
        NoteJudge judgements[GAME_KEY_COUNT];
    } LevelTimePoint;

    typedef struct Level
    {
        ///// information and data /////
        const TCHAR *musicName;
        const TCHAR *author;
        Time totalTime;
        LevelDifficulty difficulty;
        UINT32 tapCount;
        UINT32 catchCount;
        UINT32 noteCount;
        UINT32 tpCount;
        // sort after load
        LevelTimePoint *timePoints;
        // picture
        // music
        // etc.

        ///// state /////
        // time point index within level
        UINT32 currentTPs[GAME_KEY_COUNT];
        // to calculate score
        UINT32 tapJudgesCount[NOTE_JUDGE_COUNT];
        UINT32 catchJudgeCount[2]; // catch : critical perfect or miss
    } Level;

    /////////////// Game //////////////////

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
        Time levelBeginTime;
        // TODO: record paused time ?
        GameLevelState levelState;
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

#ifdef __cplusplus
}
#endif
