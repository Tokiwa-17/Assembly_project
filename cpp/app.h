#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>

#define WM_APP_GAME_UPDATE WM_APP
// TODO other application messages

    typedef struct App
    {
        HINSTANCE hInstance;
        HICON hIcon;
        HWND hWnd;
        UINT frameTimerID;
        UINT updateTimerID;
    } App;

    //////// Utilities /////////

    void AppGetInnerSize(LONG* pWidth, LONG* pHeight);

    HBITMAP AppLoadBitmap(const TCHAR* filePath, BITMAP* pInfo);

#ifdef __cplusplus
}
#endif
