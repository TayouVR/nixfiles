# VRChat bindings
opencomposite doesn't support dpad bindings correctly, alter the bindings for that.

for XRizer, add this to the steam launch args: `XRIZER_CUSTOM_BINDINGS_DIR=/mnt/linuxApps/SteamLibrary/steamapps/common/VRChat/OpenComposite/`
somewhere between `env` and `%command%`

Adjust the path to the actual location of the bindings directory.
The convention `<appdir>/OpenComposite/<controllername>.json` stems from OpenComposite. 
Use `knuckles.json` for index controllers

## full (XRizer, SteamVR)
```json
            {
               "inputs" : {
                  "south" : {
                     "output" : "/actions/Global/in/Gesture_Toggle"
                  },
                  "north" : {
                     "output" : "/actions/global/in/jump"
                  }
               },
               "mode" : "dpad",
               "parameters" : {
                  "sub_mode" : "click"
               },
               "path" : "/user/hand/right/input/trackpad"
            },
            {
               "inputs" : {
                  "south" : {
                     "output" : "/actions/Global/in/Gesture_Toggle"
                  }
               },
               "mode" : "dpad",
               "parameters" : {
                  "sub_mode" : "click"
               },
               "path" : "/user/hand/left/input/trackpad"
            },
```

## simplified (OpenComposite)
These bindings map the entire trackpad as gesture toggle button, as I can't map it as dpad in OC
```json
            {
               "inputs" : {
                  "force" : {
                     "output" : "/actions/global/in/gesture_toggle"
                  }
               },
               "mode" : "trackpad",
               "path" : "/user/hand/right/input/trackpad"
            },
            {
               "inputs" : {
                  "force" : {
                     "output" : "/actions/global/in/gesture_toggle"
                  }
               },
               "mode" : "trackpad",
               "path" : "/user/hand/left/input/trackpad"
            },
```
