##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vruby'
require 'vr/vrcontrol'

class FormMain < VRForm

  def construct
    self.caption = 'MovementScriptChange'
    self.move(1065,388,670,252)
    addControl(VRButton,'buttonChange',"Change!",504,168,128,24)
    addControl(VRButton,'buttonChangeScript',"Select",568,128,64,24)
    addControl(VRButton,'buttonClose',"Close",416,168,64,24)
    addControl(VRButton,'buttonMovementScript',"Select",568,72,64,24)
    addControl(VREdit,'editChangeScript',"",32,128,536,24)
    addControl(VREdit,'editMovementScript',"",32,72,536,24)
    addControl(VRRadiobutton,'radioBtnFormatCameraPlus',"CameraPlus",96,16,112,16)
    addControl(VRStatic,'static1',"Format",32,16,56,24)
    addControl(VRStatic,'static2',"Movement Script",32,48,144,24)
    addControl(VRStatic,'static3',"Change Script",32,104,152,24)
  end 

end

##__END_OF_FORMDESIGNER__
