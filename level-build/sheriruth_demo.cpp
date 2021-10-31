/**
 * @file sheriruth.cpp
 * @author Qi Shijie (shijieqi1@outlook.com)
 * @brief Sheriruth by Team Grimoire, from Arcaea@lowiro
 * @version 0.1
 * @date 2021-10-25
 * 
 * @copyright Copyright (c) 2021
 * 
 * https://www.bilibili.com/video/BV1sa4y177AS
 */

#include "level_builder.hpp"

#ifdef _MSC_VER
#pragma warning(disable : 4102)
#endif

int main()
{
    LevelBuilderInfo info;
    info.name = "Sheriruth";
    info.author = "Team Grimoire";
    info.musicPath = "levels/Sheriruth.wav";
    info.imagePath = "../../src/Sheriruth_play.bmp";
    info.musicSelectPath = "levels/Sheriruth_30s.wav";
    info.difficulty = DIFFICULTY_EXPERT;
    info.offset = 0; // TODO

    auto lb = LevelBuilder(info, 185.0f);
    // 1 = 4/4
sec_1:
    rep(4) lb.AddTime(4);
sec_2:
    lb.Add(8, {1, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    rep(2) lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
sec_3:
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
sec_4:
    lb.Add(8, {0, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    rep(2) lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
sec_5:
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
sec_6:
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
sec_7:
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
sec_8:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_9:
    lb.Add(8, {3, 'o'});
    lb.AddTime(16);
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
sec_10:
    lb.Add(4, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, '-'});
sec_11:
    lb.Add(4, {0, 'o'}, {1, '-'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'});
sec_12:
    lb.Add(4, {0, '-'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, '-'});
sec_13:
    lb.Add(4, {2, '-'}, {3, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'}, {3, 'o'});
sec_14:
    lb.Add(4, {3, '-'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {2, '-'});
sec_15:
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, '-'});
sec_16:
    lb.Add(4, {1, '-'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, '-'});
sec_17:
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'}, {2, '-'});
sec_18:
    lb.Add(4, {2, '-'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {2, '-'});
    //可能冲突
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
sec_19:
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {0, '-'});
    rep(2) lb.Add(8, {0, '-'}, {1, 'o'});
    lb.Add(4, {0, '-'}, {2, 'o'});
sec_20:
    lb.Add(4, {1, '-'}, {3, 'o'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {2, '-'});
    rep(2) lb.Add(4, {1, 'o'}, {2, '-'});
sec_21:
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {1, '-'});
    lb.Add(4, {0, 'o'}, {1, '-'});
    rep(2) lb.Add(8, {1, '-'}, {2, 'o'});

}