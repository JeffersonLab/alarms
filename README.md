# alarms

```
NOTE: This repo is legacy as production data is stored in an Oracle database.  This repo provides good test data though.
```

This repository contains alarm definitions for [JAWS](https://github.com/JeffersonLab/jaws) for use at Jefferson Lab.  Alarms are defined by their registration class record and their registration instance record.  An `Effective Registration = Alarm Class + Alarm Instance`.  This is useful because an alarm class (type) generally shares the same rationale and corrective action (and potentially other fields) for hundreds or even thousands of instances.


Records are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding) of either the [Alarm](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jaws_libp/avro/schemas/Alarm.avsc) or [AlarmAction](https://github.com/JeffersonLab/jaws-libp/blob/main/src/jaws_libp/avro/schemas/AlarmAction.avsc) schema.  This format is easily imported via [set-alarm](https://jeffersonlab.github.io/jaws-libp/v5.0.0/_autosummary/jaws_libp.scripts.client.set_alarm.html#module-jaws_libp.scripts.client.set_alarm) and [set-action](https://jeffersonlab.github.io/jaws-libp/v5.0.0/_autosummary/jaws_libp.scripts.client.set_action.html#module-jaws_libp.scripts.client.set_action) scripts.
