library(ggplot2)
library(scales)   # to access breaks/formatting functions
library(gridExtra) # for arranging plots
library(lubridate) # for working with dates

# put here the repo location
setwd('D:/std_folders/OneDrive/??????????????????/SM2DSBOC.data')

#clean data frame from NA's
rm_nas <- function (df) {
  row.has.na <- apply(df, 1, function(x){any(is.na(x))})
  # show number of rows with NAs
  # sum(row.has.na)
  df <- df[!row.has.na,]
  return (df)
}

rm_lt <- function (df, col_name, val) {
  rows <- df[col_name] > val
  # show number of rows with NAs
  # sum(row.has.na)
  return (df[rows,])
}

rm_gt <- function (df, col_name, val) {
  rows <- df[col_name] < val
  # show number of rows with NAs
  # sum(row.has.na)
  return (df[rows,])
}

# Visualize data
visualize_data <- function(prefix, data_esp, data_mkr, data_wis, trg, trs) {
  # common data graphics
  # Temperature
  com.t <- data.frame(time = c(data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time, data_wis$time), temperature = c(data_esp$dht11_temp, data_mkr$dht22_temp, data_mkr$shs85_temp, data_mkr$hih8121_temp, data_wis$dht22_temp, data_wis$shs85_temp, data_wis$hih8121_temp),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("shs85_m", length(data_mkr$epoch)), rep("hih8181_m", length(data_mkr$epoch)),  rep("dht22_w", length(data_wis$epoch)), rep("shs85_w", length(data_wis$epoch)), rep("hih8121_w", length(data_wis$epoch))  ))
  com.t <- rm_lt(com.t, "temperature", 0)
  ggplot(com.t, aes(x = com.t$time, y = temperature)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Temperature (C)") +
    ggtitle("Temperature")
  ggsave(paste("graphics/",prefix,"_temperature_common.png", sep = ""), width = 9, height = 4.2)
  
  
  # Temperature subset per hour
  ggplot(com.t, aes(x = com.t$time, y = temperature)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "6 hours", date_labels = "%H:%M", limit = trs) +
    xlab("Date") + ylab("Temperature (C)") +
    ggtitle(paste("Temperature subset", trs[1], trs[2]))
  ggsave(paste("graphics/",prefix,"_temperature_common_subset.png", sep = ""), width = 9, height = 4.2)
  
  # Humidity
  com.h <- data.frame(time = c(data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time, data_wis$time), humidity = c(data_esp$dht11_hum, data_mkr$dht22_hum, data_mkr$shs85_hum, data_mkr$hih8121_hum, data_wis$dht22_hum, data_wis$shs85_hum, data_wis$hih8121_hum),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("shs85_m", length(data_mkr$epoch)), rep("hih8181_m", length(data_mkr$epoch)),  rep("dht22_w", length(data_wis$epoch)), rep("shs85_w", length(data_wis$epoch)), rep("hih8121_w", length(data_wis$epoch))  ))
  com.h <- rm_lt(com.h, "humidity", 0)
  ggplot(com.h, aes(x = com.h$time, y = humidity)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Humidity (RH)") +
    ggtitle("Humidity")
  ggsave(paste("graphics/",prefix,"_humidity_common.png", sep = ""), width = 9, height = 4.2)
  
  # Humidity subset per hour
  ggplot(com.h, aes(x = com.h$time, y = humidity)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "6 hours", date_labels = "%H:%M", limit = trs) +
    xlab("Date") + ylab("Humidity (RH)") +
    ggtitle(paste("Humidity subset", trs[1], trs[2]))
  ggsave(paste("graphics/",prefix,"_humidity_common_subset.png", sep = ""), width = 9, height = 4.2)
  
  # Soil Moisutre. Neet to be driven to the same scale
  # ESP32 ADC 12 bits, Whisper Node (ATmega328p) - 10 bits, MKR1000 I2C connected ADC - 16 bits.
  com.sm <- data.frame(time = c(data_esp$time, data_esp$time, data_mkr$time, data_mkr$time, data_mkr$time, data_wis$time, data_wis$time), soil_moisture = c(data_esp$sm_0/4, data_esp$sm_1/4, data_mkr$sm_0/15, data_mkr$sm_1/16, data_mkr$sm_2/16, data_wis$sm_0, data_wis$sm_1),  sensor=c(rep("esp_0", length(data_esp$epoch)), rep("esp_1", length(data_esp$epoch)), rep("mkr_0", length(data_mkr$epoch)), rep("mkr_1", length(data_mkr$epoch)), rep("mkr_2", length(data_mkr$epoch)),  rep("wis_0", length(data_wis$epoch)), rep("wis_1", length(data_wis$epoch))  ))
  com.sm <- rm_gt(com.sm, "soil_moisture", 2000)
  ggplot(com.sm, aes(x = com.sm$time, y = soil_moisture)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Soil Moisture (raw)") +
    ggtitle("Soil Moisture (common scale)")
  ggsave(paste("graphics/",prefix,"_sm_common.png", sep = ""), width = 9, height = 4.2)
  
  
  # soil moisture per node gparhics
  # whisper Node
  com.sm.wis <- data.frame(time = c(data_wis$time, data_wis$time), soil_moisture = c(data_wis$sm_0, data_wis$sm_1),  sensor=c(rep("wis_0", length(data_wis$epoch)), rep("wis_1", length(data_wis$epoch))  ))
  ggplot(com.sm.wis, aes(x = com.sm.wis$time, y = soil_moisture)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Soil Moisture (raw)") +
    ggtitle("Soil Moisture per node - whisper Node")
  ggsave(paste("graphics/",prefix,"_sm_whisper_node.png", sep = ""), width = 9, height = 4.2)
  
  com.sm.esp <- data.frame(time = c(data_esp$time, data_esp$time), soil_moisture = c(data_esp$sm_0, data_esp$sm_1),  sensor=c(rep("esp_0", length(data_esp$epoch)), rep("esp_1", length(data_esp$epoch)))  )
  ggplot(com.sm.esp, aes(x = time, y = soil_moisture)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Soil Moisture (raw)") +
    ggtitle("Soil Moisture per node - ESP32")
  ggsave(paste("graphics/",prefix,"_sm_esp32.png", sep = ""), width = 9, height = 4.2)
  
  com.sm.mkr <- data.frame(time = c(data_mkr$time, data_mkr$time, data_mkr$time), soil_moisture = c(data_mkr$sm_0, data_mkr$sm_1, data_mkr$sm_2),  sensor=c(rep("mkr_0", length(data_mkr$epoch)), rep("mkr_1", length(data_mkr$epoch)), rep("mkr_2", length(data_mkr$epoch)))  )
  com.sm.mkr <- rm_gt(com.sm.mkr, "soil_moisture", 20000)
  ggplot(com.sm.mkr, aes(x = time, y = soil_moisture)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Soil Moisture (raw)") +
    ggtitle("Soil Moisture per node - MKR1000")
  ggsave(paste("graphics/",prefix,"_sm_mkr1000.png", sep = ""), width = 9, height = 4.2)
  
  # temperature per sensor graphics
  com.t.dht <- data.frame(time = c(data_esp$time, data_mkr$time, data_wis$time), temperature = c(data_esp$dht11_temp, data_mkr$dht22_temp, data_wis$dht22_temp),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("dht22_w", length(data_wis$epoch)))  )
  com.t.dht <- rm_lt(com.t.dht, "temperature", 0)
  ggplot(com.t.dht, aes(x = time, y = temperature)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Temperature (C)") +
    ggtitle("Temperature per sensor family - DHT")
  ggsave(paste("graphics/",prefix,"_temperature_dht.png", sep = ""), width = 9, height = 4.2)
  
  com.t.shs <- data.frame(time = c(data_mkr$time, data_wis$time), temperature = c(data_mkr$shs85_temp, data_wis$shs85_temp),  sensor=c(rep("shs85_m", length(data_mkr$epoch)), rep("shs85_w", length(data_wis$epoch)))  )
  com.t.shs <- rm_lt(com.t.shs, "temperature", 0)
  ggplot(com.t.shs, aes(x = time, y = temperature)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Temperature (C)") +
    ggtitle("Temperature per sensor family - SHS85")
  ggsave(paste("graphics/",prefix,"_temperature_shs85.png", sep = ""), width = 9, height = 4.2)
  
  com.t.hih <- data.frame(time = c(data_mkr$time, data_wis$time), temperature = c(data_mkr$hih8121_temp, data_wis$hih8121_temp),  sensor=c(rep("hih8181_m", length(data_mkr$epoch)),  rep("hih8121_w", length(data_wis$epoch)) ))
  com.t.hih <- rm_lt(com.t.hih, "temperature", 0)
  ggplot(com.t.hih, aes(x = time, y = temperature)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Temperature (C)") +
    ggtitle("Temperature per sensor family - HIH8121")
  ggsave(paste("graphics/",prefix,"_temperature_hih8121.png", sep = ""), width = 9, height = 4.2)
  
  # humidity per sensor graphics
  com.h.dht <- data.frame(time = c(data_esp$time, data_mkr$time, data_wis$time), humidity = c(data_esp$dht11_hum, data_mkr$dht22_hum, data_wis$dht22_hum),  sensor=c(rep("dht11", length(data_esp$epoch)), rep("dht22_m", length(data_mkr$epoch)), rep("dht22_w", length(data_wis$epoch)))  )
  com.h.dht <- rm_lt(com.h.dht, "humidity", 0)
  ggplot(com.h.dht, aes(x = time, y = humidity)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Humiduty (RH)") +
    ggtitle("Humidity per sensor family - DHT")
  ggsave(paste("graphics/",prefix,"_humidity_dht.png", sep = ""), width = 9, height = 4.2)
  
  com.h.shs <- data.frame(time = c(data_mkr$time, data_wis$time), humidity = c(data_mkr$shs85_hum, data_wis$shs85_hum),  sensor=c(rep("shs85_m", length(data_mkr$epoch)), rep("shs85_w", length(data_wis$epoch)))  )
  com.h.shs <- rm_lt(com.h.shs, "humidity", 0)
  ggplot(com.h.shs, aes(x = time, y = humidity)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Humiduty (RH)") +
    ggtitle("Humidity per sensor family - SHS85")
  ggsave(paste("graphics/",prefix,"_humidity_shs85.png", sep = ""), width = 9, height = 4.2)
  
  com.h.hih <- data.frame(time = c(data_mkr$time, data_wis$time), humidity = c(data_mkr$hih8121_hum, data_wis$hih8121_hum),  sensor=c(rep("hih8181_m", length(data_mkr$epoch)),  rep("hih8121_w", length(data_wis$epoch)) ))
  com.h.hih <- rm_lt(com.h.hih, "humidity", 0)
  ggplot(com.h.hih, aes(x = time, y = humidity)) + 
    geom_line(aes(color=sensor), size=1.2) +
    scale_x_datetime(date_breaks = "2 days", date_labels = "%d %b", limit = trg) +
    xlab("Date") + ylab("Humuduty (RH)") +
    ggtitle("Humidity per sensor family - HIH8121")
  ggsave(paste("graphics/",prefix,"_humidity_hih8121.png", sep = ""), width = 9, height = 4.2)
}

analyze <- function(prefix, trg, trs) {
  data_esp <- read.csv(paste("data/",prefix,"_data_esp32.csv", sep = ""), stringsAsFactors=FALSE)
  data_mkr <- read.csv(paste("data/",prefix,"_data_mkr1000.csv", sep = ""), stringsAsFactors=FALSE)
  data_wis <- read.csv(paste("data/",prefix,"_data_whisper_node.csv", sep = ""), stringsAsFactors=FALSE)
  
  # clean NAs
  data_esp <- rm_nas(data_esp)
  data_mkr <- rm_nas(data_mkr)
  data_wis <- rm_nas(data_wis)
  
  #clean outliers
  #data_esp <- rm_lt(data_esp, "temp_dht11", 0)
  
  
  # Create POSIX data for correct timeseries visualization
  data_esp$time <- as.POSIXct(data_esp$timestamp, format="%d/%m/%Y %H:%M:%S")
  data_mkr$time <- as.POSIXct(data_mkr$timestamp, format="%d/%m/%Y %H:%M:%S")
  data_wis$time <- as.POSIXct(data_wis$timestamp, format="%d/%m/%Y %H:%M:%S")
  
  visualize_data(prefix, data_esp, data_mkr, data_wis, trg, trs)
}

# analyze soil moisture data from soil and substrate


# general time range for visualization
trg <- c(as.POSIXct("2020-31-01", format="%Y-%d-%m"), as.POSIXct("2020-20-02", format="%Y-%d-%m"))
# subset time range
trs <- c(as.POSIXct("2020-07-02", format="%Y-%d-%m"), as.POSIXct("2020-09-02", format="%Y-%d-%m"))

analyze("subs", trg, trs)


# general time range for visualization
trg <- c(as.POSIXct("2020-21-02", format="%Y-%d-%m"), as.POSIXct("2020-09-03", format="%Y-%d-%m"))
# subset time range
trs <- c(as.POSIXct("2020-03-03", format="%Y-%d-%m"), as.POSIXct("2020-05-03", format="%Y-%d-%m"))

analyze("soil", trg, trs)



# do some numerical analysis (rmse[select reference])...

