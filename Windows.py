import subprocess
import re
import sys

print("-----------------------------------------------------")
print("           remove-career-app for Windows")
print("  Dev:aoi_satou https://twitter.com/Chromium_Linux")
print("-----------------------------------------------------")

try:
    subprocess.check_call("adb kill-server")
    subprocess.check_call("adb shell exit")
except:
    print("デバイスが接続されていない可能性があります")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()

subprocess.check_call(r"adb shell pm list package > list.txt ",shell=True)
try:
    subprocess.check_call(r'findstr "rakuten kddi auone ntt softbank docomo" list.txt >> listout.txt ',shell=True)
except:
    print("例外キャリアをフィルタリングしました")
try:
    subprocess.check_call(r"del list.txt",shell=True)
except:
    print("削除対象のアプリがありません")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()

if __name__ == '__main__':
    before_str=r'package:*'
    after_str=r""

    f = open("listout.txt",'r')
    body = f.read()
    f.close()
    f = open("listout.txt",'w')
    print (re.sub(before_str, after_str, body, flags=re.DOTALL))
    f.write (re.sub(before_str, after_str, body, flags=re.DOTALL))
    f.close()
try:
    subprocess.check_call (r'for /f "delims=" %l in (listout.txt) do @echo adb shell pm uninstall --user 0  %l >> dellist.bat ',shell=True)
except:
    print("文字列の置換に失敗しました")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()
try:
    subprocess.check_call(r"del listout.txt",shell=True)
except:
    print("パーミッションの設定がなんかおっかしぃぞ")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()
subprocess.check_call(r"cls",shell=True)

if __name__ == '__main__':
    before_str=r'adb shell pm uninstall --user 0*'
    after_str=r""

    f = open("dellist.bat",'r')
    body = f.read()
    print (re.sub(before_str, after_str, body, flags=re.DOTALL))
    f.close()

subprocess.check_call(r'FIND /v /c "" dellist.bat',shell=True)

def confirm():
    dic={'y':True,'yes':True,'n':False,'no':False}
    while True:
        try:
            return dic[input('以上のアプリが消去されます [y/N]:').lower()]
        except:
            pass
        print('Error! Input again.')

if __name__ == '__main__':
    if confirm():
        print('削除を実行します')
    else:
        subprocess.check_call(r"del dellist.bat",shell=True)
        print('処理を中止しました')
        subprocess.check_call(r"pause",shell=True)
        sys.exit()

try:
    subprocess.check_call(r"dellist.bat",shell=True)
except:
    print("")
subprocess.check_call(r"del dellist.bat",shell=True)
print('アプリの削除が完了しました')
subprocess.check_call(r"pause",shell=True)