#include <Windows.h>
#include <tchar.h>

#include <memory.h>
#include <stdio.h>
#include <math.h>

#pragma comment(lib, "user32.lib")
#pragma comment(lib, "gdi32.lib")

static struct
{
    HWND handle;
    int width;
    int height;
} window;

static struct
{
    LARGE_INTEGER frequency;
    LARGE_INTEGER initialCount;
    LARGE_INTEGER frameDeltaCount;
    LARGE_INTEGER frameLastCount;
} timer;

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

int WindowInitialize(int width, int height)
{
    memset(&window, 0, sizeof(window));

    HINSTANCE hInstance = GetModuleHandle(NULL);
    HICON hIcon = LoadIcon(NULL, IDI_APPLICATION);
    const TCHAR *className = TEXT("MUGWindow");
    const TCHAR *wndName = TEXT("MUG");

    WNDCLASSEX wc;
    wc.cbSize = sizeof(wc);
    wc.style = 0;
    wc.lpfnWndProc = WindowProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = hIcon;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = NULL;
    wc.lpszMenuName = NULL;
    wc.lpszClassName = className;
    wc.hIconSm = hIcon;

    if (RegisterClassEx(&wc) == INVALID_ATOM)
    {
        fprintf(stderr, "ERROR - Failed to register window class: error code is %lu\n", GetLastError());
        return -1;
    }

    window.handle = CreateWindowEx(
        0, className, wndName, WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, width, height,
        NULL, NULL, hInstance, NULL);
    
    if (window.handle == NULL)
    {
        fprintf(stderr, "ERROR - Failed to create window: error code is %lu\n", GetLastError());
        return -2;
    }
    window.width = width;
    window.height = height;

    ShowWindow(window.handle, SW_SHOW);
    UpdateWindow(window.handle);
    return 0;
}

void TimerInitialize(float fps)
{
    QueryPerformanceFrequency(&timer.frequency);
    timer.frameDeltaCount.QuadPart = (LONGLONG)((float)timer.frequency.QuadPart / fps);
    QueryPerformanceCounter(&timer.initialCount);
    timer.frameLastCount = timer.initialCount;
}

BOOL TimerNextFrame()
{
    LARGE_INTEGER currentCount;
    QueryPerformanceCounter(&currentCount);
    if (currentCount.QuadPart - timer.frameLastCount.QuadPart >= timer.frameDeltaCount.QuadPart)
    {
        timer.frameLastCount.QuadPart += timer.frameDeltaCount.QuadPart;
        return TRUE;
    }
    return FALSE;
}

// time since main loop begin; in seconds
float TimerElapsedTime()
{
    LARGE_INTEGER currentCount;
    QueryPerformanceCounter(&currentCount);
    return (float)(currentCount.QuadPart - timer.initialCount.QuadPart) / (float)timer.frequency.QuadPart;
}

int GameInitialize();

void GameFinalize();

int GameRender();

int GameUpdate();

int main()
{
    int retcode = WindowInitialize(960, 540);
    if (retcode != 0)
        return retcode;

    retcode = GameInitialize();
    if (retcode != 0)
    {
        DestroyWindow(window.handle);
        return retcode;
    }

    TimerInitialize(60.0f);
    while (TRUE)
    {
        // rendering with fixed frame rate
        if (TimerNextFrame())
        {
            retcode = GameRender();
            if (retcode != 0)
                goto finalize; // asm 'jmp'
        }

        MSG msg;
        while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            if (msg.message == WM_QUIT)
            {
                retcode = (int)msg.wParam;
                goto finalize; // asm 'jmp'
            }
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
        retcode = GameUpdate();
        if (retcode != 0)
            goto finalize; // asm 'jmp'
    }

finalize:
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

int GameInitialize()
{
    memset(&game, 0, sizeof(game));
    // TODO
    return 0;
}

void GameFinalize()
{
    // TODO
}

int GameRender()
{
    HDC hDC = GetDC(window.handle);
    RECT rgn;
    rgn.left = 0;
    rgn.top = 0;
    rgn.right = window.width;
    rgn.bottom = window.height;

    // render example
    unsigned gray = (unsigned)(127.5f * (1.0f + sin(TimerElapsedTime() * 2.5f)));
    HBRUSH hClearColor = CreateSolidBrush(RGB(gray, gray, gray));
    FillRect(hDC, &rgn, hClearColor);
    DeleteObject(hClearColor);

    // TODO: coordinate transform
    // TODO: draw
    ReleaseDC(window.handle, hDC);
    return 0;
}

int GameUpdate()
{
    // TODO: update game state
    return 0;
}