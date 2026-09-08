@echo off
chcp 65001 > nul
echo ========================================================
echo   PUSH GITHUB REPOSITORY - BAI TAP 1 (SESSION 04 / SS08)
echo   Repo: PTIT-HN-CNTT3-HOANGTHIENSON-IT214-SS08-01
echo ========================================================

cd /d "%~dp0"

if not exist ".git" (
    git init
    git branch -M main
)

git remote remove origin 2>nul
git remote add origin https://github.com/Boizi-06/PTIT-HN-CNTT3-HOANGTHIENSON-IT214-SS08-01.git

git add .
git commit -m "feat(session04-bai1): hoan thanh phan tich chia service va thiet ke db medicare"
git push -u origin main

pause
