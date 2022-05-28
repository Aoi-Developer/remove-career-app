#!/bin/sh

set -eu

# adb install
if ! which adb >/dev/null 2>&1 ; then
  if [ "$(uname)" = 'Darwin' ]; then
    cd "${HOME}" || exit 1
    curl -L --output "$TMPDIR/platform-tools.zip" "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    unzip "$TMPDIR/platform-tools.zip"
    mv "${TMPDIR}/platform-tools/" "${HOME}/Applications/"
    rm -f "$TMPDIR/platform-tools.zip"
    export PATH="$PATH:${HOME}/Applications/platform-tools"
    touch ~/.zshrc && echo export PATH="$PATH" >> .zshrc
    touch ~/.bashrc && echo export PATH="$PATH" >> .bashrc
    #source ~/.zshrc
  elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
    sudo apt update && sudo apt install adb fastboot -y
    if [ $? -eq 0 ]; then
      echo "成功しました"
    else
      echo "adbのインストールに失敗しました。" >&2
      exit 1
    fi
  else
    echo "このOSは非対応です" >&2
    exit 1
  fi
fi
adb kill-server > /dev/null 2>&1

if adb shell exit > /dev/null 2>&1; then
  adb shell pm list package | sed -e "s/package://g" | grep -e 'docomo' -e 'ntt' -e 'auone' -e 'rakuten' -e 'kddi' -e 'softbank' | sed "s@^@adb shell pm uninstall --user 0 @g" > test.sh
  sed -e "s@adb shell pm uninstall --user 0@@g" test.sh
  echo "$(wc -l < test.sh)個のアプリが消去されます [Y/n]: "
  read -r ANS
  case "${ANS}" in
    "" | [Yy]* )
      bash test.sh
      rm test.sh
      echo "アプリの消去を実行しました"
      ;;
    * )
      rm test.sh
      echo "処理を中止しました。"
      ;;
    esac
else
  echo "USBデバッグが有効なデバイスが見つかりません。" >&2
  echo "Android端末が正しく接続されているか確認してください" >&2
fi
