# OpenTX-V2P-C2P
OpenTX Custom lua scripts.

Cell to Battery % Converter script.

Converts Frsky vfas sensor voltage to battery percentage to be used in OTX enviroment.

Scripts can be used on any OpenTX based radio.

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/VLTCEL.jpg)

-----------------------------------------------------------

This repository contains 2 scripts.

**1. v2p.lua**

**2. c2p.lua**

----------------------------------------------------------

**VLT%.lua**

This script reads the voltage of any standard VFAS,A1..A2 etc like sensor inputs.

The voltage is then converted to a battery percentage.

This percentage can be used with anything inside the OpenTX enviroment.

For example to be used with my one of my other widgets like "Gaugie"

** CEL%.lua**

This script does the same as the script above but reads the voltage of MLVSS or FLVSS sensor input.

-----------------------------------------------------------

**Configuring VLT% Script**

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/VLT_Config.png)

Only 2 things are important here:

1. **Sensor** – Select voltage input sensor.

2. **Cells** – Set amount of cells used (for correct % calculation)

-----------------------------------------------------------

**Configuring CEL% Script**

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/CEL_Config.png)

Select Cels sensor input.

**(Power cycle of the TX is needed!)**