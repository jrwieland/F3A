---- #########################################################################
-----# F3K Caller V0.01                                                      #
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
---- #                                                                       #
---- #########################################################################

--Locals
local playingSong = 1
local errorOccured = false

loadScript("/SOUNDS/lists/f3k/playlist.lua")() --1st playlist in songList (see sample list below)

--Playlists folders names i.e. /SONGS/lists/"foldername"  below are placeholder names
local songList=
{"session1",
"session2",
"session3",
"session4",
} 

--Options
local options = {
  { "Use dflt clrs", BOOL, 1 }
  }

-- create zones
local function create(zone, options)
  local call = { zone=zone, options=options}
  model.setGlobalVariable(8,0,1)
  model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[1][2]})--resets playing song on  to the 1st song on startup
  return call
      end

-- control functions
local function error(strings)
	errorStrings = strings
	errorOccured = true
end

--Update zones and options	
local function update(call, options)
 call.options = options
     end
 
--BackGround 
local function background(call)
 end
 
-- Following is the various widgets zones from top bar to full screen (make changes as desired)
-- Zone size: top bar widgets
local function refreshZoneTiny(call)
	local selection=playingSong
		lcd.drawText(call.zone.x, call.zone.y,songList[1], SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+15,"> ".. playlist[selection][2],SMLSIZE)
end

--- Zone size: 160x32 1/8th
local function refreshZoneSmall(call)
	local selection=playingSong
		lcd.drawText(call.zone.x, call.zone.y+2,title, SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+17, playlist[selection][1], INVERS+SMLSIZE)
 end 
	  
--- Zone size: 180x70 1/4th  (with sliders/trim)
--- Zone size: 225x98 1/4th  (no sliders/trim)
local function refreshZoneMedium(call)
	lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
	lcd.drawFilledRectangle(call.zone.x+35,call.zone.y+2,k,8,CUSTOM_COLOR)
