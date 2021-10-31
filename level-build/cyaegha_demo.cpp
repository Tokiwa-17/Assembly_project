/**
 * @file cyaegha.cpp
 * @author Tu Yijie (you@domain.com)
 * @brief Cyaegha by USAO, from Arcaea@lowiro
 * @version 0.1
 * @date 2021-10-16
 * 
 * @copyright Copyright (c) 2021
 * 
 * https://www.bilibili.com/video/BV1Rv4y1f7PN/
 */

#include "level_builder.hpp"

#ifdef _MSC_VER
#pragma warning(disable : 4102)
#endif

int main()
{
    LevelBuilderInfo info;
    info.name = "Cyaegha";
    info.author = "USAO";
    info.musicPath = "levels/Cyaegha.wav";
    info.imagePath = "../../src/Cyaegha_play.bmp";
    info.musicSelectPath = "levels/Cyaegha_30s.wav";
    info.difficulty = DIFFICULTY_NORMAL;
    info.offset = 0; // TODO

    auto lb = LevelBuilder(info, 200.0f);
    // 1 = 4/4
sec_1:
    rep(4) lb.Add(4, {2, '-'});
sec_2:
    lb.Add(4, {2, 'o'}, {1, '-'});
    rep(3) lb.Add(4, {2, '-'});
sec_3:
    rep(4) lb.Add(4, {1, '-'});
sec_4:
    lb.Add(4, {1, '-'}, {2, 'o'});
    rep(3) lb.Add(4, {1, '-'});
sec_5:
    lb.Add(2, {3, 'o'});
    lb.Add(2, {3, 'o'}, {2, 'o'});
sec_6:
    lb.Add(2, {0, 'o'});
    lb.Add(2, {0, 'o'}, {1, 'o'});
sec_7:
    lb.Add(2, {3, 'o'});
    lb.Add(2, {0, 'o'}, {3, 'o'});
sec_8:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_9:
    rep(3) lb.Add(4, {1, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
sec_10:
    rep(3) lb.Add(4, {2, '-'});
    lb.Add(4, {2, '-'}, {1, 'o'});
sec_11:
    rep(4) lb.Add(4, {1, '-'});
sec_12:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_13:
    lb.AddTime(8); // ��ֹ
    lb.Add(8, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
sec_14:
    lb.AddTime(8);
    lb.Add(8, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
sec_15:
    for (uint8_t i = 0; i < 4; ++i)
        rep(2) lb.Add(8, {i, 'o'});
sec_16:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
sec_17:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {1, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
sec_18:
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {1, '-'});
sec_19:
    lb.Add(4, {0, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, '-'}, {2, '-'});
sec_20:
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, '-'}, {1, '-'});
sec_21:
    lb.Add(4, {2, '-'}, {3, '-'});
    lb.Add(4, {1, '-'}, {3, '-'});
    lb.Add(4, {2, '-'}, {3, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
sec_22:
    lb.Add(4, {1, '-'}, {3, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {3, '-'});
    lb.Add(4, {2, '-'}, {3, '-'});
sec_23:
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {2, '-'}, {3, '-'});
sec_24:
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {0, '-'});
    lb.Add(4, {0, '-'}, {3, 'o'});
    lb.Add(4, {0, '-'}, {3, '-'});
sec_25:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'});

}
