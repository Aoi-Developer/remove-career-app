#!/bin/sh
adb >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  if [ "$(uname)" == 'Darwin' ]; then
    cd ~/
    curl -OL https://dl.google.com/android/repository/platform-tools_r33.0.1-darwin.zip
    unzip platform-tools_r33.0.1-darwin.zip
    mv platform-tools/ ~/Applications/
    rm platform-tools_r33.0.1-darwin.zip
    export PATH="$PATH:`pwd`/Applications/platform-tools"
    touch ~/.zshrc && echo export PATH="$PATH:`pwd`/Applications/platform-tools" >> .zshrc
    touch ~/.bashrc && echo export PATH="$PATH:`pwd`/Applications/platform-tools" >> .bashrc
    source ~/.zshrc
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
  appremovelist=`adb shell pm list package | sed -e "s/package://g" | grep -e 'docomo' -e 'ntt' -e 'auone' -e 'rakuten' -e 'kddi' -e 'softbank' | sed "s@^@adb shell pm uninstall --user 0 @g"`
  echo $appremovelist | sed -e "s@adb shell pm uninstall --user 0@@g"
  echo -n "以上のアプリが消去されます [Y/n]: "
  read ANS
  case $ANS in
    "" | [Yy]* )
      $appremovelist
      echo "アプリの消去を実行しました"
      ;;
    * )
      echo "処理を中止しました。"
      ;;
    esac
elif [ $? -eq 1 ]; then
  echo "USBデバッグが有効なデバイスが見つかりません。"
  echo "Android端末が正しく接続されているか確認してください"
fi
