@echo off
echo =========================================================================
echo IT214 - SESSION 04 - BAI 1: PHAN TICH CHIA SERVICE VA THIET KE DB MEDICARE
echo THUC HIEN DAY DU: GIT INIT - GIT ADD - GIT COMMIT - GIT PUSH
echo =========================================================================
echo.

set /p REPO_URL="Nhap link GitHub repository cua ban (vi du https://github.com/user/repo.git): "
if "%REPO_URL%"=="" (
    echo [LOI] Link GitHub khong duoc de trong!
    pause
    exit /b
)

echo Dang khoi tao Git va Commit...
git init
git branch -M main
git add .
git commit -m "feat: IT214 Session 04 - Bai 1: Phan tich chia module va thiet ke Database-per-Service cho he thong Medicare"
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

echo Dang push code len GitHub: %REPO_URL% ...
git push -u origin main --force

echo.
echo =========================================================================
echo DA HOAN TAT PUSH CODE LEN GITHUB!
echo =========================================================================
pause
