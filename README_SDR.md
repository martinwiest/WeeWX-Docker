## README for use the SDR Receiver 

###Requirements:

apt install rtl-sdr and rtl-433

rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
--------------------------

### First Step: Try to capture signals from the bresser station with rtl_433

Inside container:

    rtl_433 -f 868.3M -F json

### Second Step: Try caputure packet with the weewx-sdr driver:

    PYTHONPATH=bin python bin/user/sdr.py --cmd="rtl_433 -f 868.3M -F json"

### Third Step: Make a map for weewx conf:

#### Example - Output from my station

out: ['{"time" : "2022-05-15 21:40:36", "model" : "Bresser-6in1", "id" : 555747563, "channel" : 0, "battery_ok" : 1, "temperature_C" : 19.700, "humidity" : 44, "sensor_type" : 1, "wind_max_m_s" : 0.000, "wind_avg_m_s" : 0.000, "wind_dir_deg" : 45, "mic" : "CRC"}\n']
parsed: {'dateTime': 1652650836, 'usUnits': 17, 'temperature.555747563.Bresser6in1Packet': 19.7, 'humidity.555747563.Bresser6in1Packet': 44.0, 'wind_dir.555747563.Bresser6in1Packet': 45.0, 'wind_gust.555747563.Bresser6in1Packet': 0.0, 'wind_speed.555747563.Bresser6in1Packet': 0.0}



        outTemp = temperature.555747563.Bresser6in1Packet

        outHumidity = humidity.555747563.Bresser6in1Packet

        windSpeed = wind_speed.555747563.Bresser6in1Packet

        windDir = wind_dir.555747563.Bresser6in1Packet

        windGust = wind_gust.555747563.Bresser6in1Packet

        rain_total = rain_total.555747563.Bresser6in1Packet

        log_unknown_sensors = True

        log_unmapped_sensors = True

### Source i got helpfull information from:

[Sensor Mapping with Bresser5in1](https://groups.google.com/g/weewx-user/c/llhPMEcf7iY)


