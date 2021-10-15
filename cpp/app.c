#include "app.h"
#include "game.h"
#include "resource.h"

#pragma comment(lib, "winmm.lib")

#include <stdio.h>

#define API_ERROR_RETURN(desc, ...)                           \
    {                                                         \
        fprintf(stderr, "ERROR - "##desc##"\n", __VA_ARGS__); \
        return GetLastError();                                \
    }

// singleton
static App sApp;

//////// Utilities /////////

void AppGetInnerSize(LONG* pWidth, LONG* pHeight)
{
    RECT rect;
    GetClientRect(sApp.hWnd, &rect);
    *pWidth = rect.right;
    *pHeight = rect.bottom;
}

HBITMAP AppLoadBitmap(const TCHAR* filePath, BITMAP* pInfo)
{
    HBITMAP hBitmap = (HBITMAP)LoadImage(NULL, filePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE);
    if (hBitmap == NULL)
    {
        fprintf(stderr, "ERROR - %lu - Failed to load image \"%s\"\n", GetLastError(), filePath);
        return NULL;
    }
    if (pInfo != NULL)
        GetObject(hBitmap, sizeof(BITMAP), pInfo);
    return hBitmap;
}

/////////// main ////////////

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
    case WM_CLOSE:
        PostQuitMessage(0);
        break;
    case WM_PAINT:
    {
        PAINTSTRUCT ps;
        HDC hDC = BeginPaint(hWnd, &ps);
        HDC hMemDC = CreateCompatibleDC(hDC);
        RECT rect;
        GetClientRect(hWnd, &rect);
        HBITMAP hBackBuffer = CreateCompatibleBitmap(hDC, rect.right, rect.bottom);
        HBITMAP hOldBitmap = SelectObject(hMemDC, hBackBuffer);
        GameDraw(hMemDC);
        // bit transfer from back buffer to screen
        BitBlt(hDC, 0, 0, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY);
        SelectObject(hMemDC, hOldBitmap);
        DeleteObject(hBackBuffer);
        DeleteDC(hMemDC);
        EndPaint(hWnd, &ps);
        break;
    }
    case WM_KEYDOWN:
    {
        UINT8 keyCode = (UINT8)wParam;
        BOOL previousDown = ((HIWORD(lParam) & KF_REPEAT) == KF_REPEAT);
        GameKeyCallback(keyCode, TRUE, previousDown);
        break;
    }
    case WM_KEYUP:
    {
        UINT8 keyCode = (UINT8)wParam;
        GameKeyCallback(keyCode, FALSE, TRUE);
        break;
    }
    default:
        return DefWindowProc(hWnd, uMsg, wParam, lParam);
    }
    return 0;
}

void CALLBACK AppTimerProc(UINT uTimerID, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2)
{
    if (uTimerID == sApp.frameTimerID)
    {
        RECT rect;
        GetClientRect(sApp.hWnd, &rect);
        InvalidateRect(sApp.hWnd, &rect, FALSE);
    }
    else if (uTimerID == sApp.updateTimerID)
        PostMessage(NULL, WM_APP_GAME_UPDATE, 0, 0);
}

int main()
{
    // config
    int width = 960;
    int height = 540;

    int result;

    sApp.hInstance = (HINSTANCE)GetModuleHandle(NULL);
    sApp.hIcon = LoadIcon(sApp.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));

    const TCHAR * className = TEXT("AssemblyMUG");
    WNDCLASSEX wcls;
    wcls.cbSize = sizeof(WNDCLASSEX);
    wcls.style = 0;
    wcls.lpfnWndProc = WindowProc;
    wcls.cbClsExtra = 0;
    wcls.cbWndExtra = 0;
    wcls.hInstance = sApp.hInstance;
    wcls.hIcon = sApp.hIcon;
    wcls.hCursor = NULL;
    wcls.hbrBackground = NULL;
    wcls.lpszMenuName = NULL;
    wcls.lpszClassName = className;
    wcls.hIconSm = NULL;

    ATOM clsAtom = RegisterClassEx(&wcls);
    if (clsAtom == INVALID_ATOM)
        API_ERROR_RETURN("Failed to register window class");

    sApp.hWnd = CreateWindowEx(
        0, className, className, WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, (int)width, (int)height,
        NULL, NULL, sApp.hInstance, NULL);
    if (sApp.hWnd == NULL)
        API_ERROR_RETURN("Failed to create window");
    ShowWindow(sApp.hWnd, SW_SHOW);
    
    GameInit();

    UINT frameTimerID = (UINT)timeSetEvent(10, 1, AppTimerProc, 0, TIME_PERIODIC);
    UINT updateTimerID = (UINT)timeSetEvent(1, 1, AppTimerProc, 0, TIME_PERIODIC);

    MSG msg;
    while (TRUE)
    {
        while (PeekMessage(&msg, sApp.hWnd, 0, 0, PM_REMOVE))
        {
            switch (msg.message)
            {
            case WM_QUIT:
                result = msg.wParam;
                goto shutdown;
            case WM_APP_GAME_UPDATE:
                GameUpdate();
                break;
            default:
                TranslateMessage(&msg);
                DispatchMessage(&msg);
            }
        }
    }
shutdown:
    timeKillEvent(updateTimerID);
    timeKillEvent(frameTimerID);
    GameShutdown();
    DestroyWindow(sApp.hWnd);
    return result;
}
