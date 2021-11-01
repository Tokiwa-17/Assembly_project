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
    info.musicPath = "Sheriruth.wav";
    info.imagePath = "Sheriruth.bmp";
    info.playImagePath = "Sheriruth_play.bmp";
    info.difficulty = DIFFICULTY_EXPERT;
    info.offset = 0; // TODO

    auto lb = LevelBuilder(info, 185.0f);
    // 1 = 4/4
sec_1:
    rep(4) lb.AddTime(1);
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
sec_22:
    lb.Add(4, {1, '-'}, {3, 'o'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {2, '-'});
sec_23:
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, '-'});
    rep(2) lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(4, {2, '-'}, {3, 'o'});
sec_24:
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {1, 'o'});
    rep(2) lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
sec_25:
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
sec_26:
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(8, {2, '-'});
    lb.Add(8, {1, '-'}, {3, '-'});
    rep(2) lb.Add(4, {1, '-'}, {3, '-'});
sec_27:
    lb.Add(8, {3, '-'});
    lb.Add(8, {2, 'o'}, {3, '-'});
    lb.Add(8, {1, 'o'}, {3, '-'});
    lb.Add(8, {0, 'o'}, {3, '-'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {1, 'o'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {3, 'o'});
sec_28:
    lb.Add(4, {0, '-'}, {2, 'o'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {1, 'o'});
    lb.Add(4, {0, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
sec_29:
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {2, 'o'});
    lb.Add(4, {1, '-'}, {2, 'o'});
sec_30:
    lb.Add(4, {2, '-'}, {3, 'o'});
    lb.Add(8, {2, '-'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {3, 'o'});
    lb.Add(8, {2, '-'});
    lb.Add(8, {1, 'o'}, {2, '-'});
sec_31:
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    rep(2) lb.Add(8, {1, '-'});
    lb.Add(8, {0, 'o'}, {1, '-'});
    lb.Add(8, {0, '-'}, {3, 'o'});
    lb.Add(8, {0, '-'});
sec_32:
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {1, '-'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {1, '-'}, {3, 'o'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {2, 'o'}, {3, '-'});
sec_33:
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {0, 'o'}, {2, '-'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {2, 'o'});
sec_34:
    lb.Add(4, {1, '-'}, {3, 'o'});
    rep(3) lb.Add(4, {0, '-'}, {2, '-'});
sec_35:
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {1, 'o'});
    lb.Add(8, {0, '-'}, {2, 'o'});
    lb.Add(8, {0, '-'}, {3, 'o'});
    lb.Add(8, {3, '-'});
    lb.Add(8, {2, 'o'}, {3, '-'});
    lb.Add(8, {3, '-'});
    lb.Add(8, {0, 'o'}, {3, '-'});
sec_36:
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(8, {3, '-'});
    lb.Add(8, {2, 'o'}, {3, '-'});
    lb.Add(4, {3, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
sec_37:
    lb.Add(4, {0, '-'});
    lb.Add(4, {0, '-'}, {1, 'o'});
    lb.Add(4, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
sec_38:
    rep(3) lb.Add(8, {0, 'o'}, {2, '-'});
    rep(3) lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
sec_39:
    lb.Add(8, {1, 'o'});
    lb.AddTime(16);
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.AddTime(16);
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(8, {0, 'o'});
sec_40:
    rep(2) lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
sec_41:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
sec_42:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
sec_43:
    lb.Add(8, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.AddTime(16);
    lb.Add(16, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.AddTime(16);
    lb.Add(16, {1, 'o'});
    lb.Add(8, {0, 'o'});
sec_44:
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.AddTime(16);
    lb.Add(16, {2, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {0, 'o'}, {1, 'o'});
    lb.AddTime(8);
    lb.Add(8, {0, 'o'}, {1, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'}, {3, 'o'});
sec_45:
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(16, {1, 'o'}, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
sec_46:
    lb.Add(4, {0, '-'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
sec_47:
    lb.Add(4, {3, '-'});
    lb.Add(8, {3, '-'});
    lb.Add(8, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {3, 'o'});
sec_48:
    lb.Add(8, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.AddTime(16);
    lb.Add(16, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
sec_49:
    lb.Add(8, {0, 'o'}, {1, 'o'});
    lb.AddTime(16);
    lb.Add(16, {2, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
sec_50:
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
sec_51:
    lb.Add(8, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.AddTime(16);
    lb.Add(16, {1, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(8, {0, 'o'}, {1, 'o'});
sec_52:
    lb.AddTime(4);
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'}, {2, 'o'});
sec_53:
    rep(2) lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
sec_54:
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {3, 'o'});
    lb.Add(8, {0, '-'}, {3, 'o'});
    rep(2) lb.Add(8, {0, '-'}, {2, 'o'});
    rep(2) lb.Add(8, {0, '-'}, {1, 'o'});
    rep(2) lb.Add(8, {2, 'o'});
sec_55:
    rep(2) lb.Add(8, {1, 'o'}, {3, '-'});
    rep(2) lb.Add(8, {2, 'o'}, {3, '-'});
    rep(2) lb.Add(8, {1, 'o'}, {3, '-'});
    rep(2) lb.Add(8, {0, 'o'});
sec_56:
    rep(2) lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
sec_57:
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
sec_58:
    lb.Add(4, {3, '-'});
    lb.Add(8, {0, 'o'}, {1, '-'});
    lb.Add(8, {1, '-'});
    rep(2) lb.Add(4, {2, '-'}, {3, '-'});
sec_59:
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
sec_60:
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(8, {2, '-'}, {3, 'o'});
    lb.Add(8, {2, '-'});
    rep(2) lb.Add(4, {0, '-'}, {1, '-'});
sec_61:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {0, 'o'});
sec_62:
    lb.Add(4, {2, '-'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(8, {1, '-'});
    lb.Add(8, {2, '-'});
sec_63:
    lb.Add(4, {0, 'o'}, {1, 'o'});
    lb.AddTime(8);
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_64:
    rep(4) lb.Add(4, {1, 'o'}, {2, 'o'});
sec_65:
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
sec_66:
    lb.Add(4, {2, '-'});
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
sec_67:
    lb.Add(4, {2, '-'});
    lb.Add(4, {1, '-'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'});
sec_68:
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.Add(4, {0, 'o'}, {1, 'o'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, '-'}, {2, '-'});
sec_69:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.AddTime(4);
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(24, {2, 'o'});
    lb.Add(24, {1, 'o'});
    lb.Add(24, {2, 'o'});
sec_70:
    lb.Add(4, {1, '-'});
    lb.Add(8, {0, 'o'}, {1, '-'});
    lb.Add(8, {1, '-'}, {2, 'o'});
    lb.Add(8, {1, '-'});
    lb.Add(8, {0, 'o'}, {1, '-'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
sec_71:
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(8, {2, '-'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, '-'});
    lb.Add(8, {2, '-'}, {3, 'o'});
    lb.Add(8, {2, '-'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
sec_72:
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.AddTime(16);
    lb.Add(16, {1, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'});
sec_73:
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {1, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
sec_74:
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
sec_75:
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(24, {2, 'o'});
    lb.Add(24, {1, 'o'});
    lb.Add(24, {2, 'o'});
sec_76:
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});

    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});

    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
sec_77:
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(24, {2, 'o'});
    lb.Add(24, {1, 'o'});
    lb.Add(24, {2, 'o'});
    lb.Add(4, {1, 'o'});
sec_78:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(6, {0, 'o'}, {1, 'o'});
    lb.Add(6, {1, 'o'}, {2, 'o'});
    lb.Add(6, {2, 'o'}, {3, 'o'});
sec_79:
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(6, {2, 'o'}, {3, 'o'});
    lb.Add(6, {1, 'o'}, {2, 'o'});
    lb.Add(6, {0, 'o'}, {1, 'o'});
sec_80:
    lb.Add(8, {3, '-'});
    lb.AddTime(16);
    lb.Add(16, {2, 'o'}, {3, '-'});
    lb.Add(8, {3, '-'});
    lb.Add(8, {1, 'o'}, {3, '-'});
    lb.Add(8, {0, '-'});
    lb.AddTime(16);
    lb.Add(16, {0, '-'}, {2, 'o'});
    lb.Add(8, {0, '-'});
    lb.Add(8, {0, '-'}, {2, 'o'});
sec_81:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
sec_82:
    rep(2) lb.Add(4, {3, '-'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
sec_83:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_84:
    rep(4) lb.Add(4, {0, '-'}, {3, '-'});
sec_85:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_86:
    rep(4) lb.Add(4, {0, '-'}, {1, '-'});
sec_87:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_88:
    rep(4) lb.Add(4, {2, '-'}, {3, '-'});
sec_89:
    lb.Add(4, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
sec_90:
    lb.Add(4, {1, '-'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
sec_91:
    lb.Add(4, {2, '-'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(8, {0, 'o'});
sec_92:
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.Add(4, {0, 'o'}, {1, 'o'});
    lb.Add(8, {2, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'}, {1, 'o'});
    lb.AddTime(8);
    lb.Add(8, {0, 'o'}, {3, 'o'});
sec_93:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
sec_94:
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
sec_95:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
sec_96:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {3, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {1, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});
sec_97:
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});

    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
    lb.Add(16, {3, 'o'});
    lb.Add(16, {2, 'o'});

    lb.Add(16, {3, 'o'});
    lb.Add(16, {0, 'o'});
    lb.Add(16, {2, 'o'});
    lb.Add(16, {1, 'o'});
sec_98:
    lb.Add(4, {1, '-'}, {2, '-'});
}