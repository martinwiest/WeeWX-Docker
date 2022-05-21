## README for using a SDR-Receiver to capture weatherdata

### Requirement:
- SDR-USB-Dongle and activated device setting in docker-compose.yml 

### 1. Test the receiving of packet from the sensors of your station.

Inside container:

To listen on the frequency 868.3M:

    rtl_433 -f 868.3M -F json 

Read the manual of your station to know what frequency your station uses

### Second Step: Try caputure packet with the weewx-sdr driver:

Working cmd line for Bresser 5:1 Comfort Weather Station on frequenzy 868.3:

    PYTHONPATH=/home/weewx/bin python /home/weewx/bin/user/sdr.py --cmd="rtl_433 -M utc -F json -f 868.3M"
Change the frequency in the cmd-line to your needs.

### Third Step: Make a map for weewx conf:

#### Example - Output from my station from the second step:

out: ['{"time" : "2022-05-15 21:40:36", "model" : "Bresser-6in1", "id" : 555747563, "channel" : 0, "battery_ok" : 1, "temperature_C" : 19.700, "humidity" : 44, "sensor_type" : 1, "wind_max_m_s" : 0.000, "wind_avg_m_s" : 0.000, "wind_dir_deg" : 45, "mic" : "CRC"}\n']
parsed: {'dateTime': 1652650836, 'usUnits': 17, 'temperature.555747563.Bresser6in1Packet': 19.7, 'humidity.555747563.Bresser6in1Packet': 44.0, 'wind_dir.555747563.Bresser6in1Packet': 45.0, 'wind_gust.555747563.Bresser6in1Packet': 0.0, 'wind_speed.555747563.Bresser6in1Packet': 0.0}

That results in folling config block in my weewx.conf:

##############################################################################
[SDR]

    driver = user.sdr
    cmd = /usr/bin/rtl_433 -M utc -f 868.3M -R 172 -F json

[[sensor_map]]
    outTemp = temperature.555747563.Bresser6in1Packet

    outHumidity = humidity.555747563.Bresser6in1Packet

    windSpeed = wind_speed.555747563.Bresser6in1Packet

    windDir = wind_dir.555747563.Bresser6in1Packet

    windGust = wind_gust.555747563.Bresser6in1Packet

    rain_total = rain_total.555747563.Bresser6in1Packet

    log_unknown_sensors = True

    log_unmapped_sensors = True

[[deltas]]
    rain = rain_total
##############################################################################
 


### Source i got helpfull information from:

[Sensor Mapping with Bresser5in1](https://groups.google.com/g/weewx-user/c/llhPMEcf7iY)
