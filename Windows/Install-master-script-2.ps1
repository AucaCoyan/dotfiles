Write-Host "`nInstalling gitmoji-rs" -ForegroundColor Yellow
cargo install gitmoji-rs
Write-Host "`nInitializing gitmoji-rs" -ForegroundColor Yellow
gitmoji init --default
Write-Host "`nInstalling bacon" -ForegroundColor Yellow
cargo install --locked bacon
Write-Host "`nInstalling cargo-update" -ForegroundColor Yellow
cargo install cargo-update
Write-Host "`nInstalling tokei" -ForegroundColor Yellow
cargo install tokei
Write-Host "`nInstalling gfold" -ForegroundColor Yellow
cargo install --locked gfold
