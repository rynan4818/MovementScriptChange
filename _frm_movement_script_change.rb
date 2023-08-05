##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vruby'
require 'vr/vrcontrol'

class FormMain < VRForm

  def construct
    self.caption = 'MovementScriptChange'
    self.move(582,194,670,651)
    addControl(VRButton,'buttonChange',"Change!",504,560,128,24)
    addControl(VRButton,'buttonChangeScript',"Select",568,128,64,24)
    addControl(VRButton,'buttonClear',"ClearSetting",408,16,96,24)
    addControl(VRButton,'buttonClose',"Close",416,560,64,24)
    addControl(VRButton,'buttonLogClear',"LogClear",112,224,96,24)
    addControl(VRButton,'buttonMovementScript',"Select",568,72,64,24)
    addControl(VRButton,'buttonSave',"SaveSetting",528,16,104,24)
    addControl(VRButton,'buttonSaveScript',"Select",568,184,64,24)
    addControl(VRCheckbox,'checkBoxAddTime',"Add time to SaveScript",32,560,200,16)
    addControl(VREdit,'editChangeScript',"",32,128,536,24)
    addControl(VREdit,'editMovementScript',"",32,72,536,24)
    addControl(VREdit,'editSaveScript',"",32,184,536,24)
    addControl(VRRadiobutton,'radioBtnFormatCameraPlus',"CameraPlus",96,16,112,16)
    addControl(VRStatic,'static1',"Format",32,16,56,24)
    addControl(VRStatic,'static2',"Movement Script",32,48,144,24)
    addControl(VRStatic,'static3',"Change Script",32,104,152,24)
    addControl(VRStatic,'static4',"Save Script",32,160,152,24)
    addControl(VRStatic,'static5',"Log",32,224,48,24)
    addControl(VRText,'textLog',"",32,248,600,288,1345323204)
  end 

end

##__END_OF_FORMDESIGNER__
