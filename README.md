# Soil Moisture, DHT11 & DHT22 Sensors Behavior Observance and Calibration (SM2DSBOC)

## Overview ##
The intention of this experiment is to see the behavior of different sensors in different mediums, different ADCs from various MCUs and one external ADC, and contrast results. It is crucial to verify that sensors data will demonstrate consistent outcome to rely on the sensors in future applications.

Although cheap and not certified sensors were used in the experiment, the intention is not to show the sensors' precision but rather that their modes/tendencies are similar.

Three different MCUs have been used: Whisper Node AVR based on ATmega328p, Arduino MKR1000 based on SAM D21, and ESP32 Hi-Grow design. The soil moisture sensors produce analog input, thus, different ADC modules were involved with different precisions. The following table shows the of used ADC modules

|Node            |ADC type                                   |
|:--------------:|:-----------------------------------------:|
|Whisper Node:   |Internal ADC, 10 bits precision            |
|Hi-Grow ESP32:  |Internal ADC, 12 bits precision            |
|Arduino MKR1000:|External ADC, TI ADS1115, 16 bits precision|

In the next sections sensors' connections, experiment configuration, and data outcome and analysis are revealed.

## Table of Contents ##

[TOC]

## Experiment configuration ##

The experiment configuration was as exposed in the next scheme. The equipment was placed in the laboratory environment and later moved to the office TD1125.
```
        WiFi (UDP)   RX:16,TX:17                                  RX:D0,TX:D1
              ╤    ┌─────────────────────────────────────────────────────────────────┐       ┌───────┐
              └──┐ │  RX:27,TX:26    RX:13,TX:14   ┌──────────────────┐              │   ┌───┤ DHT22 │
                 │ │ ┌─────────────────────────┐   │     ┌───────┐┌───┴───┐          │   │   └───────┘
    ┌────┐ SPI ╔═┷═┷═┷═╗ ┌─────┐             ╔═┷═══┷═╗ ┌─┤ DHT22 ││ SHS85 │        ╔═┷═══┷═╗   ┌───────┐         
    │ SD ├─────╢ ESP32 ╟─┘ ┌───┴───┐         ║  MKR  ╟─┘ └───────┘└───┬───┘        ║  WIS  ╟───┤ SHS85 │         
    └────┘     ╚══┯═┯══╝   │ DHT11 │         ╚═══┯═══╝           ┌────┴────┐       ╚══┯─┯══╝   └───┬───┘        
                32│ │33    └───────┘             │ I2C           │ HIH8121 │        A1│ │A3   ┌────┴────┐         
                  │ └──────┐                 1 ┌─┴─┐ 0           └─────────┘          │ │     │ HIH8121 │         
                  └────┐   │   ┌───────────────┤ADC├────────────┐   ┌─────────────────┘ │     └─────────┘           
                       │   │   │               ┤   ├────────┐   │   │   ┌───────────────┘              
                  ____┍┷┑__│__┍┷┑_____       3 └───┘ 2 ____┍┷┑__│__┍┷┑__│______
                 ╱    │ │ ┍┷┑ │ │ ~  ╱│               ╱ ~  │ │ ┍┷┑ │ │ ┍┷┑  ~ ╱│
                ╱  ~  ╲.╱ │ │ ╲.╱   ╱ │              ╱     ╲.╱ │ │ ╲.╱ │ │   ╱ │
               ╱    ~     ╲.╱  ~   ╱  │             ╱ ~  ~     ╲.╱   ~ ╲.╱  ╱  │
              ╱___________________╱  ╱             ╱_______________________╱  ╱
              │                   │ ╱              │                       │ ╱
              │___________________│╱               │_______________________│╱
```

## Sensors' Connections ##

SPI SD and ESP32 connection

```
       SPI SD       ESP32
        ~────┐     ╔═══~
          3V3├─────╢3V3
           CS├─────╢5
         MOSI├─────╢23
          CLK├─────╢18
         MISO├─────╢19
          GND├─────╢GND
        ~────┘     ╚═══~
```

DHT22 and MKR1000 connection

```
        DHT22       MKR1000
        ~────┐     ╔═══~
          VCC├─────╢5V
         DATA├─────╢A1
          GND├─────╢GND
        ~────┘     ╚═══~
```

DHT22 and Whisper Node connection
```
        DHT22       Whisper Node
        ~────┐     ╔═══~
          VCC├─────╢5V
         DATA├─────╢A0
          GND├─────╢GND
        ~────┘     ╚═══~
```

