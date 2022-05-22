#!/bin/sh
which adb >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  if [ "$(uname)" == 'Darwin' ]; then
    cd ~/
    curl -L --output "$TMPDIR/platform-tools.zip" "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
    unzip "$TMPDIR/platform-tools.zip"
    mv "${TMPDIR}platform-tools/" "${HOME}/Applications/"
    rm -f "$TMPDIR/platform-tools.zip"
    export PATH="$PATH:`pwd`/Applications/platform-tools"
    touch ~/.zshrc && echo export PATH="$PATH:`pwd`/Applications/platform-tools" >> .zshrc
    touch ~/.bashrc && echo export PATH="$PATH:`pwd`/Applications/platform-tools" >> .bashrc
    #source ~/.zshrc
  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    sudo apt update && sudo apt install adb fastboot
    if [ $? -eq 0 ]; then
      echo "成功しました"
    else
      echo "adbのインストールに失敗しました。"
      exit 1
    fi
  else
    echo "このOSは非対応です"
    exit 1
  fi
fi
adb kill-server > /dev/null 2>&1
adb shell exit > /dev/null 2>&1
if [ $? -eq 0 ]; then
  adb shell pm list package | sed -e "s/package://g" | grep -e 'docomo' -e 'ntt' -e 'auone' -e 'rakuten' -e 'kddi' -e 'softbank' | sed "s@^@adb shell pm uninstall --user 0 @g" > test.sh
  cat test.sh | sed -e "s@adb shell pm uninstall --user 0@@g"
  echo `cat test.sh | wc -l` "個のアプリが消去されます [Y/n]: "
  read ANS
  case $ANS in
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
elif [ $? -eq 1 ]; then
  echo "USBデバッグが有効なデバイスが見つかりません。"
  echo "Android端末が正しく接続されているか確認してください"
fi
