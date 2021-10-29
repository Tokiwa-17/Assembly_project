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
sec_26:
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {1, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {2, 'o'});
sec_27:
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'});
sec_28:
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, '-'}, {2, '-'});
sec_29:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'});
sec_30:
    lb.Add(4, {2, 'o'});
    lb.Add(4, {0, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {2, 'o'});
sec_31:
    lb.Add(4, {1, 'o'});
    lb.Add(4, {3, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_32:
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {1, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_33:
    lb.Add(4, {0, '-'}, {3, '-'});
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {0, 'o'});
sec_34:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {0, 'o'});
    lb.Add(4, {0, 'o'}, {2, 'o'});
    lb.AddTime(4); // ��ֹ
sec_35:
    lb.Add(4, {1, '-'}, {3, '-'});
    lb.Add(4, {2, '-'}, {3, '-'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    rep(3) lb.Add(8, {3, 'o'});
sec_36:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    rep(2) lb.Add(8, {3, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
    lb.AddTime(4); // ��ֹ
sec_37:
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {1, 'o'});
sec_38:
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {0, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {3, 'o'});
sec_39:
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_40:
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
sec_41:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {2, '-'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {1, 'o'});
sec_42:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
    lb.AddTime(4);
sec_43:
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(8, {0, 'o'}, {2, 'o'});
    rep(3) lb.Add(8, {2, 'o'});
sec_44:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.AddTime(4);
sec_45:
    lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {0, '-'}, {3, '-'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {1, 'o'});
sec_46:
    lb.Add(8, {0, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {1, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {2, 'o'});
sec_47:
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {2, 'o'});
    lb.Add(8, {1, 'o'}, {3, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {0, 'o'});
sec_48:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_49:
    rep(2) lb.Add(4, {2, '-'});
    lb.Add(4, {0, 'o'}, {1, '-'});
    lb.Add(4, {1, '-'});
sec_50:
    rep(2) lb.Add(4, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {2, '-'});
sec_51:
    rep(2) lb.Add(4, {3, '-'});
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(4, {2, '-'});
sec_52:
    rep(2) lb.Add(4, {1, '-'});
    lb.Add (4, {1, 'o'}, {2, '-'});
    lb.Add (4, {2, '-'});
sec_53:
    rep(2) lb.Add(4, {1, '-'});
    lb.Add(4, {2, '-'}, {3, 'o'});
    lb.Add(4, {2, '-'});
sec_54:
    rep(2) lb.Add(4, {2, '-'});
    lb.Add(4, {2, 'o'}, {1, '-'});
    lb.Add(4, {1, '-'});
sec_55:
    lb.Add(4, {0, '-'}, {1, 'o'});
    lb.Add(4, {0, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'});
sec_56:
    lb.Add(4, {2, '-'}, {3, 'o'});
    lb.Add(4, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'});
sec_57:
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {3, '-'});
sec_58:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_59:
    lb.Add(4, {0, '-'});
    lb.Add(4, {0, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'}, {3, 'o'});
    lb.Add(4, {1, '-'}, {2, 'o'});
sec_60:
    rep(4) lb.Add(4, {0, '-'}, {2, '-'});
sec_61:
    lb.Add(4, {3, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
sec_62:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_63:
    lb.Add(4, {0, '-'});
    lb.Add(4, {0, '-'}, {3, 'o'});
    lb.Add(4, {0, '-'}, {2, 'o'});
    lb.Add(4, {0, '-'}, {3, 'o'});
sec_64:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_65:
    lb.Add(4, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'});
    lb.AddTime(4);
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
sec_66:
    lb.Add(4, {0, 'o'}, {2, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'});
    lb.AddTime(4);
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
sec_67:
    lb.Add(4, {1, 'o'}, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.AddTime(4);
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
sec_68:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_69:
    lb.Add(4, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
sec_70:
    lb.Add(4, {0, '-'});
    lb.Add(4, {2, 'o'}, {0, '-'});
    lb.Add(4, {3, 'o'}, {0, '-'});
    lb.Add(4, {2, 'o'}, {0, '-'});
sec_71:
    lb.Add(4, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(4, {0, '-'});
    lb.Add(4, {0, '-'}, {1, 'o'});
sec_72:
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {2, 'o'});  
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_73:
    lb.Add(4, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
sec_74:
    lb.Add(4, {0, '-'});
    lb.Add(4, {1, 'o'}, {0, '-'});
    lb.Add(4, {2, 'o'}, {0, '-'});
    lb.Add(4, {3, 'o'}, {0, '-'});
sec_75:
    lb.Add(4, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {0, 'o'}, {3, '-'});
sec_76:
    lb.Add(4, {0, '-'});
    rep(3) lb.Add(4, {0, '-'}, {1, '-'});
sec_77:
    lb.AddTime(8);
    lb.Add(8, {0, 'o'});
    lb.AddTime(8);
    lb.Add(8, {0, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'});
    lb.AddTime(8);
    lb.Add(8, {1, 'o'});
sec_78:
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.AddTime(8);
    lb.Add(8, {2, 'o'});
    lb.AddTime(8);
    lb.Add(8, {3, 'o'});
    lb.AddTime(8);
    lb.Add(8, {3, 'o'});
sec_79:
    lb.Add(8, {3, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {0, 'o'});
sec_80:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.AddTime(4);
sec_81:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
sec_82:
    lb.Add(4, {2, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
sec_83:
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {1, '-'}, {3, '-'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
sec_84:
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {2, 'o'});
sec_85:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
    lb.Add(4, {2, 'o'});    
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_86:
    lb.Add(4, {1, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_87:
    lb.Add(4, {1, '-'}, {3, 'o'});
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
sec_88:
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, 'o'});
sec_89: 
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_90:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'}, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {3, 'o'});
sec_91:
    lb.Add(4, {1, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
sec_92:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {1, 'o'}, {2, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {1, 'o'});
sec_93:
    rep(2) lb.Add(4, {2, '-'});
    lb.Add(4, {1,'-'}, {2, '-'});
    lb.Add(4, {1,'-'});
sec_94:
    rep(2) lb.Add(4, {2, '-'});
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
sec_95:
    rep(2) lb.Add(4, {1, '-'});
    rep(2) lb.Add(4, {2, '-'});
sec_96:
    lb.Add(4, {2, '-'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {1, '-'});
sec_97:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_98:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_99:
    lb.Add(4, {0, 'o'}, {3, '-'});
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {0, '-'}, {3, 'o'});
    lb.Add(4, {0, '-'}, {2, 'o'});
sec_100:
    lb.Add(4, {1, 'o'}, {2, '-'});
    lb.Add(4, {0, 'o'}, {2, '-'});
    lb.Add(4, {1, '-'}, {2, 'o'});
    lb.Add(4, {1, '-'}, {3, 'o'});
sec_101:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
sec_102:
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
sec_103:
    lb.Add(4, {0, '-'}, {2, 'o'});
    lb.Add(4, {0, '-'}, {1, 'o'});
    lb.Add(4, {0, '-'}, {1, 'o'});
    lb.Add(4, {1, 'o'});
sec_104:
    lb.Add(4, {1, 'o'}, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(4, {2, 'o'}, {3, '-'});
    lb.Add(4, {2, 'o'});
sec_105:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(4, {2, 'o'}, {3, 'o'});
sec_106:
    lb.Add(4, {1, '-'}, {3, 'o'});
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
sec_107:
    lb.Add(4, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(4, {0, 'o'}, {1, 'o'});
sec_108:
    lb.Add(4, {0, 'o'}, {2, '-'});
    rep(2) lb.Add(4, {1, '-'}, {2, '-'});
    lb.Add(4, {2, '-'});
sec_109:
    lb.Add(4, {0, 'o'});
    lb.Add(4, {0, 'o'}, {1, 'o'});
    lb.Add(8, {2, 'o'});
    lb.Add(8, {0, 'o'});
    lb.Add(4, {1, 'o'}, {3, 'o'});
sec_110:
    lb.Add(4, {1, 'o'}, {3, 'o'});
    lb.Add(4, {2, 'o'}, {3, 'o'});
    lb.Add(8, {1, 'o'});
    lb.Add(8, {3, 'o'});
    lb.Add(4, {0, 'o'}, {2, 'o'});
sec_111:
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
    lb.Add(4, {0, 'o'}, {3, 'o'});
    lb.Add(4, {1, 'o'}, {2, 'o'});
sec_112:
    lb.Add(4, {1, '-'}, {2, 'o'});
    rep(3) lb.Add(4, {1, '-'}, {2, '-'});
sec_113:
    rep(4) lb.Add(4, {1, '-'}, {2, '-'});
sec_114:
    rep(4) lb.Add(4, {0, '-'}, {3, '-'});
}
