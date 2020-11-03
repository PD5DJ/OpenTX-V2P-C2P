# OpenTX-V2P-C2P
OpenTX Custom lua scripts.

Converts Frsky VFAS & MLVSS/FLVSS sensor voltage to battery percentage sensor to be used in OTX enviroment.

Scripts can be used on any OpenTX based radio.

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/VLTCEL.png)

-----------------------------------------------------------

This repository contains 2 scripts.

**1. VLT%.lua**

**2. CEL%.lua**

----------------------------------------------------------

**VLT%.lua**

This script reads the voltage of any standard VFAS,A1..A2 etc like sensor inputs.

It creates a new sensor **VLT0..VLT7**

The voltage is then converted to a battery percentage.

This new sensor can be used with anything inside the OpenTX enviroment.

For example to be used with my one of my other widgets like "Gaugie"



**Configuring VLT% Script**

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/VLT_Config.png)

3 things are important here:

1. **Instance** - Select an instance for this script.. setting 0 will create a sensor **VLT0**, 5 will create sensor **VLT5**.

2. **Sensor** – Select voltage input sensor.

3  **Cells** – Set amount of cells used (for correct % calculation)

-----------------------------------------------------------

**CEL%.lua**

This script does the same as the script above but reads the voltage of MLVSS or FLVSS sensor input.



**Configuring CEL% Script**

![alt text](https://github.com/Hobby4life/OpenTX-V2P-C2P/blob/main/CEL_Config.png)

1. **Instance** - Select an instance for this script.. setting 0 will create a sensor **CEL0**, 5 will create sensor **CEL5**.

2. **Sensor** – Select Cell input sensor.

**(Power cycle of the TX is needed!)**
