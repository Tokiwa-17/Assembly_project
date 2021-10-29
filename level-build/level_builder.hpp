#pragma once

#include <string_view>
#include <vector>
#include <tuple>
#include <fstream>
#include <filesystem>
#include <cassert>

#include "../cpp/level.h"

struct LevelBuilderInfo
{
    std::string_view name;
    std::string_view author;
    std::string_view musicPath;
    std::string_view imagePath;
    LevelDifficulty difficulty;
    Time offset;
};

class LevelBuilder
{
public:
    LevelBuilder(const LevelBuilderInfo &info, float initBPM)
    {
        memset(&level, 0, sizeof(Level));
        memcpy_s(level.musicName, MAX_NAME_LENGTH - 1, info.name.data(), info.name.size());
        level.musicName[info.name.size()] = '\0';
        memcpy_s(level.author, MAX_NAME_LENGTH - 1, info.author.data(), info.author.size());
        level.author[info.author.size()] = '\0';
        memcpy_s(level.musicPath, MAX_NAME_LENGTH - 1, info.musicPath.data(), info.musicPath.size());
        level.musicPath[info.musicPath.size()] = '\0';
        memcpy_s(level.imagePath, MAX_NAME_LENGTH - 1, info.imagePath.data(), info.imagePath.size());
        level.imagePath[info.imagePath.size()] = '\0';
        level.difficulty = info.difficulty;

        currentBPM = initBPM;
        currentTime = float(info.offset / 1000);
    }

    ~LevelBuilder()
    {
        level.totalTime = Time(ceilf(currentTime * 1000) + 1000);
        size_t offset = 0;
        for (size_t i = 0; i < GAME_KEY_COUNT; ++i)
        {
            assert(notes[i].size() < GAME_MAX_NOTES);
            level.noteCounts[i] = uint32_t(notes[i].size());
            memcpy_s(level.notes[i], GAME_MAX_NOTES * sizeof(LevelNote), notes[i].data(), notes[i].size() * sizeof(LevelNote));
        }
        std::string folder = "./levels/";
        if (!std::filesystem::exists(folder))
            std::filesystem::create_directory(folder);
        std::ofstream ofs(folder + level.musicName + ".level", std::ios::binary | std::ios::out);
        ofs.write(reinterpret_cast<char *>(&level), sizeof(Level));
    }

    LevelBuilder(const LevelBuilder &) = delete;
    LevelBuilder &operator=(const LevelBuilder &) = delete;
    LevelBuilder(LevelBuilder &&rhs) noexcept = delete;
    LevelBuilder &operator=(LevelBuilder &&rhs) = delete;

    void SetBPM(float bpm) noexcept
    {
        currentBPM = bpm;
    }

    /// @brief 在当前时刻添加音符
    /// @param timeVal 时值 e.g. {3, 4} 表示3个4分音符时值
    /// @param note 音符 e.g. {1, 'o'}, {2, '-'} 分别表示轨道1上一个tap, 轨道2上一个catch
    void Add(std::pair<uint8_t, uint8_t> timeVal, std::pair<uint8_t, char> note)
    {
        assert(timeVal.second > 0);
        assert(note.first < GAME_KEY_COUNT);
        assert(note.second == 'o' || note.second == '-');
        notes[note.first].push_back({Time(currentTime * 1000), NoteType(note.second)});
        if (note.second == 'o')
            ++level.totalTapCount;
        else
            ++level.totalCatchCount;
        ++level.totalNoteCount;
        AddTime(timeVal);
    }

    void Add(uint8_t denominator, std::pair<uint8_t, char> note)
    {
        Add({1, denominator}, note);
    }

    void Add(std::pair<uint8_t, uint8_t> timeVal, std::pair<uint8_t, char> note1, std::pair<uint8_t, char> note2)
    {
        assert(timeVal.second > 0);
        assert(note1.first != note2.first);
        assert(note1.first < GAME_KEY_COUNT);
        assert(note2.first < GAME_KEY_COUNT);
        assert(note1.second == 'o' || note1.second == '-');
        assert(note2.second == 'o' || note2.second == '-');
        notes[note1.first].push_back({Time(currentTime * 1000), NoteType(note1.second)});
        notes[note2.first].push_back({Time(currentTime * 1000), NoteType(note2.second)});
        if (note1.second == 'o')
            ++level.totalTapCount;
        else
            ++level.totalCatchCount;
        if (note2.second == 'o')
            ++level.totalTapCount;
        else
            ++level.totalCatchCount;
        level.totalNoteCount += 2;
        AddTime(timeVal);
    }

    void Add(uint8_t denominator, std::pair<uint8_t, char> note1, std::pair<uint8_t, char> note2)
    {
        Add({1, denominator}, note1, note2);
    }

    void Add(std::pair<uint8_t, uint8_t> timeVal, uint8_t types[GAME_KEY_COUNT])
    {
        assert(timeVal.second > 0);
        for (size_t i = 0; i < GAME_KEY_COUNT; ++i)
        {
            assert(types[i] == 'o' || types[i] == '-' || types[i] == ' ');
            if (types[i] == ' ')
                continue;
            notes[i].push_back({Time(currentTime * 1000), NoteType(types[i])});
            if (types[i] == 'o')
                ++level.totalTapCount;
            else
                ++level.totalCatchCount;
            ++level.totalNoteCount;
        }
        AddTime(timeVal);
    }

    void AddTime(std::pair<uint8_t, uint8_t> timeVal) noexcept
    {
        currentTime += float(240 * timeVal.first) / (currentBPM * float(timeVal.second));
    }

    void AddTime(uint8_t denominator) noexcept
    {
        AddTime({1, denominator});
    }

private:
    Level level;
    std::vector<LevelNote> notes[GAME_KEY_COUNT];
    float currentBPM;
    float currentTime;
};

#define rep(times) for (size_t _counter_ = 0; _counter_ < (times); ++_counter_)
