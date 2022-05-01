#!/bin/bash

adb shell pm list package >> pkg.txt
cat pkg.txt | sed -e "s/package://g" | grep 'docomo' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh
cat pkg.txt | sed -e "s/package://g" | grep 'ntt' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh
cat pkg.txt | sed -e "s/package://g" | grep 'auone' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh
cat pkg.txt | sed -e "s/package://g" | grep 'rakuten' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh
cat pkg.txt | sed -e "s/package://g" | grep 'kddi' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh
cat pkg.txt | sed -e "s/package://g" | grep 'softbank' | sed "s/^/adb shell pm uninstall --user 0  /g" >> rm.sh

cat rm.sh | sed -e "s/adb shell pm uninstall --user 0//g"

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

