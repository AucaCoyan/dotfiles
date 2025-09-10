Write-Host "`nInstalling cargo-binstall" -ForegroundColor Yellow
iex (
    iwr "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.ps1"
    ).Content

Write-Host "`nInstalling cargo-nextest" -ForegroundColor Yellow
cargo binstall cargo-nextest --secure

# $tmp = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } -PassThru
# Invoke-WebRequest -OutFile $tmp https://get.nexte.st/latest/windows
# $outputDir = if ($Env:CARGO_HOME) { Join-Path $Env:CARGO_HOME "bin" } else { "~/.cargo/bin" }
# $tmp | Expand-Archive -DestinationPath $outputDir -Force
# $tmp | Remove-Item

Write-Host "`nInstalling gitmoji-rs" -ForegroundColor Yellow
cargo binstall gitmoji-rs
Write-Host "`nInitializing gitmoji-rs" -ForegroundColor Yellow
gitmoji init --default
Write-Host "`nInstalling bacon" -ForegroundColor Yellow
cargo binstall --locked bacon
Write-Host "`nInstalling cargo-update" -ForegroundColor Yellow
cargo binstall cargo-update
Write-Host "`nInstalling tokei" -ForegroundColor Yellow
cargo binstall tokei
Write-Host "`nInstalling gfold" -ForegroundColor Yellow
cargo binstall --locked gfold

# authenticate to github
gh auth login
