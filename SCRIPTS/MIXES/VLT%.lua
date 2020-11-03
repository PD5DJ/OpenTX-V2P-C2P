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
---- # Version:                                                                                               #
---- # 1.0                                                                                                    #
---- ##########################################################################################################


local inputs     = { {"Instance", VALUE ,0,7,0}, {"Sensor", SOURCE}, {"Cells", VALUE ,1,12,1 } }
local wait_end   = 0
local Cell_Count = 1
local state
local Voltage_Filtered = 0   
local Battery_Connected          = 0 

--state functions forward declaration
local wait, no_battery, done

-------------------------------------------------------

function no_battery()
   -- wait for battery
   Battery_Connected    = 0

   if Voltage_Filtered > 3 then
       Battery_Connected    = 1
       --state      = wait_to_stabilize
       wait_end   = getTime() + 200
   end  --  end if

end  -- no_battery()

-------------------------------------------------------

function done()

   if Voltage_Filtered < 1 then
       state      = no_battery
       Battery_Connected    = 0
    end  -- end if

end  -- end done()

-------------------------------------------------------


---------------------------------------------------------

local function run(Instance,Voltage_Source, Cell_Count)

   -- the following table of percentages has 121 percentage values ,
   -- starting from 3.0 V to 4.2 V , in steps of 0.01 V 
    --Voltage = Voltage_Source
    --Cell_Count = Cells  
  
  local Percent_Table = 
	{0  , 1  , 1  ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 ,  1 , 
	 2  , 2  , 2  ,  2 ,  2 ,  2 ,  2 ,  2 ,  2 ,  2 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 ,  3 , 
	 4  , 4  , 4  ,  4 ,  4 ,  4 ,  4 ,  4 ,  5 ,  5 ,  5 ,  5 ,  5 ,  5 ,  6 ,  6 ,  6 ,  6 ,  6 ,  6 , 
	 7  , 7  , 7  ,  7 ,  8 ,  8 ,  9 ,  9 , 10 , 12 , 13 , 14 , 17 , 19 , 20 , 22 , 23 , 26 , 28 , 30 , 
	 33 , 36 , 39 , 42 , 45 , 48 , 51 , 54 , 57 , 58 , 60 , 62 , 64 , 66 , 67 , 69 , 70 , 72 , 74 , 75 , 
	 77 , 78 , 80 , 81 , 82 , 84 , 85 , 86 , 86 , 87 , 88 , 89 , 91 , 92 , 94 , 95 , 96 , 97 , 97 , 99 , 100  }

   Voltage_Filtered = Voltage_Filtered * 0.9  +  Voltage_Source * 0.1
   
   if state == nil then state = no_battery end 
   
   if Cell_Count > 0 then 

    local Voltage_Cell    = 3
    local Battery_Percent = 0
    local Table_Index     = 1

    Voltage_Cell      = Voltage_Filtered / Cell_Count 
    Table_Index       = math.floor( 100 * Voltage_Cell - 298 )
    Battery_Connected = 1     

    if Table_Index    > 120 then  Table_Index = 120 end  --## check for index bounds
    if Table_Index    <   1 then  Table_Index =   1 end

    Battery_Percent   = Percent_Table[Table_Index]

    --https://opentx.gitbooks.io/opentx-2-2-lua-reference-guide/content/general/setTelemetryValue.html
    
    setTelemetryValue(0x0310, 0, 0 + Instance, Battery_Percent * Battery_Connected, 13, 0, "VLT"..Instance)
    
    return

  end

  return 0

end

-------------------------------------------------------

---  OpenTX LUA interface parameters declared here

return { run=run, input=inputs }

-------------------------------------------------------