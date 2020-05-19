# 機能

* 出退勤時のポップアップ表示
* 出退勤時の打刻支援

# 動作環境

* macOS Catalina 10.15.x
* Google Chrome 81.0.4044.138

# ダウンロード

[ここ](https://github.com/shota-dai/AditAlerm/releases/latest)からdmgファイルをダウンロードする。

# インストール方法

0. 打刻の自動化設定を行う。（非必須）
1. dmgファイルをダブルクリックする。
2. デスクトップ上の`AditAlerm_v1.0`をダブルクリックする。
3. `AditAlerm.app`をアプリケーションフォルダにドラッグアンドドロップする。
4. `AditAlerm_v1.0`ディスクを取り出した後、dmgファイルを削除する。
5. `AditAlerm.app`をダブルクリックする。
6. ![表示されたダイアログの`OK`ボタンをクリックする。](https://github.com/shota-dai/AditAlerm/blob/master/images/AditAlerm_UnopenableDialog.png)
7. ![システム環境設定の「セキュリティとプライバシー」の「一般」タブの`このまま開く`ボタンをクリックする。](https://github.com/shota-dai/AditAlerm/blob/master/images/AditAlerm_SystemSetting.png)
8. ![表示されたダイアログの`開く`ボタンをクリックする。](https://github.com/shota-dai/AditAlerm/blob/master/images/AditAlerm_ConfirmOpenDialog.png)
9. ![表示された通知の`許可`ボタンをクリックする。](https://github.com/shota-dai/AditAlerm/blob/master/images/AditAlerm_Notification.png)

# 打刻の自動化設定

1. [pip](https://pypi.org/project/pip/)をインストールする。
2. [selenium](https://selenium-python.readthedocs.io/)をインストールする。
3. [ChromeDriver](https://chromedriver.chromium.org/)を[ここ](https://chromedriver.storage.googleapis.com/index.html?path=81.0.4044.138/)からダウンロードする。
4. ダウンロードした`chromedriver`を`/usr/local/bin/`に置く。
5. chromedriverに権限を与える。
