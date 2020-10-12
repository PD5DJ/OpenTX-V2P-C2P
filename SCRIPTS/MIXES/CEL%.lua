---- ##########################################################################################################
---- #                                                                                                        #
---- # Advanced Battery % telemetry script based on JureZ his script                                          #
---- #                                                                                                        #
---- # Compatible with any voltage source like Vfas, A1 , A2 , MLVSS and FLVSS Sensors                        #
---- # Gives a accurate percentage of battery voltage left.                                                   #
---- #                                                                                                        #
---- #                                                                                                        #
---- # Usage:                                                                                                 #
---- #                                                                                                        #
---- # 1. Copy script file to SDCard location : SCRIPTS/MIXES                                                 #
---- # 2. Add custom lua script                                                                               #
---- # 3. Select voltage sensor input                                                                         #
---- # 4. Select amount of Lipo cells used. (if FL/MLVSS sensor is selected this option has no effect)        #
---- # 5. If FL/MLVSS sensor is used set FL/MLVSS option to 1, if not set to 0 for normal sensor operation    #
---- # Note!, If option FL/MLVSS is changed please restart your TX to take effect                             #
---- #                                                                                                        #
---- #                                                                                                        #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html                                                #
---- #                                                                                                        #
---- # This program is free software; you can redistribute it and/or modify                                   #
---- # it under the terms of the GNU General Public License version 3 as                                      #
---- # published by the Free Software Foundation.                                                             #
---- #                                                                                                        #
---- #                                                                                                        #
---- # Björn Pasteuning / Hobby4life 2019                                                                     #
---- #                                                                                                        #
---- ##########################################################################################################


local inputs     = { {"Sensor", SOURCE}}
local outputs    = { "CEL%" }
local wait_end   = 0
local cell_count = 1
local state
local filtered_voltage = 0   
local batt_on          = 0 

--state functions forward declaration
local wait, no_battery, done

-------------------------------------------------------

function no_battery()
   -- wait for battery
   batt_on    = 0

   if filtered_voltage > 3 then
       batt_on    = 1
       --state      = wait_to_stabilize
       wait_end   = getTime() + 200
   end  --  end if

end  -- no_battery()

-------------------------------------------------------

function done()

   if filtered_voltage < 1 then
       state      = no_battery
       batt_on    = 0
    end  -- end if

end  -- end done()

-------------------------------------------------------


--- This function returns the number of cels
function getCellCount(cellData)
  
  if cellData == NIL or cellData == 0 then
    return 0
  else
    return #cellData
  end
end

--- This function parse each individual cell and return the sum of all cels
function getCellSum(cellData)
    cellSum = 0
  if type(cellData) == "table" then
    for k, v in pairs(cellData) do cellSum = cellSum + v end
  end
  return cellSum
end


---------------------------------------------------------

local function run(voltsource)

   -- the following table of percentages has 121 percentage values ,
   -- starting from 3.0 V to 4.2 V , in steps of 0.01 V 
    voltage = getCellSum(voltsource)
    cell_count = getCellCount(voltsource)
  
  local Percent_Table = 
	{0  , 1  , 1  ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 , 
	 2  , 2  , 2  ,  2 ,  2 ,  2 ,  2 ,  2 ,  2 ,  2 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 , 
	 4  , 4  , 4  ,  4 ,  4 ,  4 ,  4 ,  4 ,  5 ,  5 ,  5 ,  5 ,  5 ,  5 ,  6 ,  6 ,  6 ,  6 ,  6 ,  6 , 
	 7  , 7  , 7  ,  7 ,  8 ,  8 ,  9 ,  9 , 10 , 12 , 13 , 14 , 17 , 19 , 20 , 22 , 23 , 26 , 28 , 30 , 
	 33 , 36 , 39 , 42 , 45 , 48 , 51 , 54 , 57 , 58 , 60 , 62 , 64 , 66 , 67 , 69 , 70 , 72 , 74 , 75 , 
	 77 , 78 , 80 , 81 , 82 , 84 , 85 , 86 , 86 , 87 , 88 , 89 , 91 , 92 , 94 , 95 , 96 , 97 , 97 , 99 , 100  }

   filtered_voltage = filtered_voltage * 0.9  +  voltage * 0.1
   
   if state == nil then state = no_battery   end    --state initialization

   --state(play)     -- call state function
   

   if cell_count > 0 then 

    local V_Cell      = 3
    local VB          = 0
    local table_index = 1

    V_Cell            = filtered_voltage / cell_count 
    table_index       = math.floor( 100 * V_Cell - 298 )
    batt_on           = 1     

    -- table_index       = 100   -- test case , index = 100 should report 75% charge

    if table_index    > 120 then  table_index = 120 end  --## check for index bounds
    if table_index    <   1 then  table_index =   1 end

    VB            =   Percent_Table[table_index]

    return( VB * 10.24 * batt_on )

  end  -- end if 

  return 0  ---  no error

end -- end run

-------------------------------------------------------

---  OpenTX LUA interface parameters declared here

return { run=run, input=inputs, output=outputs }

-------------------------------------------------------