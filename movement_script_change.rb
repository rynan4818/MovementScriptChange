#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#Set 'EXE_DIR' directly at runtime  直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#Available Libraries  使用可能ライブラリ
#require 'jcode'
#require 'nkf'
#require 'csv'
#require 'fileutils'
#require 'pp'
#require 'date'
#require 'time'
#require 'base64'
#require 'win32ole'
#require 'Win32API'
#require 'vr/vruby'
#require 'vr/vrcontrol'
#require 'vr/vrcomctl'
#require 'vr/clipboard'
#require 'vr/vrddrop.rb'
#require 'json'

#Predefined Constants  設定済み定数
#EXE_DIR ****** Folder with EXE files[It ends with '\']  EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ****** Main ruby script file name  メインのrubyスクリプトファイル名
#ERR_LOG ****** Error log file name  エラーログファイル名

require 'rubygems'
require 'json'
require 'vr/vruby'
require '_frm_movement_script_change'
class FormMain                                                      ##__BY_FDVR

  def self_created
    @movement_ext_list = [["MovementScript(*.json)","*.json"],["all file (*.*)","*.*"]]
    @change_ext_list = [["ChangeScript(*.json)","*.json"],["all file (*.*)","*.*"]]
    @radioBtnFormatCameraPlus.check(true)
  end
  
  def buttonMovementScript_clicked
    movement_file = SWin::CommonDialog::openFilename(self, @movement_ext_list, 0x1004, 'MovementScript file select', '*.json')
    return unless movement_file
    return unless File.exist?(movement_file)
    @editMovementScript.text = movement_file
  end

  def buttonChangeScript_clicked
    change_file = SWin::CommonDialog::openFilename(self, @change_ext_list, 0x1004, 'ChangeScript file select', '*.json')
    return unless change_file
    return unless File.exist?(change_file)
    @editChangeScript.text = change_file
  end

  def buttonClose_clicked
    close
  end

  def buttonChange_clicked
    unless File.exist?(@editMovementScript.text) && File.exist?(@editChangeScript.text)
      messageBox("Select MovementScript and ChangeScript files!","Script file error!",48)
      return
    end
    if (@radioBtnFormatCameraPlus.checked?)
      
    end
  end
  
end                                                                 ##__BY_FDVR

VRLocalScreen.start FormMain
