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

SETTING_FILE = EXE_DIR + "setting.json"

def time_format(time)
  sec = time % 60
  min = (time / 60).to_i
  return "%d:%.3f" % [min, sec]
end

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

def movement_cnv(movements, change_data, time_add)
  result_mes = "*** Change List ***\r\n"
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
    if time_add
      movement['time'] = "#{time_format(start_time)} - #{time_format(time)}"
    end
    change_flag = []
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
              change_flag.push change_time
            end
          else
            if start_time <= a.to_f && time >= a.to_f
              movement.merge!(change['json']) {|key, self_val, other_val| chile_merge(self_val, other_val)}
              change_flag.push change_time
            end
          end
        end
      else
        if start_time <= change_time.to_f && time >= change_time.to_f
          movement.merge!(change['json']) {|key, self_val, other_val| chile_merge(self_val, other_val)}
          change_flag.push change_time
        end
      end
    end
    unless change_flag == []
      result_mes += "Movement : #{time_format(start_time)} - #{time_format(time)} -> Change time : #{change_flag.join(';')}\r\n"
    end
  end
  result_mes += "*** End Change ***"
  return result_mes
end

class FormMain                                                      ##__BY_FDVR

  def self_created
    @movement_ext_list = [["MovementScript(*.json)","*.json"],["all file (*.*)","*.*"]]
    @change_ext_list = [["ChangeScript(*.json)","*.json"],["all file (*.*)","*.*"]]
    @radioBtnFormatCameraPlus.check(true)
    if File.exist?(SETTING_FILE)
      setting = JSON.parse(File.read(SETTING_FILE))
      if a = setting['MovementScript']
        @editMovementScript.text = a
        @editMovementScript.setCaret(a.size - 1)
      end
      if a = setting['ChangeScript']
        @editChangeScript.text = a
        @editChangeScript.setCaret(a.size - 1)
      end
      if a = setting['SaveScript']
        @editSaveScript.text = a
        @editSaveScript.setCaret(a.size - 1)
      end
      @checkBoxAddTime.check(setting['AddTime']) if setting['AddTime']
      @radioBtnFormatCameraPlus.check(setting['CameraPlus']) if setting['CameraPlus']
    end
  end
  
  def select_file(edit, ext_list, text, open = true)
    file_path = edit.text
    folder = nil
    file = nil
    if file_path
      if File.exist? file_path
        folder = File.dirname(file_path)
        file   = File.basename(file_path)
      else
        folder = File.dirname(file_path)
        folder = nil unless File.directory? folder
        file   = File.basename(file_path) unless open
      end
    end
    if open
      file = SWin::CommonDialog::openFilename(self, ext_list, 0x1004, "#{text} file select", '*.json', folder, file)
    else
      file = SWin::CommonDialog::saveFilename(self, ext_list, 0x1004, "Save #{text} file", '*.json', folder, file)
    end
    return unless file
    return if open && !File.exist?(file)
    edit.text = file
    edit.setCaret(file.size - 1)
  end
  
  def buttonClear_clicked
    @editMovementScript.text = ""
    @editChangeScript.text = ""
    @editSaveScript.text = ""
    @textLog.text = ""
    @checkBoxAddTime.check(false)
    @radioBtnFormatCameraPlus.check(true)
  end

  def buttonSave_clicked
    setting = {}
    setting['MovementScript'] = @editMovementScript.text.strip
    setting['ChangeScript'] = @editChangeScript.text.strip
    setting['SaveScript'] = @editSaveScript.text.strip
    setting['AddTime'] = @checkBoxAddTime.checked?
    setting['CameraPlus'] = @radioBtnFormatCameraPlus.checked?
    File.open(SETTING_FILE, 'w') do |file|
      JSON.pretty_generate(setting).each do |line|
        file.puts line
      end
    end
  end

  def buttonMovementScript_clicked
    select_file(@editMovementScript, @movement_ext_list, 'MovementScript')
  end

  def buttonChangeScript_clicked
    select_file(@editChangeScript, @change_ext_list, 'ChangeScript')
  end

  def buttonSaveScript_clicked
    select_file(@editSaveScript, @movement_ext_list, 'MovementScript', false)
  end

  def buttonLogClear_clicked
    @textLog.text = ""
  end

  def buttonClose_clicked
    close
  end

  def buttonChange_clicked
    movement_file = @editMovementScript.text.strip
    change_file   = @editChangeScript.text.strip
    save_file     = @editSaveScript.text.strip
    unless File.exist?(movement_file) && File.exist?(change_file)
      messageBox("Select MovementScript and ChangeScript files!","Script file error!",48)
      return
    end
    camera_plus = true
    unless (@radioBtnFormatCameraPlus.checked?)
      camera_plus = false
    end
    begin
      movement_data = JSON.parse(File.read(movement_file))
    rescue Exception => e
      messageBox("MovementScript JSON formatting error!\r\n\r\n#{e.inspect}","MovementScript JSON error!",48)
      return
    end
    begin
      change_data = JSON.parse(File.read(change_file))
    rescue Exception => e
      messageBox("ChangeScript JSON formatting error!\r\n\r\n#{e.inspect}","ChangeScript JSON error!",48)
      return
    end
    movements = movement_data['Movements']
    unless movements
      messageBox("No 'Movements' entry in the MovementScript file!","MovementScript file error!",48)
      return
    end
    if File.exist?(save_file)
      return unless messageBox("Do you want to overwrite?","Overwrite confirmation",0x0004) == 6
    end
    @textLog.text = movement_cnv(movements, change_data, @checkBoxAddTime.checked?)
    File.open(save_file, 'w') do |file|
      JSON.pretty_generate(movement_data).each do |line|
        file.puts line
      end
    end
  end
end                                                                 ##__BY_FDVR

VRLocalScreen.start FormMain
