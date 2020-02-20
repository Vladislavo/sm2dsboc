library(ggplot2)
library(scales)   # to access breaks/formatting functions
library(gridExtra) # for arranging plots
library(lubridate) # for working with dates

# put here the repo location
setwd('D:/std_folders/OneDrive/??????????????????/SM2DSBOC.data')

data_esp <- read.csv('data/data_esp32.csv', stringsAsFactors=FALSE)
data_mkr <- read.csv('data/data_mkr1000.csv', stringsAsFactors=FALSE)
data_wis <- read.csv('data/data_wisper_node.csv', stringsAsFactors=FALSE)

#clean data from NA's
row.has.na <- apply(data_esp, 1, function(x){any(is.na(x))})
sum(row.has.na)
data_esp <- data_esp[!row.has.na,]

row.has.na <- apply(data_mkr, 1, function(x){any(is.na(x))})
sum(row.has.na)
data_mkr <- data_mkr[!row.has.na,]

row.has.na <- apply(data_wis, 1, function(x){any(is.na(x))})
sum(row.has.na)
data_wis <- data_wis[!row.has.na,]

# Create POSIX data for correct visualization
data_esp$time <- as.POSIXct(data_esp$timestamp, format="%d/%m/%Y %H:%M:%S")
data_mkr$time <- as.POSIXct(data_mkr$timestamp, format="%d/%m/%Y %H:%M:%S")
data_wis$time <- as.POSIXct(data_wis$timestamp, format="%d/%m/%Y %H:%M:%S")


# Visualize data

