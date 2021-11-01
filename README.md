# alarms
This repository contains alarm definitions for [JAWS](https://github.com/JeffersonLab/jaws) for use at Jefferson Lab.  Alarms are defined by their class record and their registration record.


Records are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding) of either the [AlarmRegistration](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jlab_jaws/avro/schemas/AlarmRegistration.avsc) or [AlarmClass](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jlab_jaws/avro/schemas/AlarmClass.avsc) schema.  This format is easily imported via [set-registration](https://github.com/JeffersonLab/jaws/wiki/Scripts-Reference#set-registration) and [set-class](https://github.com/JeffersonLab/jaws/wiki/Scripts-Reference#set-class) scripts.
