import subprocess
import re
import sys

print("-----------------------------------------------------")
print("           remove-career-app for Windows")
print("  Dev:aoi_satou https://twitter.com/Chromium_Linux")
print("-----------------------------------------------------")

kill_res = subprocess.run(["adb","kill-server"],stdout=subprocess.PIPE)
shell_res = subprocess.run(["adb","kill","exit"],stdout=subprocess.PIPE)
if(kill_res.returncode != 0 or shell_res.returncode != 0):
    print("デバイスが接続されていない可能性があります")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()

subprocess.run(["adb","shell","pm","list","package",">","list.txt"],stdout=subprocess.PIPE)

career = "\"rakuten kddi auone ntt softbank docomo\""
res = subprocess.run(["findstr",career,"list.txt",">>","listout.txt"],stdout=subprocess.PIPE)
if not res.returncode == 0:
    print("例外キャリアをフィルタリングしました")

res = subprocess.run(["del","list.txt"],stdout=subprocess.PIPE)
if not res.returncode == 0:
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
    
res = subprocess.run(["for","/f","\"delims=\"","%l","in","(listout.txt)","do","@echo","adb","shell","pm","uninstall","--user","0","%l",">>","dellist.bat"],stdout=subprocess.PIPE)
if not res.returncode == 0:
    print("削除対象のアプリが見つかりません")
    res = subprocess.run(["del","listout.txt"],stdout=subprocess.PIPE)
    if not res.returncode == 0:
        print("パーミッションの設定がなんかおっかしぃぞ")
        subprocess.check_call(r"pause",shell=True)
        sys.exit()
    subprocess.run(["pause"],stdout=subprocess.PIPE)
    sys.exit()

res = subprocess.run(["del","listout.txt"],stdout=subprocess.PIPE)
if not res.returncode == 0:
    print("パーミッションの設定がなんかおっかしぃぞ")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()

subprocess.run(["cls"],stdout=subprocess.PIPE)

if __name__ == '__main__':
    before_str=r'adb shell pm uninstall --user 0*'
    after_str=r""
    f = open("dellist.bat",'r')
    body = f.read()
    print (re.sub(before_str, after_str, body, flags=re.DOTALL))
    f.close()

subprocess.run(["FIND","/v","/c"," \"\"","dellist.bat"],stdout=subprocess.PIPE)

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
        res = subprocess.run(["del","dellist.bat"],stdout=subprocess.PIPE)
        if not res.returncode == 0:
            print("パーミッションの設定がなんかおっかしぃぞ")
            subprocess.check_call(r"pause",shell=True)
            sys.exit()
        print('処理を中止しました')
        subprocess.check_call(r"pause",shell=True)
        sys.exit()

res = subprocess.run(["dellist.bat"],stdout=subprocess.PIPE)
if not res.returncode == 0:
    pass

res = subprocess.run(["del","dellist.bat"],stdout=subprocess.PIPE)
if not res.returncode == 0:
    print("パーミッションの設定がなんかおっかしぃぞ")
    subprocess.check_call(r"pause",shell=True)
    sys.exit()

print('アプリの削除が完了しました')
subprocess.check_call(r"pause",shell=True)
sys.exit()
