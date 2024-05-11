-- #########################################################################
---# F3A Practice Caller  V2.0                                             #
---# Developer: https://github.com/jrwieland                               #
-- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html	              #
-- #                                                                       #
-- # This program is free software; you can redistribute it and/or modify  #
-- # it under the terms of the GNU General Public License version 3 as     #
-- # published by the Free Software Foundation.                            #
-- #                                                                       #
-- # This program is distributed in the hope that it will be useful        #
-- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
-- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
-- # GNU General Public License for more details.                          #
-- #########################################################################

--Locals
local currentCall = 1
local errorOccured = false
    
loadScript("/SOUNDS/lists/f25/playlist.lua")()--1st callList (below)

--Call lists folders names i.e. /SOUNDS/lists/"foldername"  below are the foldernames these can be rearranged or deleted to suit your needs.
--Delete the rows that you do not use or the widget will fail since it cannot find the file

local callList=
{"f25",
  "p25",
  "ama_club",
  "ama_sportsman",
  "ama_inter",
  "ama_masters",
} 

--Options
local options = {
 { "switch", SOURCE, DEFAULT_PRACTICE_SWITCH_ID },
 { "TextColor", COLOR, COLOR_THEME_PRIMARY2 },
}

-- create zones
local function create(zone, options)
  local calls = { zone=zone, options=options}
  model.setGlobalVariable(8,0,1) -- resets GV9 to 1 upon startup
  model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[1][8],active=1,repetition=-1})
  return calls
end

--Update zones and options	
local function update(calls, options)
  calls.options = options
end

--BackGround 
local function background(calls)
end

function refresh(calls)
  --call list and Sequence Controls
  nextS = getValue("ls50") --Next Call LS
  prevS = getValue("ls51") -- Previous Call LS
  listN = getValue("ls52")  --Change to Next Maneuver List LS
  listP = getValue("ls53")  --Change to Previous Maneuver List LS
  again = getValue(calls.options.switch)
  
  --Move forward to Specific Maneuver
  if nextS >=1 and again < -1 then
    if currentCall == #playlist then
      currentCall = #playlist
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
    else
      currentCall = currentCall +1 
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
    end
  end
  
  --Move backwards to Specific Maneuver
  if  prevS >= 1 and again < -1 then
    if currentCall == 1 then
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
      playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    else
      currentCall = currentCall - 1
            model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
    end
  end
      
    -- Repeat call
    if again <= 99 and again > -1 and nextS >=1  then
      playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    end
      
  --Next Call
  if nextS >=1 and again >= 1 then
    if currentCall == #playlist then
      currentCall = #playlist
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
    else
      currentCall = currentCall +1 
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
      playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    end
  end
  
  --Previous Call
  if  prevS >= 1 and again >= 1 then
    if currentCall == 1 then
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
      playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    else
      currentCall = currentCall - 1
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[currentCall][8],active=1,repetition=-1})
      playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    end
  end
  
  --Change to Next Maneuver List
  if listN > -1 then
    if not nextListSwitchPressed then
      if model.getGlobalVariable(8,0) >= #callList +1 then
        set2 = callList[1] 
        currentCall = 1	
        model.setGlobalVariable(8,0,1)
      else
        currentCall = 1	
        set2 = callList[model.getGlobalVariable(8,0)]
      end
      loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[1][8],active=1,repetition=-1})
      
    else
      nextListSwitchPressed = false
    end
  end
  
--Change to Previous Maneuver List
  if listP > -1 then
    if not prevListSwitchPressed then
      if model.getGlobalVariable(8,0)<= 0 then	
        model.setGlobalVariable(8,0,#callList)
        currentCall = 1	
        set2 = callList[model.getGlobalVariable(8,0)]
      else
        currentCall = 1	
        set2 = callList[model.getGlobalVariable(8,0)]
      end
      loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
      model.setCustomFunction(61,{switch = 233,func = 11,name = playlist[1][8],active=1,repetition=-1})
      
    else
      prevListSwitchPressed = false
    end
  end
  
  --LCD Display
  local selection=currentCall 
  if calls.zone.w  > 200 and calls.zone.h > 165 then
   lcd.drawText(calls.zone.x+75,calls.zone.y, title, calls.options.TextColor)
  lcd.drawText(calls.zone.x+130, calls.zone.y+30, "Sequence No. "..selection, INVERS+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+55, playlist[selection][1],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+70, playlist[selection][2],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+85, playlist[selection][3],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+100, playlist[selection][4],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+115, playlist[selection][5],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+130, playlist[selection][6],SMLSIZE+calls.options.TextColor)
  lcd.drawText(calls.zone.x, calls.zone.y+145, playlist[selection][7],SMLSIZE+calls.options.TextColor)
  if selection >= #playlist then
    lcd.drawText(calls.zone.x+130, calls.zone.y+30, "End of Sequence", INVERS)
  end
  else
      lcd.drawText(calls.zone.x, calls.zone.y, title, calls.options.TextColor)
      lcd.drawText(calls.zone.x, calls.zone.y+14, "Sequence No. "..selection, calls.options.TextColor)
    if selection >= #playlist then
    lcd.drawText(calls.zone.x, calls.zone.y+14, "End of Sequence", INVERS)
    end
end
end

return { name="F3A", options=options, create=create, update=update, refresh=refresh, background=background }
