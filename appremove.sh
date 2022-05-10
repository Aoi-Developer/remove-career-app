#!/bin/bash


md5sum adb 2>&1 | awk '{ print $1 }' > md5.txt

if [ `cat md5.txt` = "00b1df50915b913ce4e44f53bce50e37" ]; then
    rm md5.txt
    ./adb kill-server > /dev/null 2>&1
    ./adb shell exit > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      adb shell pm list package >> pkg.txt
      cat pkg.txt | sed -e "s/package://g" | grep 'docomo' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'ntt' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'auone' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'rakuten' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'kddi' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'softbank' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat rm.sh | sed -e "s@./adb shell pm uninstall --user 0@@g"
      echo -n "以上のアプリが消去されます [Y/n]: "
      read ANS
      case $ANS in
        "" | [Yy]* )
          sh rm.sh
          rm rm.sh pkg.txt
          echo "アプリの消去を実行しました"
          ;;
        * )
          rm rm.sh pkg.txt
          echo "処理を中止しました。"
          ;;
      esac
    elif [ $? -eq 1 ]; then
      echo "USBデバッグが有効なデバイスが見つかりません。"
      echo "Android端末が正しく接続されているか確認してください"
    fi
else
    rm md5.txt
    echo "以前ダウンロードされたファイルのハッシュ値が一致しない または必要なファイルが存在しません"
    echo "最新のadbコマンドをダウンロードしています。しばらくお待ちください"
    curl -O https://raw.githubusercontent.com/Aoi-Developer/remove-career-app/main/adb
    chmod 764 adb
    ./adb kill-server > /dev/null 2>&1
    ./adb shell exit > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      adb shell pm list package >> pkg.txt
      cat pkg.txt | sed -e "s/package://g" | grep 'docomo' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'ntt' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'auone' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'rakuten' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'kddi' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat pkg.txt | sed -e "s/package://g" | grep 'softbank' | sed "s@^@./adb shell pm uninstall --user 0 @g" >> rm.sh
      cat rm.sh | sed -e "s@./adb shell pm uninstall --user 0@@g"
      echo -n "以上のアプリが消去されます [Y/n]: "
      read ANS
      case $ANS in
        "" | [Yy]* )
          sh rm.sh
          rm rm.sh pkg.txt
          echo "アプリの消去を実行しました"
          ;;
        * )
          rm rm.sh pkg.txt
          echo "処理を中止しました。"
          ;;
      esac
    elif [ $? -eq 1 ]; then
      echo "USBデバッグが有効なデバイスが見つかりません。"
      echo "Android端末が正しく接続されているか確認してください"
    fi
 fi