# common data graphics
# Temperature
com.t <- data.frame(time = c(data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time, data_wis$time), temperature = c(data_esp$dht11_temp, data_mkr$dht22_temp, data_mkr$shs85_temp, data_mkr$hih8121_temp, data_wis$dht22_temp, data_wis$shs85_temp, data_wis$hih8121_temp),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("shs85_m", length(data_mkr$epoch)), rep("hih8181_m", length(data_mkr$epoch)),  rep("dht22_w", length(data_wis$epoch)), rep("shs85_w", length(data_wis$epoch)), rep("hih8121_w", length(data_wis$epoch))  ))
ggplot(com.t, aes(x = com.t$time, y = temperature)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Temperature (C)") +
  ggtitle("Temperature")
ggsave("graphics/subs_temperature_common.png", width = 9, height = 4.2)

# Temperature subset per hour
ggplot(com.t, aes(x = com.t$time, y = temperature)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "6 hours", date_labels = "%H:%M", limit=c(as.POSIXct("2020-07-02", format="%Y-%d-%m"), as.POSIXct("2020-09-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Temperature (C)") +
  ggtitle("Temperature subset (Feb 7 - Feb 9)")
ggsave("graphics/subs_temperature_common_feb7_feb9.png", width = 9, height = 4.2)

# Humidity
com.h <- data.frame(time = c(data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time, data_wis$time), humidity = c(data_esp$dht11_hum, data_mkr$dht22_hum, data_mkr$shs85_hum, data_mkr$hih8121_hum, data_wis$dht22_hum, data_wis$shs85_hum, data_wis$hih8121_hum),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("shs85_m", length(data_mkr$epoch)), rep("hih8181_m", length(data_mkr$epoch)),  rep("dht22_w", length(data_wis$epoch)), rep("shs85_w", length(data_wis$epoch)), rep("hih8121_w", length(data_wis$epoch))  ))
ggplot(com.h, aes(x = com.h$time, y = humidity)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Humidity (RH)") +
  ggtitle("Humidity")
ggsave("graphics/subs_humidity_common.png", width = 9, height = 4.2)

# Humidity subset per hour
ggplot(com.h, aes(x = com.h$time, y = humidity)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "6 hours", date_labels = "%H:%M", limit=c(as.POSIXct("2020-07-02", format="%Y-%d-%m"), as.POSIXct("2020-09-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Humidity (RH)") +
  ggtitle("Humidity subset (Feb 7 - Feb 9)")
ggsave("graphics/subs_humidity_common_feb7_feb9.png", width = 9, height = 4.2)

# Soil Moisutre
com.sm <- data.frame(time = c(data_esp$time, data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time), soil_moisture = c(data_esp$sm_0, data_esp$sm_1, data_mkr$sm_0, data_mkr$sm_1, data_mkr$sm_2, data_wis$sm_0, data_wis$sm_1),  sensor=c(rep("esp_0", length(data_esp$epoch)), rep("esp_1", length(data_esp$epoch)), rep("mkr_0", length(data_mkr$epoch)), rep("mkr_1", length(data_mkr$epoch)), rep("mkr_2", length(data_mkr$epoch)),  rep("wis_0", length(data_wis$epoch)), rep("wis_1", length(data_wis$epoch))  ))
ggplot(com.sm, aes(x = com.sm$time, y = soil_moisture)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Soil Moisure (raw)") +
  ggtitle("Soil Moisture")
ggsave("graphics/subs_sm_common.png", width = 9, height = 4.2)


# soil moisture per node gparhics
# Wisper Node
com.sm.wis <- data.frame(time = c(data_wis$time, data_wis$time), soil_moisture = c(data_wis$sm_0, data_wis$sm_1),  sensor=c(rep("wis_0", length(data_wis$epoch)), rep("wis_1", length(data_wis$epoch))  ))
ggplot(com.sm.wis, aes(x = com.sm.wis$time, y = soil_moisture)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Soil Moisure (raw)") +
  ggtitle("Soil Moisure per node - Wisper Node")
ggsave("graphics/subs_sm_wisper_node.png", width = 9, height = 4.2)

com.sm.esp <- data.frame(time = c(data_esp$time, data_esp$time), soil_moisture = c(data_esp$sm_0, data_esp$sm_1),  sensor=c(rep("esp_0", length(data_esp$epoch)), rep("esp_1", length(data_esp$epoch)))  )
ggplot(com.sm.esp, aes(x = time, y = soil_moisture)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Soil Moisure (raw)") +
  ggtitle("Soil Moisure per node - ESP32")
ggsave("graphics/subs_sm_esp32.png", width = 9, height = 4.2)

com.sm.mkr <- data.frame(time = c(data_mkr$time, data_mkr$time, data_mkr$time), soil_moisture = c(data_mkr$sm_0, data_mkr$sm_1, data_mkr$sm_2),  sensor=c(rep("mkr_0", length(data_mkr$epoch)), rep("mkr_1", length(data_mkr$epoch)), rep("mkr_2", length(data_mkr$epoch)))  )
ggplot(com.sm.mkr, aes(x = time, y = soil_moisture)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Soil Moisure (raw)") +
  ggtitle("Soil Moisure per node - MKR1000")
ggsave("graphics/subs_sm_mkr1000.png", width = 9, height = 4.2)

# temperature per sensor graphics
com.t.dht <- data.frame(time = c(data_esp$time, data_mkr$time, data_wis$time), temperature = c(data_esp$dht11_temp, data_mkr$dht22_temp, data_wis$dht22_temp),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("dht22_w", length(data_wis$epoch)))  )
ggplot(com.t.dht, aes(x = time, y = temperature)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Temperature (C)") +
  ggtitle("Temperature per sensor family - DHT")
ggsave("graphics/subs_temperature_dht.png", width = 9, height = 4.2)

com.t.shs <- data.frame(time = c(data_mkr$time, data_wis$time), temperature = c(data_mkr$shs85_temp, data_wis$shs85_temp),  sensor=c(rep("shs85_m", length(data_mkr$epoch)), rep("shs85_w", length(data_wis$epoch)))  )
ggplot(com.t.shs, aes(x = time, y = temperature)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Temperature (C)") +
  ggtitle("Temperature per sensor family - SHS85")
ggsave("graphics/subs_temperature_shs85.png", width = 9, height = 4.2)

com.t.hih <- data.frame(time = c(data_mkr$time, data_wis$time), temperature = c(data_mkr$hih8121_temp, data_wis$hih8121_temp),  sensor=c(rep("hih8181_m", length(data_mkr$epoch)),  rep("hih8121_w", length(data_wis$epoch)) ))
ggplot(com.t.hih, aes(x = time, y = temperature)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Temperature (C)") +
  ggtitle("Temperature per sensor family - HIH8121")
ggsave("graphics/subs_temperature_hih8121.png", width = 9, height = 4.2)

# humidity per sensor graphics
com.h.dht <- data.frame(time = c(data_esp$time, data_mkr$time, data_wis$time), humidity = c(data_esp$dht11_hum, data_mkr$dht22_hum, data_wis$dht22_hum),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("dht22_w", length(data_wis$epoch)))  )
ggplot(com.h.dht, aes(x = time, y = humidity)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Humuduty (RH)") +
  ggtitle("Humidity per sensor family - DHT")
ggsave("graphics/subs_humidity_dht.png", width = 9, height = 4.2)

com.h.shs <- data.frame(time = c(data_mkr$time, data_wis$time), humidity = c(data_mkr$shs85_hum, data_wis$shs85_hum),  sensor=c(rep("shs85_m", length(data_mkr$epoch)), rep("shs85_w", length(data_wis$epoch)))  )
ggplot(com.h.shs, aes(x = time, y = humidity)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Humuduty (RH)") +
  ggtitle("Humidity per sensor family - SHS85")
ggsave("graphics/subs_humidity_shs85.png", width = 9, height = 4.2)

com.h.hih <- data.frame(time = c(data_mkr$time, data_wis$time), humidity = c(data_mkr$hih8121_hum, data_wis$hih8121_hum),  sensor=c(rep("hih8181_m", length(data_mkr$epoch)),  rep("hih8121_w", length(data_wis$epoch)) ))
ggplot(com.h.hih, aes(x = time, y = humidity)) + 
  geom_line(aes(color=sensor), size=1.2) +
  scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit=c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))) +
  xlab("Date") + ylab("Humuduty (RH)") +
  ggtitle("Humidity per sensor family - HIH8121")
ggsave("graphics/subs_humidity_hih8121.png", width = 9, height = 4.2)

# do some calculations (rmse[select reference])...

