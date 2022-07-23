Set-Variable -Name ErrorActionPreference -Value SilentlyContinue
adb start-server | Out-Null
If ( $? -Eq $false) {
    Set-Variable -Name ProgressPreference -Value SilentlyContinue
    Invoke-WebRequest -Uri https://dl.google.com/android/repository/platform-tools-latest-windows.zip -OutFile platform-tools.zip -UseBasicParsing
    New-Item -Path ADB -Type Directory -Force|Out-Null
    Expand-Archive -Path .\platform-tools.zip -Force
    Remove-Item -Recurse .\platform-tools*
    Move-Item -Path .\platform-tools\platform-tools\adb* .\ADB\ -Force
    Set-Item Env:Path "$Env:Path;$(Convert-Path .\ADB\);" -Force
    adb start-server
}
adb shell exit | Clear-Host

If ( $? -Eq $false ) {
    Write-Host "USBデバッグが有効なデバイスが見つかりません。`nAndroid端末が正しく接続されているか確認してください"
    adb kill-server
    Start-Sleep 3
    Exit 1
}

adb shell pm list packages | Select-String -Pattern docomo,ntt,auone,rakuten,kddi,softbank | ForEach-Object { $_ -replace 'package:','' } | ForEach-Object { 'adb shell pm uninstall --user 0 ' + $_ }>run.ps1
Get-Content .\run.ps1 | ForEach-Object { $_ -replace 'adb shell pm uninstall --user 0 ','' }
If ( $(Get-Content .\run.ps1).Length -Eq 0 ) {
    Remove-Item -Recurse .\run.ps1
    Write-Host "キャリアアプリが見つかりませんでした"
}
ElseIf ( $(Read-Host $(Get-Content .\run.ps1).Length"個のアプリが削除されます [Y/n]") -Like "[y,ｙ]" ) {
    .\run.ps1
    Write-Host "アプリの削除を実行しました"
} else {
    Write-Host "処理を中止しました"
}
Remove-Item -Recurse .\run.ps1
adb kill-server
Start-Sleep 3
Exit