DHT11 is internally wired to the ESP32, though the configuration is as following
```
         DHT11       ESP32
         ~────┐     ╔═══~
           VCC├─────╢5V
          DATA├─────╢22
           GND├─────╢GND
         ~────┘     ╚═══
```

SHS85 and HIH8121 are connected to the Whisper Node through the I2C interface.
```
   SHS85 & HIH8121  Whisper Node
        ~────┐     ╔═══~
          VCC├─────╢5V
          SDA├─────╢D18
          SCL├─────╢D19
          GND├─────╢GND
        ~────┘     ╚═══~
```

SHS85 and HIH8121 are connected to the Whisper Node through the I2C interface.

```
   SHS85 & HIH8121  MKR1000
        ~────┐     ╔═══~
          VCC├─────╢5V
          SDA├─────╢11
          SCL├─────╢12
          GND├─────╢GND
        ~────┘     ╚═══~
```

# Data Outcome #

## Artificial Substrate ##

The first part of the experiment consisted in using a special substrate inside the boxes which resembles the soil properties. On 29/01/2020 both boxes were filled with water. The substrate has been completely dry on 19/02/2020. During this period temperature, humidity and soil moisture data were recollected using different sensors. The data are visualized in the following sections.

### Common graphics ###

![subs_temperature_common.png](/graphics/subs_temperature_common.png)
![subs_temperature_common_feb7_feb9.png](/graphics/subs_temperature_common_subset.png)
![subs_humidity_common.png](/graphics/subs_humidity_common.png)
![subs_humidity_common_feb7_feb9.png](/graphics/subs_humidity_common_subset.png)
![subs_sm_common.png](/graphics/subs_sm_common.png)

Take heed that the samples _mkr_0_ and and _mkr_2_ are placed in the same box and _mkr_1_ is placed in different box.

### Soil Moisture per Node ###

![subs_sm_whisper_node.png](/graphics/subs_sm_whisper_node.png)
![subs_sm_esp32.png](/graphics/subs_sm_esp32.png)
![subs_sm_mkr1000.png](/graphics/subs_sm_mkr1000.png)

### Temperature per Sensor ###

![subs_temperature_dht.png](/graphics/subs_temperature_dht.png)
![subs_temperature_shs85.png](/graphics/subs_temperature_shs85.png)
![subs_temperature_hih8121.png](/graphics/subs_temperature_hih8121.png)

### Humidity per Sensor ###

![subs_humidity_dht.png](/graphics/subs_humidity_dht.png)
![subs_humidity_shs85.png](/graphics/subs_humidity_shs85.png)
![subs_humidity_hih8121.png](/graphics/subs_humidity_hih8121.png)

## Real Soil ##

The second part of the experiment consisted in using the **real soil** recollected near the TI building. On 20/02/2020 both boxes were filled with water (around 200ml each). The sensors data are visualized in the following sections.

### Common graphics ###

![soil_temperature_common.png](/graphics/soil_temperature_common.png)
![soil_temperature_common_feb7_feb9.png](/graphics/soil_temperature_common_subset.png)
![soil_humidity_common.png](/graphics/soil_humidity_common.png)
![soil_humidity_common_feb7_feb9.png](/graphics/soil_humidity_common_subset.png)
![soil_sm_common.png](/graphics/soil_sm_common.png)

Take heed that the samples _mkr_0_ and and _mkr_2_ are placed in the same box and _mkr_1_ is placed in different box.

### Soil Moisture per Node ###

![soil_sm_whisper_node.png](/graphics/soil_sm_whisper_node.png)
![soil_sm_esp32.png](/graphics/soil_sm_esp32.png)
![soil_sm_mkr1000.png](/graphics/soil_sm_mkr1000.png)

### Temperature per Sensor ###

![soil_temperature_dht.png](/graphics/soil_temperature_dht.png)
![soil_temperature_shs85.png](/graphics/soil_temperature_shs85.png)
![soil_temperature_hih8121.png](/graphics/soil_temperature_hih8121.png)

### Humidity per Sensor ###

![soil_humidity_dht.png](/graphics/soil_humidity_dht.png)
![soil_humidity_shs85.png](/graphics/soil_humidity_shs85.png)
![soil_humidity_hih8121.png](/graphics/soil_humidity_hih8121.png)

## Data Analysis ##

This section can be dedicated to further analysis as RMSE, norm, etc.
