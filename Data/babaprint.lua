--[[

WELCOME TO THE BABAPRINT LIBRARY!

This library is used for printing text onto the screen in-game in a console-like manner

To install, place babaprint.lua in the 'C:\Program Files (x86)\Steam\steamapps\common\Baba Is You\Data' folder

To use,

  1.  Include the line of code:
        require("Data/babaprint")
      in the lua file in which you want to be able to babaprint!

  2.  Run the function babaprint(YOUR_TEXT_HERE) to babaprint your text and see it in-game!
  
ENJOY! :) :D!

]]--


local CONSOLE_TEXT_LINES = {}   --storage table containing each line of text in the console
local LEFT_MARGIN_SIZE = 17     --x coordinate that the text will start printing from
local FIRST_LINE_HEIGHT = 21    --y coordinate of the first line of text
local LAST_LINE_HEIGHT = 456    --y coordinate of the last line of text
local LINEBREAK_HEIGHT = 15     --distance between each line of text


--call this function to do babaprinting!
function babaprint(text_)

  local text = ""
  if type(text) == "table" then
    text = babadump(text_)
  else
    text = tostring(text_)
  end

  --clear all previously babaprinted text from the screen
  MF_letterclear("babaprint")
  
  --insert the line to print into the console
  table.insert(CONSOLE_TEXT_LINES, text)
  
  --begin printing from line 1
  print_height = FIRST_LINE_HEIGHT
  
    
  --for every line in the console
  for i = 1, #CONSOLE_TEXT_LINES do
  
    --write the current line
    writetext(CONSOLE_TEXT_LINES[i],0,LEFT_MARGIN_SIZE,print_height,"babaprint",false,3,false,nil,0)

    --advance the printing location down to the next line
    print_height = print_height + LINEBREAK_HEIGHT
    
    --if we've run out of room on the console to print
    if print_height > LAST_LINE_HEIGHT then

      --remove the first line from the console to make room and shift everything back a line
      table.remove(CONSOLE_TEXT_LINES, 1)

      --and just keep printing on the last line
      print_height = LAST_LINE_HEIGHT

    end
    
  end

end

function babaclear()
  MF_letterclear("babaprint")
  CONSOLE_TEXT_LINES = {}
end

function babadump(o)
   if type(o) == 'table' then
      local s = '('
      for k,v in pairs(o) do
         s = s .. k..'-' .. babadump(v) .. ','
      end
      return s .. ')'
   else
      return tostring(o)
   end
end