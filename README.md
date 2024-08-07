# alarms

```
NOTE: This repo is legacy as production data is stored in an Oracle database.  This repo provides good test data though.
```

This repository contains alarm definitions for [JAWS](https://github.com/JeffersonLab/jaws) for use at Jefferson Lab.  Alarms are defined by their registration class record and their registration instance record.  An `Effective Registration = Alarm Class + Alarm Instance`.  This is useful because an alarm class (type) generally shares the same rationale and corrective action (and potentially other fields) for hundreds or even thousands of instances.


Records are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding) of either the [AlarmInstance](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jaws_libp/avro/schemas/AlarmInstance.avsc) or [AlarmClass](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jaws_libp/avro/schemas/AlarmClass.avsc) schema.  This format is easily imported via [set-instance](https://jeffersonlab.github.io/jaws/4.5.2/_autosummary/jaws_scripts.client.set_instance.html#module-jaws_scripts.client.set_instance) and [set-class](https://jeffersonlab.github.io/jaws/4.5.2/_autosummary/jaws_scripts.client.set_class.html) scripts.
