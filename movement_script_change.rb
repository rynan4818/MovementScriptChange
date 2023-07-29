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
    camera_plus = true
    unless (@radioBtnFormatCameraPlus.checked?)
      camera_plus = false
    end
    movement_change(@editMovementScript.text, @editChangeScript.text, camera_plus)
  end
  
  def movement_change(movement_file, change_file, camera_plus = true)
    movement_data = JSON.parse(File.read(movement_file))
    change_data = JSON.parse(File.read(change_file))
    movements = movement_data['Movements']
    unless movements
      messageBox("No 'Movements' entry in the MovementScript file!","MovementScript file error!",48)
      return
    end
    time = 0.0
    movements.each do |movement|
      start_time = time
      time += movement['Duration'].to_f
      time += movement['Delay'].to_f
      change_data.each do |change|
        change_time = change['time']
        if change_time.kind_of?(String)
          change_time.split(',').each do |a|
            if a =~ /([0-9\. ]+)-([0-9\. ]+)/
              start_change = $1.to_f
              end_change = $2.to_f
              if start_change <= time && end_change >= start_time
                movement.merge!(change['json'])
              end
            else
              if start_time <= a.to_f && time >= a.to_f
                movement.merge!(change['json'])
              end
            end
          end
        else
          if start_time <= change_time.to_f && time >= change_time.to_f
            movement.merge!(change['json'])
          end
        end
      end
    end
    fn = SWin::CommonDialog::saveFilename(self, @movement_ext_list, 0x1004, 'Save MovementScript file', '*.json')
    return unless fn
    if File.exist?(fn)
      return unless messageBox("Do you want to overwrite?","Overwrite confirmation",0x0004) == 6
    end
    File.open(fn, 'w') do |file|
      JSON.pretty_generate(movement_data).each do |line|
        file.puts line
      end
    end
  end
end                                                                 ##__BY_FDVR

VRLocalScreen.start FormMain
