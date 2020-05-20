# 機能

* 出退勤時のポップアップ表示
* 出退勤時の打刻支援

# 動作環境

* macOS Catalina 10.15.x
* Google Chrome
  - 打刻の自動化を行う場合のみ

# ダウンロード

[ここ](https://github.com/shota-dai/AditAlerm/releases/latest)からdmgファイルをダウンロードする。

# インストール方法

0. 打刻の自動化設定（後述）を行う。【非必須】
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
※打刻の自動化＝「打刻する」をクリックすると自動的に打刻
1. [pip](https://pypi.org/project/pip/)をインストールする。
2. [selenium](https://selenium-python.readthedocs.io/)をインストールする。
3. インストールされているGoogle Chromeのバージョンと一致するChromeDriverを[ここ](https://chromedriver.chromium.org/downloads)からダウンロードする。
4. ダウンロードした`chromedriver`を`/usr/local/bin/`に置く。
5. `sudo xattr -d com.apple.quarantine /usr/local/bin/chromedriver`を実行する。
