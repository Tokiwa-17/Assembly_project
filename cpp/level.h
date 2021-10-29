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
#define GAME_MAX_NOTES 512
#define MAX_NAME_LENGTH 128

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
        NOTE_TAP = 'o',
        NOTE_CATCH = '-',
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

    typedef struct LevelNote
    {
        Time time;
        NoteType type;
    } LevelNote;

    typedef struct Level
    {
        TCHAR musicName[MAX_NAME_LENGTH];
        TCHAR author[MAX_NAME_LENGTH];
        TCHAR musicPath[MAX_NAME_LENGTH];
        TCHAR imagePath[MAX_NAME_LENGTH];
        TCHAR musicSelectPath[MAX_NAME_LENGTH];
        // etc.
        LevelDifficulty difficulty;
        // may be different from music time
        Time totalTime;
        UINT32 totalTapCount;
        UINT32 totalCatchCount;
        UINT32 totalNoteCount;
        UINT32 noteCounts[GAME_KEY_COUNT];
        LevelNote notes[GAME_KEY_COUNT][GAME_MAX_NOTES];
    } Level;

    int LevelLoad(const TCHAR *filePath, Level* pLevel);

#ifdef __cplusplus
}
#endif
