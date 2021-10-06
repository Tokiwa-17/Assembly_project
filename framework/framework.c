#include <Windows.h>
#include <tchar.h>

#include <memory.h>
#include <stdio.h>
#include <math.h>
#include <stdint.h>

#pragma comment(lib, "user32.lib")
#pragma comment(lib, "gdi32.lib")

static struct
{
    HINSTANCE process;
    HWND handle;
    int width;
    int height;
} window;

static struct
{
    LARGE_INTEGER frequency;
    uint32_t fps;
    uint32_t frameDelta;
    LARGE_INTEGER frameLast;
} timer;

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

void WindowInitialize()
{
    window.process = GetModuleHandle(NULL);
    HICON hIcon = LoadIcon(NULL, IDI_APPLICATION);
    const TCHAR *className = TEXT("MUGWindow");
    const TCHAR *wndName = TEXT("MUG");

    WNDCLASSEX wc;
    wc.cbSize = sizeof(wc);
    wc.style = 0;
    wc.lpfnWndProc = WindowProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = window.process;
    wc.hIcon = hIcon;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = NULL;
    wc.lpszMenuName = NULL;
    wc.lpszClassName = className;
    wc.hIconSm = hIcon;

    RegisterClassEx(&wc);

    window.handle = CreateWindowEx(
        0, className, wndName, WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, window.width, window.height,
        NULL, NULL, window.process, NULL);
    
    if (window.handle == NULL)
        ExitProcess(GetLastError());

    ShowWindow(window.handle, SW_SHOW);
    UpdateWindow(window.handle);
}

void WindowFinalize()
{
    DestroyWindow(window.handle);
}

void TimerInitialize()
{
    QueryPerformanceFrequency(&timer.frequency);
    timer.frameDelta = (uint32_t)(timer.frequency.QuadPart / (LONGLONG)timer.fps);
    QueryPerformanceCounter(&timer.frameLast);
}

BOOL TimerNextFrame()
{
    LARGE_INTEGER currentCount;
    QueryPerformanceCounter(&currentCount);
    if (currentCount.QuadPart - timer.frameLast.QuadPart >= (LONGLONG)timer.frameDelta)
    {
        timer.frameLast.QuadPart += (LONGLONG)timer.frameDelta;
        return TRUE;
    }
    return FALSE;
}

void GameInitialize();

void GameFinalize();

void GameRender(HDC hDC);

void GameUpdate();

int main()
{
    memset(&window, 0, sizeof(window));
    memset(&timer, 0, sizeof(timer));
    window.width = 960;
    window.height = 540;
    timer.fps = 60;

    int retcode = 0;
    WindowInitialize();
    GameInitialize();
    TimerInitialize();
    while (TRUE)
    {
        // rendering with fixed frame rate
        if (TimerNextFrame())
        {
            HDC hDC = GetDC(window.handle);
            GameRender(hDC);
            ReleaseDC(window.handle, hDC);
        }

        MSG msg;
        while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            if (msg.message == WM_QUIT)
            {
                retcode = (int)msg.wParam;
                goto main_exit; // asm 'jmp'
            }
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
        GameUpdate();
    }
main_exit:
    GameFinalize();
    DestroyWindow(window.handle);
    return retcode;
}

// --------- implementation -----------

static struct
{
    void *todo;
} game;

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
    case WM_CLOSE:
        PostQuitMessage(0);
        break;
    case WM_SIZE:
        window.width = (int)LOWORD(lParam);
        window.height = (int)HIWORD(lParam);
        break;
        
    // TODO: Update key states
    case WM_KEYDOWN:
        break;
    case WM_SYSKEYDOWN:
        break;
    case WM_KEYUP:
        break;
    case WM_SYSKEYUP:
        break;
    default:
        return DefWindowProc(hWnd, uMsg, wParam, lParam);
    }
    return 0;
}

void GameInitialize()
{
    memset(&game, 0, sizeof(game));
    // TODO
}

void GameFinalize()
{
    // TODO
}

void GameRender(HDC hDC)
{
    // TODO
}

void GameUpdate()
{
    // TODO: update game state
}