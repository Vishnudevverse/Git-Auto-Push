@echo off
setlocal EnableDelayedExpansion
if not exist ".git" (
    echo +------------------------------------------------+
    echo ^|           Git Auto-Push Initializer            ^|
    echo +------------------------------------------------+
    echo.

    if not defined GIT_USER (
        for /f "tokens=*" %%A in ('git config --global user.name') do set "DEFAULT_USER=%%A"
        if defined DEFAULT_USER (
            set /p "GIT_USER=Enter GitHub username [!DEFAULT_USER!]: "
            if "!GIT_USER!"=="" set "GIT_USER=!DEFAULT_USER!"
        ) else (
            set /p "GIT_USER=Enter GitHub username: "
            if "!GIT_USER!"=="" (
                echo [ERROR] Username is required. Exiting.
                exit /b 1
            )
        )
    )

    if not defined REPO_NAME (
        set /p "REPO_NAME=Enter repository name: "
        if "!REPO_NAME!"=="" (
            echo [ERROR] Repository name is required. Exiting.
            exit /b 1
        )
    )
    if not defined BRANCH (
        set /p "BRANCH=Enter branch name [main]: "
        if "!BRANCH!"=="" set "BRANCH=main"
    )

    echo +------------------------------------------------------------+
    echo  Repository: https://github.com/!GIT_USER!/!REPO_NAME!
    echo  Branch    : !BRANCH!
    echo +------------------------------------------------------------+
    echo.
    echo Initializing repository...
    echo.

    git init
    git remote add origin https://github.com/!GIT_USER!/!REPO_NAME!.git 2>nul
    git fetch origin

    git ls-remote --exit-code --heads origin !BRANCH! >nul 2>^&1
    if errorlevel 1 (
        echo [INFO] No remote branch found. Creating initial commit.
        git add .
        git commit -m "Initial commit"
    ) else (
        echo [INFO] Remote branch exists. Pulling and merging...
        git checkout -b !BRANCH! origin/!BRANCH!
        git pull origin !BRANCH! --allow-unrelated-histories --no-edit
        git add .
        git commit -m "Merge local files"
    )

    git branch -M !BRANCH!
    git push -u origin !BRANCH!
    echo.
    echo [SUCCESS] Repository initialized and first push complete.
    echo.
)

:LOOP
cls
echo.
echo +---------------------------------------------------+
echo ^|  [B] Branch  [S] Status    [H] Help    [Q] Quit   ^|
echo +---------------------------------------------------+
echo.
set /p "INPUT=Type your commit message (or B/S/H/Q): "

if /i "%INPUT%"=="Q" exit /b
if /i "%INPUT%"=="S" goto STATUS
if /i "%INPUT%"=="H" goto HELP
if /i "%INPUT%"=="B" goto BRANCH
if "%INPUT%"=="" goto LOOP
goto COMMIT

:STATUS
echo.
git status
echo.
pause
goto LOOP

:HELP
echo.
echo +----------------------------------------------------------+
echo ^|                How to Use This Script                    ^|
echo +----------------------------------------------------------+
echo ^|  - Type a commit message and press Enter to add,         ^|
echo ^|    commit, and push in one go.                           ^|
echo ^|  - S = Show git status                                   ^|
echo ^|  - B = Switch/create branch                              ^|
echo ^|  - H = Display this help screen                          ^|
echo ^|  - Q = Quit script                                       ^|
echo +----------------------------------------------------------+
echo ^|               What This Script Does                      ^|
echo +----------------------------------------------------------+
echo ^|  - On first run, initializes repo ^& sets up origin.      ^|
echo ^|  - Pulls existing branch or makes initial commit.        ^|
echo ^|  - Enters a loop for status, branch, help, commits.      ^|
echo ^|  - Pushes all files in the project directory.            ^|
echo +----------------------------------------------------------+
echo ^|                   Things to Avoid                        ^|
echo +----------------------------------------------------------+
echo ^|  - Leaving the commit message blank.                     ^|
echo ^|  - Using quotes in commit messages.                      ^|
echo ^|  - Forgetting to save files before committing.           ^|
echo +----------------------------------------------------------+
echo ^|                   Setup Tips                             ^|
echo +----------------------------------------------------------+
echo ^|  - Requires Windows CMD (no admin).                      ^|
echo ^|  - Copy this .bat into your seprate folder.              ^|
echo ^|  - Add that folder to your PATH.                         ^|
echo ^|  - In VS Code, open your project                         ^|
echo ^|  - Open terminal (Ctrl+`). Run `gitautopush`.            ^|
echo +----------------------------------------------------------+
echo.
pause
goto LOOP

:BRANCH
echo.
set /p "NEW_BRANCH=Enter branch name to switch to: "
if "!NEW_BRANCH!"=="" (
    echo [ERROR] Branch name cannot be empty.
    pause
    goto LOOP
)

echo Fetching from origin…
git fetch origin

echo Switching to '!NEW_BRANCH!'…
git checkout "!NEW_BRANCH!" 2>nul || git checkout -b "!NEW_BRANCH!" origin/"!NEW_BRANCH!"

echo Pulling latest changes for '!NEW_BRANCH!'…
git pull origin "!NEW_BRANCH!" --no-edit

rem Update the internal BRANCH variable
set "BRANCH=!NEW_BRANCH!"

echo.
echo [SUCCESS] Now on branch '!BRANCH!'.
pause
goto LOOP


:COMMIT
echo.
git add .
git commit -m "%INPUT%"
git push
echo.
echo [SUCCESS] Pushed commit to branch '%BRANCH%'.
pause
goto LOOP
