# Soil Moisture, DHT11 & DHT22 Sensors Behavior Observance and Calibration (SM2DSBOC)

The intention of this experiment is to see the behavior of different sensors in different mediums, different ADCs from various MCUs and one external ADC, and contrast results. It is crucial to verify that sensors data will demonstrate consistent outcome to rely on the sensors in future applications.

Although cheap and not certified sensors were used in the experiment, the intention is not to show the sensors' precision but rather that the modes/tendencies are similar.

In the next sections sensors' connections, experiment configuration, and data outcome and analysis are revealed.

## Sensors' Connections  

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

DHT22 and Wisper Node connection
```
        DHT22       Wisper Node
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

SHS85 and HIH8121 are connected to the Wisper Node through the I2C interface.
```
   SHS85 & HIH8121  Wisper Node
        ~────┐     ╔═══~
          VCC├─────╢5V
          SDA├─────╢D18
          SCL├─────╢D19
          GND├─────╢GND
        ~────┘     ╚═══~
```

SHS85 and HIH8121 are connected to the Wisper Node through the I2C interface.

```
   SHS85 & HIH8121  MKR1000
        ~────┐     ╔═══~
          VCC├─────╢5V
          SDA├─────╢11
          SCL├─────╢12
          GND├─────╢GND
        ~────┘     ╚═══~
```

## Experiment configuration.

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

## Data Outcome

First part of the experiment consisted in using a special substrate inside the boxes which resembles the soil properties. On 29/01/2020 both boxes were filled with water. The sensors data is visualized in the following sections.

### Common graphics

![subs_temperature_common.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_temperature_common.png)
![subs_temperature_common_feb7_feb9.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_temperature_common_feb7_feb9.png)
![subs_humidity_common.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_humidity_common.png)
![subs_humidity_common_feb7_feb9.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_humidity_common_feb7_feb9.png)
![subs_sm_common.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_sm_common.png)

### Soil Moisture per Node

![subs_sm_wisper_node.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_sm_wisper_node.png)
![subs_sm_esp32.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_sm_esp32.png)
![subs_sm_mkr1000.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_sm_mkr1000.png)

### Temperature per Sensor

![subs_temperature_dht.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_temperature_dht.png)
![subs_temperature_shs85.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_temperature_shs85.png)
![subs_temperature_hih8121.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_temperature_hih8121.png)

### Humidity per Sensor

![subs_humidity_dht.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_humidity_dht.png)
![subs_humidity_shs85.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_humidity_shs85.png)
![subs_humidity_hih8121.png](https://lorca.act.uji.es/gitlab/vrykov/sm2dsboc/blob/master/graphics/subs_humidity_hih8121.png)

## Data Analysis

This section can be dedicated to further analysis as RMSE, norm, etc.
