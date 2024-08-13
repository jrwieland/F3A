-- #########################################################################
---# F3A Practice Caller  V2.1                                             #
---# Developer: https://github.com/jrwieland                               #
-- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html	             #
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
local curTime =getRtcTime()

loadScript("/SOUNDS/lists/ama_advanced/playlist.lua")()--1st callList (below)

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
  model.setGlobalVariable(7,0,1)
  model.setGlobalVariable(8,0,1) -- resets GV9 to 1 upon startup
  flushAudio()
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
  nextS = getLogicalSwitchValue(49) --Next Call LS
  prevS = getLogicalSwitchValue(50) -- Previous Call LS
  listN = getLogicalSwitchValue(51)  --Change to Next Maneuver List LS
  listP = getLogicalSwitchValue(52)  --Change to Previous Maneuver List LS
  again = getValue(calls.options.switch)
  elapsed = getRtcTime()-curTime

  --Move forward to Specific Maneuver
  if nextS == true and again <= -1 then
    if currentCall == #playlist then
      currentCall = model.setGlobalVariable(8,0,#playlist)
    else
    end
    currentCall = model.getGlobalVariable(8,0)
  end

  --Move backwards to Specific Maneuver
  if  prevS == true and again <= -1 then
    if currentCall <= 0  then
      model.setGlobalVariable(8,0,1)
    else
    end
    currentCall = model.getGlobalVariable(8,0)
  end

--    -- Repeat call
  if again == 0 and elapsed >= 1 then
    model.setGlobalVariable(8,0,currentCall)
    model.setCustomFunction(59,{switch = 8,func = 11,name = playlist[currentCall][8],active=1,repetition=80})
    curTime =getRtcTime()
  end

  --Next Call
  if nextS == true and again >= 1 and elapsed >= 1 then
    flushAudio()
    if currentCall == #playlist then
      currentCall = model.setGlobalVariable(8,0,#playlist)
    else
    end
    currentCall = model.getGlobalVariable(8,0)
    playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    curTime =getRtcTime()
  end

  --Previous Call
  if  prevS == true and again >= 1 and elapsed >= 1 then
    if currentCall <= 1 then
      model.setGlobalVariable(8,0,1)
    else
    end
    currentCall=model.getGlobalVariable(8,0)
    playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    curTime =getRtcTime()
  end

  --Change to Next Maneuver List
  if listN == true and elapsed >= 1 then
    if model.getGlobalVariable(7,0) > #callList then
      model.setGlobalVariable(7,0,1)
    else
    end
    loadScript("/SOUNDS/lists/"..callList[model.getGlobalVariable(7,0)].."/playlist.lua")()
    model.setGlobalVariable(8,0,1)
    currentCall = model.getGlobalVariable(8,0)
    playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")     
    curTime =getRtcTime()
  end

--Change to Previous Maneuver List
  if listP == true and elapsed >= 1 then
    if model.getGlobalVariable(7,0)<= 0 then	
      model.setGlobalVariable(7,0,#callList)
    else
    end
    loadScript("/SOUNDS/lists/"..callList[model.getGlobalVariable(7,0)].."/playlist.lua")()
    model.setGlobalVariable(8,0,1)	
    currentCall = model.getGlobalVariable(8,0)
    playFile("/SOUNDS/en/".. playlist[currentCall][8] ..".wav")
    curTime =getRtcTime()
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
