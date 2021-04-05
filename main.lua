-- #########################################################################
---# F3A Caller  V1.0                                                      #
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

loadScript("/SOUNDS/lists/p21/playlist.lua")() --1st callList (below)
--Call lists folders names i.e. /SOUNDS/lists/"foldername"  below are the foldernames these can be rearranged or deleted to suit your needs.
local callList=
{"p21",
"f21",
"ama_club",
"ama_sportsman",
"ama_inter",
"ama_advanced",
"ama_masters",
} 

--Options
local options = {
 { "Use dflt clrs", BOOL, 1 }
}

-- create zones
local function create(zone, options)
  local tunes = { zone=zone, options=options}
  model.setGlobalVariable(8,0,1) -- resets GV9 to 1 upon startup
  model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[1][5],active=0})
  --[[resets Call List to the Default Maneuver & call on startup 
  Switch Numbers run consecutive 
  Sa(up) = 1, through the remainder of the switches --]]
  return tunes
end

--Update zones and options	
local function update(tunes, options)
  tunes.options = options
end

--BackGround 
local function background(tunes)
end

function refresh(tunes)
  --call list and Sequence Controls
  nextS = getValue("ls10") --Next Call LS
  prevS = getValue("ls11") -- Previous Call LS
  advS = getValue("ls12") -- Advance Calls without playing LS
  revS = getValue("ls13")  --Previous Call through without playing LS
  listN = getValue("ls14")  --Change to Next Maneuver List LS
  listP = getValue("ls15")  --Change to Previous Maneuver List LS
  -- Advance Calls without playing
  if advS >= 1 and model.getTimer(2).value >= 1 then
    if currentCall == #playlist then
      currentCall = #playlist
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
    else
      currentCall = currentCall + 1
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      model.setTimer(2,{value=0})
    end
  end
  --Previous Call through without playing
  if revS >= 1 and model.getTimer(2).value >= 1 then
    if currentCall == 1 then
      currentCall = 1
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      model.setTimer(2,{value=0})
    else
      currentCall = currentCall - 1
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      model.setTimer(2,{value=0})
    end
  end
  --Next Call
  local long=playlist[currentCall][6]
  if model.getTimer(2).value >= long and nextS >= 1 then
    if currentCall == #playlist then
      currentCall = #playlist
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      model.setTimer(2,{value=0})
    else
      currentCall = currentCall +1 
      model.setTimer(2,{value=0})
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      playFile("/SOUNDS/en/".. playlist[currentCall][5] ..".wav")
    end
  end
  --Previous Call
  if model.getTimer(2).value >= long and prevS >= 1 then
    if currentCall == 1 then
      model.setTimer(2,{value=0})
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      playFile("/SOUNDS/en/".. playlist[currentCall][5] ..".wav")
    else
      currentCall = currentCall - 1
      model.setTimer(2,{value=0})
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[currentCall][5],active=0})
      playFile("/SOUNDS/en/".. playlist[currentCall][5] ..".wav")
    end
  end
  --LCD Display
  local selection=currentCall 
  lcd.drawText(tunes.zone.x+80, tunes.zone.y, title, MIDSIZE)
  lcd.drawText(tunes.zone.x+130, tunes.zone.y+30, "Maneuver No. "..selection, INVERS)
  lcd.drawText(tunes.zone.x, tunes.zone.y+50, playlist[selection][1],SMLSIZE)
  lcd.drawText(tunes.zone.x, tunes.zone.y+70, playlist[selection][2],SMLSIZE)
  lcd.drawText(tunes.zone.x, tunes.zone.y+90, playlist[selection][3],SMLSIZE)
  lcd.drawText(tunes.zone.x, tunes.zone.y+110, playlist[selection][4],SMLSIZE)
  if selection >= #playlist then
    lcd.drawText(tunes.zone.x+130, tunes.zone.y+130, "End of Manuevers", INVERS)
  else
    lcd.drawText(tunes.zone.x+130, tunes.zone.y+130, "Maneuver No. "..selection+1, INVERS)
    lcd.drawText(tunes.zone.x, tunes.zone.y+150, playlist[selection+1][1],SMLSIZE)
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
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[1][5],active=0})
      model.setTimer(2,{value=0})
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
      model.setCustomFunction(61,{switch = 9,func = 11,name = playlist[1][5],active=0})
      model.setTimer(2,{value=0})
    else
      prevListSwitchPressed = false
    end
  end
end
return { name="F3A", options=options, create=create, update=update, refresh=refresh, background=background }
