# registered-alarms
This repository contains alarm definitions for the [kafka-alarm-system](https://github.com/JeffersonLab/kafka-alarm-system) for use at Jefferson Lab.  
They are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding).  This format is easily imported via [script](https://github.com/JeffersonLab/kafka-alarm-system/wiki/Scripts-Reference#import-registrations).
