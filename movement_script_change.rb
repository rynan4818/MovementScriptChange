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

def chile_merge(self_data, other_data)
  if self_data.kind_of?(Hash) && other_data.kind_of?(Hash)
    return self_data.merge(other_data) {|key, self_val, other_val| chile_merge(self_val, other_val)}
  elsif self_data.kind_of?(Numeric) && other_data.kind_of?(String)
    eval "return #{self_data.to_f}#{other_data}"
  else
    return other_data
  end
end

def key_guide_get(hash_data, key_guide)
  a = hash_data
  key_guide.each do |key|
    a = a[key]
  end
  return a
end

def key_guide_set(key_guide, val)
  a = {}
  b = a
  c = a
  key_end = ""
  key_guide.each do |key|
    b = a
    a[key] = {}
    a = a[key]
    key_end = key
  end
  b[key_end] = val
  return c
end

def leap(start_val, end_val, t)
  return (1.0 - t.to_f) * start_val.to_f + t.to_f * end_val
end

def all_lerp(start_data, end_data, t)
  if start_data.kind_of?(Hash) && end_data.kind_of?(Hash)
    result_data = {}
    start_data.each do |key, start_val|
      a = all_lerp(start_val, end_data[key], t)
      result_data[key] = a unless a == nil
    end
    return result_data
  elsif start_data.kind_of?(Array) && end_data.kind_of?(Array)
    result_data = []
    start_data.each_with_index do |start_val, i|
      a = all_lerp(start_val, end_data[i], t)
      break if a == nil
      result_data.push a
    end
    return result_data
  elsif start_data.kind_of?(Numeric) && end_data.kind_of?(Numeric)
    return leap(start_data, end_data, t)
  end
  return nil
end

def lerp_cnv(json_data, lerp, start_ref, end_ref, t_ref)
  t = (t_ref - start_ref) / (end_ref - start_ref)
  start_data = key_guide_get(json_data, lerp["start"])
  end_data = key_guide_get(json_data, lerp["end"])
  return all_lerp(start_data, end_data, t)
end

def start_end_cnv(change, time_div, start_change, end_change, mov_start_time, mov_end_time)
  json_data = change['json']
  start_cng_time = 0.0
  end_cng_time = 0.0
  time_div.each do |t|
    start_cng_time = t if t <= start_change
    if t >= end_change
      end_cng_time = t
      break
    end
  end
  if lerps = change['lerps']
    result_json = json_data
    lerps.each do |lerp|
      start_data = lerp_cnv(json_data, lerp, start_cng_time, end_cng_time, mov_start_time)
      end_data   = lerp_cnv(json_data, lerp, start_cng_time, end_cng_time, mov_end_time)
      start_json = key_guide_set(lerp["start"], start_data)
      end_json = key_guide_set(lerp["end"], end_data)
      result_json = result_json.merge(start_json) {|key, self_val, other_val| chile_merge(self_val, other_val)}
      result_json = result_json.merge(end_json) {|key, self_val, other_val| chile_merge(self_val, other_val)}
    end
    return result_json
  else
    return change['json']
  end
end

def movement_cnv(movements, change_data)
  time = 0.0
  time_div = []
  movements.each do |movement|
    time += movement['Duration'].to_f
    time += movement['Delay'].to_f
    time_div.push time
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
          a.strip!
          if a =~ /([0-9\. ]+)-([0-9\. ]*)/
            start_change = $1.to_f
            if $2 == ""
              end_change = time_div[-1]
            else
              end_change = $2.to_f
            end
            if start_change <= time && end_change >= start_time
              movement.merge!(start_end_cnv(change, time_div, start_change, end_change, start_time, time)) {|key, self_val, other_val| chile_merge(self_val, other_val)}
            end
          else
            if start_time <= a.to_f && time >= a.to_f
              movement.merge!(change['json']) {|key, self_val, other_val| chile_merge(self_val, other_val)}
            end
          end
        end
      else
        if start_time <= change_time.to_f && time >= change_time.to_f
          movement.merge!(change['json']) {|key, self_val, other_val| chile_merge(self_val, other_val)}
        end
      end
    end
  end
end

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
    movement_cnv(movements, change_data)
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
