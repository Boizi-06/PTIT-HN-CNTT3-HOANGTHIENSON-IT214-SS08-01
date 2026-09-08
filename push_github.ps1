Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "IT214 - SESSION 04 - BAI 1: PHAN TICH CHIA SERVICE VA THIET KE DB MEDICARE" -ForegroundColor Cyan
Write-Host "THUC HIEN DAY DU: GIT INIT - GIT ADD - GIT COMMIT - GIT PUSH" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host ""

$repoUrl = Read-Host "Nhap link GitHub repository cua ban (vi du https://github.com/user/repo.git)"
if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    Write-Host "[LOI] Link GitHub khong duoc de trong!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Dang khoi tao Git va Commit..." -ForegroundColor Yellow
git init
git branch -M main
git add .
git commit -m "feat: IT214 Session 04 - Bai 1: Phan tich chia module va thiet ke Database-per-Service cho he thong Medicare"
git remote remove origin 2>$null
git remote add origin $repoUrl

Write-Host "Dang push code len GitHub: $repoUrl ..." -ForegroundColor Yellow
git push -u origin main --force

Write-Host ""
Write-Host "=========================================================================" -ForegroundColor Green
Write-Host "DA HOAN TAT PUSH CODE LEN GITHUB!" -ForegroundColor Green
Write-Host "=========================================================================" -ForegroundColor Green
pause