local selection=playingSong
	lcd.drawText(call.zone.x, call.zone.y+16,"Playing > ".. title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(call.zone.x, call.zone.y+30, playlist[selection - 2][1],SMLSIZE)
	  	lcd.drawText(call.zone.x, call.zone.y+45, playlist[selection - 1][1],SMLSIZE)
	  	lcd.drawText(call.zone.x, call.zone.y+60, string.char(126) .. playlist[selection][1],INVERS+SMLSIZE)
	else
	  if selection == 1 then	
		lcd.drawText(call.zone.x, call.zone.y+30, string.char(126) .. playlist[selection][1],INVERS+SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+45, playlist[selection + 1][1],SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+60, playlist[selection + 2][1],SMLSIZE)
	else		
		lcd.drawText(call.zone.x, call.zone.y+30, playlist[selection - 1][1],SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+45, string.char(126) .. playlist[selection][1], INVERS+SMLSIZE)
		lcd.drawText(call.zone.x, call.zone.y+60, playlist[selection + 1][1],SMLSIZE)
  	end 
  	end	
end
 
--- Zone size: 192x152 1/2
local function refreshZoneLarge(call)
		lcd.setColor(CUSTOM_COLOR,lcd.RGB(0,100,0))
		lcd.drawFilledRectangle(call.zone.x+35,call.zone.y+40,k,18,CUSTOM_COLOR)
		local selection=playingSong
		lcd.drawText(call.zone.x, call.zone.y+60,"Playing > ".. title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(call.zone.x, call.zone.y+85, playlist[selection - 2][1])
	  	lcd.drawText(call.zone.x, call.zone.y+105, playlist[selection - 1][1])
	  	lcd.drawText(call.zone.x, call.zone.y+125, string.char(126) .. playlist[selection][1],INVERS)
	else
	if selection == 1 then	
		lcd.drawText(call.zone.x, call.zone.y+85, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(call.zone.x, call.zone.y+105, playlist[selection + 1][1])
		lcd.drawText(call.zone.x, call.zone.y+125, playlist[selection + 2][1])
	else		
		lcd.drawText(call.zone.x, call.zone.y+85, playlist[selection - 1][1])
		lcd.drawText(call.zone.x, call.zone.y+105, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(call.zone.x, call.zone.y+125, playlist[selection + 1][1])
  	end 
  	end	
end
	
--- Zone size: 390x172 1/1 (with sliders and trims)
local function refreshZoneXLarge(call)
--music display
	local selection=playingSong
	lcd.drawText(90, y+5, "Selected Playlist >>",SMLSIZE)
	lcd.drawText(220, y+5, title, SMLSIZE)
	if selection == #playlist then
	  	lcd.drawText(40, y+20, playlist[selection - 2][1])
	  	lcd.drawText(40, y+38, playlist[selection - 1][1])
	  	lcd.drawText(40, y+56, string.char(126) .. playlist[selection][1],INVERS)
	else
	  if selection == 1 then	
		lcd.drawText(40, y+20, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(40, y+38, playlist[selection + 1][1])
		lcd.drawText(40, y+56, playlist[selection + 2][1])
	else		
		lcd.drawText(40, y+20, playlist[selection - 1][1])
		lcd.drawText(40, y+38, string.char(126) .. playlist[selection][1], INVERS)
		lcd.drawText(40, y+56, playlist[selection + 1][1])
  	 end 
	 end

end
	  
	  --- Zone size: 460x252 1/1 (no sliders/trim/topbar)
local function refreshZoneFull(call)
--music display
	local selection=playingSong
	lcd.drawText(90, y+4, "Selected Playlist >>".. title, SMLSIZE)
		if selection == #playlist then
	  	lcd.drawText(12, y+20, playlist[selection - 2][1])
	  	lcd.drawText(12, y+40, playlist[selection - 1][1])
	  	lcd.drawText(12, y+60, string.char(126) .. playlist[selection][1],INVERS)
	  else
	  if selection == 1 then	
		lcd.drawText(12, y+20, string.char(126) .. playlist[selection][1],INVERS)
		lcd.drawText(12, y+40, playlist[selection + 1][1])
		lcd.drawText(12, y+60, playlist[selection + 2][1])
	  else		
		lcd.drawText(12, y+20, playlist[selection - 1][1])
		lcd.drawText(12, y+40, string.char(126) .. playlist[selection][1], INVERS)
		lcd.drawText(12, y+60, playlist[selection + 1][1])
 	 end 
 	 end	
 end

function refresh(call)
listP = getValue("ls13")
listN = getValue("ls12")
prevS = getValue("ls10")
nextS = getValue("ls11")
--song over
	local long=playlist[playingSong][3]
	if model.getTimer(2).value >= long then
		if playingSong == #playlist then
			playingSong = 1	
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		else
			playingSong = playingSong + 1
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		end
	end
	-- Next song
	if nextS > -1 then
		if not nextSongSwitchPressed then
		if playingSong == #playlist then
			playingSong = 1	
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
		else
			playingSong = playingSong + 1
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
		end
		else
		nextSongSwitchPressed = false
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
	model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
	model.setTimer(2,{value=0})
	else
	prevListSwitchPressed = false
	end
	end
	
	--Change next Playlist
	if listN > -1 then
	if not nextListSwitchPressed then
		if model.getGlobalVariable(8,0) >= #songList then
		set2 = songList[1] 
		playingSong = 1	
		model.setGlobalVariable(8,0,1)
	else
		playingSong = 1	
		set2 = songList[model.getGlobalVariable(8,0)]
	end
	loadScript("/SOUNDS/lists/"..set2.."/playlist.lua")()
	model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
	model.setTimer(2,{value=0})
		else
		nextListSwitchPressed = false
	end
	end
	-- previous song
	if prevS > -1 then
	if not prevSongSwitchPressed then
		if playingSong == 1 then
			playingSong = #playlist	
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		else
			playingSong = playingSong - 1
			model.setCustomFunction(62,{switch = 132,func = 16,name = playlist[playingSong][2]})
			model.setTimer(2,{value=0})
		end
		else
		prevSongSwitchPressed = false
	end	
	end	
	
--Widget Display by Size
	if call.zone.w  > 450 and call.zone.h > 240 then refreshZoneFull(call)
  	  elseif call.zone.w  > 200 and call.zone.h > 165 then refreshZoneXLarge(call)
	  elseif call.zone.w  > 180 and call.zone.h > 145 then refreshZoneLarge(call)
	  elseif call.zone.w  > 170 and call.zone.h >  65 then refreshZoneMedium(call)
	  elseif call.zone.w  > 150 and call.zone.h >  28 then refreshZoneSmall(call)
	  elseif call.zone.w  >  65 and call.zone.h >  35 then refreshZoneTiny(call)
  	end
end
 
return { name="F3K", options=options, create=create, update=update, refresh=refresh, background=background }
