# MovementScriptChange

�����ChangeScript JSON�t�@�C�������܂��B

```json
[
  {
    "time": 5,       //���Ԃ�5�b�ɊY������Movement��ύX
    "json": {        //�ύX�E�ǉ�������e
      "StartPos": {  //�ύX����ꍇ�́A���g(StartPos�Ȃ�x,y,z,FOV)�͑S�ċL�ڂ��Ă��������Bx�����L�ڂ���Ƒ���y,z,FOV�͍폜����܂�
          "x": 10,
          "y": 1.75,
          "z": -2,
          "FOV": 90
      }
    }
  },
  {
    "time": "10.5,20.9",  //���Ԃ�,�ŕ����L�ډ\�ł�
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
    "time": "30.5-40.8",  //���Ԃ�-�Ŕ͈͂��ĉ\�ł��B���̏ꍇ�� 30.5�b�`40.8�b�͈̔͂�S���ύX
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
    "time": "50.5-60.8,70.5-80.8",  //,��-��g�ݍ��킹�\�ł�
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
    "time": 35,  //ChangeScript�͏ォ�珇�Ԃɏ��������邽�߁A���30.5-40.8�b�ŕύX�������e�ɑ΂��āA35�b�������̓��e�ɍX�ɏ㏑�����܂�
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


# ���C�Z���X�ƒ��쌠�ɂ���

MovementScriptChange �̓v���O�����{�̂Ɗe�탉�C�u��������\������Ă��܂��B

MovementScriptChange �̃\�[�X�R�[�h�y�ъe��h�L�������g�ɂ��Ă̒��쌠�͍�҂ł��郊���i��(Twitter [@rynan4818](https://twitter.com/rynan4818))���L���܂��B
���C�Z���X�� MIT ���C�Z���X��K�p���܂��B

����ȊO�� movement_script_change.exe �ɓ���Ă���ruby�X�N���v�g��o�C�i�����C�u�����́A���ꂼ��̍�҂ɒ��쌠������܂��B�z�z���C�Z���X�́A���ꂼ��قȂ邽�ߏڍׂ͉��L�̓��茳���m�F���ĉ������B

# �J�����A�e�탉�C�u���������

�e�c�[���̓����A�J���ҁE����ҁi�h�̗��j�A���C�Z���X�͈ȉ��̒ʂ�ł��B

movement_script_change.exe �ɓ���Ă����̓I�ȃ��C�u�����t�@�C���̏ڍׂ� [Exerb���V�s�t�@�C��](source/core_cui.exy) ���Q�Ƃ��ĉ������B

## Ruby�{�̓����
- ActiveScriptRuby(1.8.7-p330)
- https://www.artonx.org/data/asr/
- �����:arton
- ���C�Z���X�FRuby Licence

## GUI�t�H�[���r���_�[�����
- FormDesigner for Project VisualuRuby Ver 060501
- https://ja.osdn.net/projects/fdvr/
- Subversion ���|�W�g�� r71(r65�ȍ~)��/formdesigner/trunk ���g�p
- �J����:�ጩ��
- ���C�Z���X�FRuby Licence

## �g�p�g�����C�u�����A�\�[�X�R�[�h

### Ruby�{�� 1.8.7-p330              #�J����ActiveScriptRuby(1.8.7-p330)���g�p
- https://www.ruby-lang.org/ja/
- �J����:�܂��Ƃ䂫�Ђ�
- ���C�Z���X�FRuby Licence

### Exerb                            #�J����ActiveScriptRuby(1.8.7-p330)�����ł��g�p
- http://exerb.osdn.jp/man/README.ja.html
- �J����:�����E��
- ���C�Z���X�FLGPL

### gem                              #�J����ActiveScriptRuby(1.8.7-p330)�����ł��g�p
- https://rubygems.org/
- ���C�Z���X�FRuby Licence

### VisualuRuby                      #�J����ActiveScriptRuby(1.8.7-p330)�����ł��g�p ��swin.so������
- http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html
- �J����:�ɂႷ
- ���C�Z���X�FRuby Licence

### json-1.4.6-x86-mswin32
- https://rubygems.org/gems/json/versions/1.4.6
- https://rubygems.org/gems/json/versions/1.4.6-x86-mswin32
- �J����:Florian Frank
- ���C�Z���X�FRuby Licence

### DLL

#### libiconv 1.11  (iconv.dll)       #Exerb��movement_script_change.exe�ɓ���
- https://www.gnu.org/software/libiconv/
- Copyright (C) 1998, 2019 Free Software Foundation, Inc.
- ���C�Z���X�FLGPL
