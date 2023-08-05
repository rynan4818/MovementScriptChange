# MovementScriptChange
[CameraPlus](https://github.com/Snow1226/CameraPlus)の[MovementScript](https://github.com/Snow1226/CameraPlus/wiki/MovementScript)(カメラスクリプト)の指定した時間のJSONを書き換えるツールです。

主に[Script Mapper](https://github.com/hibit-at/Scriptmapper)で生成したスクリプトに`CameraEffect`を後から追加したい場合などに、直接スクリプトを修正するのではなく本ツールを使って、修正内容を別ファイルに分離することを目的に作っています。

![image](https://github.com/rynan4818/MovementScriptChange/assets/14249877/ef7ea5f3-dbaf-455f-b538-e8124152ed31)

```
[{
  "time":5,
  "json":  {
  "CameraEffect":{～}
  }
}]
```
ってJSONを読み込んだ場合、5秒に当たる部分の`Movements`に`CameraEffect`を追加(変更)します。

# インストール方法
1. [Releases](https://github.com/rynan4818/MovementScriptChange/releases)から`MovementScriptChange.zip`をダウンロードして、適当なフォルダを作成して解凍します。

# 使い方
1. `movement_script_change.exe`を実行すると上の画像のツールが立ち上がります。
2. `Movement Script`には[CameraPlus](https://github.com/Snow1226/CameraPlus)の[MovementScript](https://github.com/Snow1226/CameraPlus/wiki/MovementScript)のJSONファイルを選択します。
3. `Change Script`には、下記を参考にして作ったJSONファイルを選択します。
4. `Save Script`には、変更後のMovement ScriptのJSONファイルを指定します。
5. `Change!`を押すと変換後の保存JSONファイル画面が表示されるので、指定して保存します。

# その他
- `SaveSetting`を押すと現在のScriptのパスと設定が保存され、次回起動時に自動で読み込まれます。
- `Add time to SaveScript`をチェックすると、Save ScriptのMovementsに`time`キーを追加して、そのMovementの曲時間を追加します。(例:"time": "0:00.000 - 0:02.293")

```json
[
  {
    "time": 5,       //時間が5秒に該当するMovementを変更
    "json": {        //変更・追加する内容
      "StartPos": {  //一部のみ変更する場合は、変更したキーだけ指定します。
          "FOV": 90  //この場合はFOVのみ90に変更します。
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
    "time": "30.5-40.8",  //時間は-で範囲指定可能です。左の場合は 30.5秒～40.8秒の範囲を全部変更
    "json": {
      "StartPos": {
          "z": "-2",  //数値の項目で文字列にすると演算が可能です。左の場合 z値-2 になります。※元の値+文字列でevalしています。使用可能文字→ +-/*%=:?<>().|^&0～9
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
    "time": "0-",  //-の後ろが無しの場合は最後までです
    "json": {
      "StartPos": {
          "z": "-0.1"  // 全てのMovementのStartPosのz値を-0.1します
      },
      "EndPos": {
          "z": "-0.1"  // 全てのMovementのEndPosのz値を-0.1します
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
    "time": "0-10",
    "lerps": [  // -を使った範囲指定時に、該当範囲のMovementの最初と最後の間で値を直線補完します
      {
        "start": ["StartPos"],  // Start値に使用するキー
        "end": ["EndPos"]  //End値に使用するキー
      }
    ],
    "json": {
      "StartPos": {
          "FOV": 60  // この場合0秒のStartPosのFOVが60となり
      },
      "EndPos": {
          "FOV": 100  // 10秒に該当するMovementのEndPosのFOVが100になるように間のMovementで直線補完されます
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
  },
  {
    "time": "5-15",  // 5～15秒の範囲でCameraEffectの値を直線補完する例
    "lerps": [
      {
        "start": ["CameraEffect", "StartDoF"],  // 該当のキーの階層までキーを配列で並べます
        "end": ["CameraEffect", "EndDoF"]
      },
      {
        "start": ["CameraEffect", "StartWipe"],
        "end": ["CameraEffect", "EndWipe"]
      },
      {
        "start": ["CameraEffect", "StartOutlineEffect"],
        "end": ["CameraEffect", "EndOutlineEffect"]
      }
    ],    
    "json": {
      "CameraEffect":{
          "enableDoF": false,
          "dofAutoDistance": false,
          "StartDoF": {
                 "dofFocusDistance": 1.0,  // 5～15秒に該当するMovementでdofFocusDistanceを1～5で直線補完します
                 "dofFocusRange": 1.0,
                 "dofBlurRadius": 5.0
           },
          "EndDoF": {
                 "dofFocusDistance": 5.0,
                 "dofFocusRange": 5.0,
                 "dofBlurRadius": 10.0
           },
           "wipeType": "Circle",
           "StartWipe": {
                 "wipeProgress": 0.0,
                 "wipeCircleCenter": {
                      "x": 10.0,
                      "y": 10.0
                 }
           },
           "EndWipe": {
                 "wipeProgress": 100.0,
                 "wipeCircleCenter": {
                      "x": 100.0,
                      "y": 100.0
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
                 "outlineEffectOnly": 10.0,
                 "outlineColor":{
                      "r": 10.0,
                      "g": 10.0,
                      "b": 10.0
                  },
                 "outlineBackgroundColor":{
                      "r": 20.0,
                      "g": 20.0,
                      "b": 20.0
                  }
           }
      }
    }
  }
]
```
# 補足事項
Script Mapperで生成される`Duration`は自動処理による小数点の桁数が多いため、本ツールや[ChroMapper-CameraMovement](https://github.com/rynan4818/ChroMapper-CameraMovement)で扱う時間とミリ秒レベルで誤差があります。

例えば曲時間の0:53.552 ～ 0:56.723のMovementが有った場合、境目付近(0:53.552や0:56.723)は前後のMovementとズレる可能性があります。この場合3秒ぐらいDurationがあるので54秒や55秒を指定してあげればズレることはなくなります。

# ライセンスと著作権について

MovementScriptChange はプログラム本体と各種ライブラリから構成されています。

MovementScriptChange のソースコード及び各種ドキュメントについての著作権は作者であるリュナン(Twitter [@rynan4818](https://twitter.com/rynan4818))が有します。
ライセンスは MIT ライセンスを適用します。

それ以外の movement_script_change.exe に内包しているrubyスクリプトやバイナリライブラリは、それぞれの作者に著作権があります。配布ライセンスは、それぞれ異なるため詳細は下記の入手元を確認して下さい。

# 開発環境、各種ライブラリ入手先

各ツールの入手先、開発者・製作者（敬称略）、ライセンスは以下の通りです。

movement_script_change.exe に内包している具体的なライブラリファイルの詳細は [Exerbレシピファイル](source/core_gui.exy) を参照して下さい。

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
