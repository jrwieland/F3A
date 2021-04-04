---- #########################################################################
-----# F3A Caller  V1.0                                                      #
-----# Developer https://github.com/jrwieland/F3A                            #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html	             #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 3 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #########################################################################

--Locals
local playingSong = 1
local errorOccured = false

loadScript("/SOUNDS/lists/f21/playlist.lua")() --1st playlist in songList (see sample list below)

--Playlists folders names i.e. /SONGS/lists/"foldername"  below are placeholder names
local songList=
{"f21",
"p21",
"ama_sportsman",
} 

--Options
local options = {
   { "Use dflt clrs", BOOL, 1 }
  }

-- create zones
local function create(zone, options)
  local tunes = { zone=zone, options=options}
  model.setGlobalVariable(8,0,1) -- resets GV9 to 1 upon startup
  model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[1][5],active=0})--resets playing song on  to the 1st song on startup
  return tunes
      end

-- control functions
local function error(strings)
	errorStrings = strings
	errorOccured = true
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
nextS = getValue("ls10")
prevS = getValue("ls11")
advS = getValue("ls12")
revS = getValue("ls13")
listN = getValue("ls14")
listP = getValue("ls15")
if advS >= 1  then
      if playingSong == #playlist then
        playingSong = #playlist
        model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
      else
        playingSong = playingSong + 1
			model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
	end
  end
		if revS >= 1  then
      if playingSong == 1 then
        playingSong = 1
        model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
      else
        playingSong = playingSong - 1
			model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
	end
  end
 local selection=playingSong
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
--song over
	if  nextS >= 1 then
		if playingSong >= #playlist then
      lcd.clear()
			lcd.drawText(tunes.zone.x+150, tunes.zone.y+50, "End of Manuevers", INVERS)
			    else
			playingSong = playingSong + 1
			model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
      playFile("/SOUNDS/en/".. playlist[playingSong][5]..".wav")
		end
     end
--	-- Next song
local long=playlist[playingSong][6]
	if model.getTimer(2).value >= long and prevS >= 1 then
		if playingSong <= 1 then
      playingSong = 1
		else
			playingSong = playingSong - 1
			model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
      playFile("/SOUNDS/en/".. playlist[playingSong][5]..".wav")
		end
	end
	
--Change Previous Playlist
	if listP > -1 then
		if not prevListSwitchPressed then
		if model.getGlobalVariable(8,0)<= 0 then	
		model.setGlobalVariable(8,0,#songList)
		playingSong = 1	
		set2 = songList[model.getGlobalVariable(8,0)]
		else
		playingSong = 1	
		set2 = songList[model.getGlobalVariable(8,0)]
	end
	loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
	model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
	else
	prevListSwitchPressed = false
	end
	end
	
	--Change next Playlist
	if listN > -1 then
	if not nextListSwitchPressed then
		if model.getGlobalVariable(8,0) >= #songList +1 then
		set2 = songList[1] 
		playingSong = 1	
		model.setGlobalVariable(8,0,1)
	else
		playingSong = 1	
    set2 = songList[model.getGlobalVariable(8,0)]
	end
	loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
	model.setCustomFunction(3,{switch = 9,func = 11,name = playlist[playingSong][5],active =0})
  else
		nextListSwitchPressed = false
	end
    
	end
  end
return { name="F3A", options=options, create=create, update=update, refresh=refresh, background=background }
