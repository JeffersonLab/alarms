# registered-alarms
This repository contains alarm definitions for [JAWS](https://github.com/JeffersonLab/jaws) for use at Jefferson Lab.  
They are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding) of the [registered-alarms schema](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jlab_jaws/avro/subject_schemas/registered-alarms-value.avsc).  This format is easily imported via [script](https://github.com/JeffersonLab/jaws/wiki/Scripts-Reference#set-registered-alarms).
