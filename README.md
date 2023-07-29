# MovementScriptChange
[CameraPlus](https://github.com/Snow1226/CameraPlus)の[MovementScript](https://github.com/Snow1226/CameraPlus/wiki/MovementScript)(カメラスクリプト)の指定した時間のJSONを書き換えるツールです。

![image](https://github.com/rynan4818/MovementScriptChange/assets/14249877/ef7ea5f3-dbaf-455f-b538-e8124152ed31)

```
[{
  "time":5,
  "json":  {
  "CameraEffect":{～}
  }
}]
```
ってJSONを読み込んで、5秒に当たる部分の`Movements`に`CameraEffect`を追加(変更)するツールです。

# インストール方法
1. [Releases](https://github.com/rynan4818/MovementScriptChange/releases)から`MovementScriptChange.zip`をダウンロードして、適当なフォルダを作成して解凍します。

# 使い方
1. `movement_script_change.exe`を実行すると上の画像のツールが立ち上がります。
2. `Movement Script`には[CameraPlus](https://github.com/Snow1226/CameraPlus)の[MovementScript](https://github.com/Snow1226/CameraPlus/wiki/MovementScript)のJSONファイルを選択します。
3. `Change Script`には、下記を参考にして作ったJSONファイルを選択します。
4. `Change!`を押すと変換後の保存JSONファイル画面が表示されるので、指定して保存します。

```json
[
  {
    "time": 5,       //時間が5秒に該当するMovementを変更
    "json": {        //変更・追加する内容
      "StartPos": {  //変更する場合は、中身(StartPosならx,y,z,FOV)は全て記載してください。xだけ記載すると他のy,z,FOVは削除されます
          "x": 10,
          "y": 1.75,
          "z": -2,
          "FOV": 90
      }
    }
  },
  {
    "time": "10.5,20.9",  //時間は,で複数記載可能です
    "json": {
      "StartPos": {
          "x": 20,
          "y": 1.75,
          "z": -2,
          "FOV": 90
      }
    }
  },
  {
    "time": "30.5-40.8",  //時間は-で範囲して可能です。左の場合は 30.5秒～40.8秒の範囲を全部変更
    "json": {
      "StartPos": {
          "x": 30,
          "y": 1.75,
          "z": -2,
          "FOV": 90
      }
    }
  },
  {
    "time": "50.5-60.8,70.5-80.8",  //,と-を組み合わせ可能です
    "json": {
      "StartPos": {
          "x": 40,
          "y": 1.75,
          "z": -2,
          "FOV": 90
      }
    }
  },
  {
    "time": 35,  //ChangeScriptは上から順番に処理をするため、上の30.5-40.8秒で変更した内容に対して、35秒だけこの内容に更に上書きします
    "json": {
      "StartPos": {
          "x": 50,
          "y": 1.75,
          "z": -2,
          "FOV": 50
      }
    }
  },
  {
    "time": 100,
    "json": {
      "CameraEffect":{
          "enableDoF": false,
          "dofAutoDistance": false,
          "StartDoF": {
                 "dofFocusDistance": 1.0,
                 "dofFocusRange": 1.0,
                 "dofBlurRadius": 5.0
           },
          "EndDoF": {
                 "dofFocusDistance": 1.0,
                 "dofFocusRange": 1.0,
                 "dofBlurRadius": 5.0
           },
           "wipeType": "Circle",
           "StartWipe": {
                 "wipeProgress": 0.0,
                 "wipeCircleCenter": {
                      "x": 0.0,
                      "y": 0.0
                 }
           },
           "EndWipe": {
                 "wipeProgress": 0.0,
                 "wipeCircleCenter": {
                      "x": 0.0,
                      "y": 0.0
                 }
           },
           "enableOutlineEffect": false,
           "StartOutlineEffect": {
                 "outlineEffectOnly": 0.0,
                 "outlineColor":{
                      "r": 0.0,
                      "g": 0.0,
                      "b": 0.0
                  },
                 "outlineBackgroundColor":{
                      "r": 0.0,
                      "g": 0.0,
                      "b": 0.0
                  }
           },
           "EndOutlineEffect": {
                 "outlineEffectOnly": 0.0,
                 "outlineColor":{
                      "r": 0.0,
                      "g": 0.0,
                      "b": 0.0
                  },
                 "outlineBackgroundColor":{
                      "r": 0.0,
                      "g": 0.0,
                      "b": 0.0
                  }
           }
      }
    }
  }
]
```


# ライセンスと著作権について

MovementScriptChange はプログラム本体と各種ライブラリから構成されています。

MovementScriptChange のソースコード及び各種ドキュメントについての著作権は作者であるリュナン(Twitter [@rynan4818](https://twitter.com/rynan4818))が有します。
ライセンスは MIT ライセンスを適用します。

それ以外の movement_script_change.exe に内包しているrubyスクリプトやバイナリライブラリは、それぞれの作者に著作権があります。配布ライセンスは、それぞれ異なるため詳細は下記の入手元を確認して下さい。

# 開発環境、各種ライブラリ入手先

各ツールの入手先、開発者・製作者（敬称略）、ライセンスは以下の通りです。

movement_script_change.exe に内包している具体的なライブラリファイルの詳細は [Exerbレシピファイル](source/core_cui.exy) を参照して下さい。

## Ruby本体入手先
- ActiveScriptRuby(1.8.7-p330)
- https://www.artonx.org/data/asr/
- 製作者:arton
- ライセンス：Ruby Licence

## GUIフォームビルダー入手先
- FormDesigner for Project VisualuRuby Ver 060501
- https://ja.osdn.net/projects/fdvr/
- Subversion リポジトリ r71(r65以降)の/formdesigner/trunk を使用
- 開発者:雪見酒
- ライセンス：Ruby Licence

## 使用拡張ライブラリ、ソースコード

### Ruby本体 1.8.7-p330              #開発はActiveScriptRuby(1.8.7-p330)を使用
- https://www.ruby-lang.org/ja/
- 開発者:まつもとゆきひろ
- ライセンス：Ruby Licence

### Exerb                            #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- http://exerb.osdn.jp/man/README.ja.html
- 開発者:加藤勇也
- ライセンス：LGPL

### gem                              #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- https://rubygems.org/
- ライセンス：Ruby Licence

### VisualuRuby                      #開発はActiveScriptRuby(1.8.7-p330)同封版を使用 ※swin.soを改造
- http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html
- 開発者:にゃす
- ライセンス：Ruby Licence

### json-1.4.6-x86-mswin32
- https://rubygems.org/gems/json/versions/1.4.6
- https://rubygems.org/gems/json/versions/1.4.6-x86-mswin32
- 開発者:Florian Frank
- ライセンス：Ruby Licence

### DLL

#### libiconv 1.11  (iconv.dll)       #Exerbでmovement_script_change.exeに内包
- https://www.gnu.org/software/libiconv/
- Copyright (C) 1998, 2019 Free Software Foundation, Inc.
- ライセンス：LGPL
