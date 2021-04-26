# registered-alarms
This repository contains alarm definitions for [JAWS](https://github.com/JeffersonLab/jaws) for use at Jefferson Lab.  
They are formatted one record per line with each record a Kafka key=value with the value in [AVRO JSON Encoding](https://avro.apache.org/docs/current/spec.html#json_encoding) of the [registered-alarms schema](https://github.com/JeffersonLab/kafka-alarm-system/blob/master/config/subject-schemas/registered-alarms-value.avsc).  This format is easily imported via [script](https://github.com/JeffersonLab/kafka-alarm-system/wiki/Scripts-Reference#set-registered-alarms).

## Developer Notes:

### Column Formatting
The above format is adjusted to a more human readable form using columns with the Linux command:
```
column <file> -t -s "{" -o "{" | column -t -s "," -o "," > <newfile>
```
**Note**: This relies on the fact that JSON ignores whitespace between fields and assumes that the following two characters are not included in any values: `{` and `,`.   You cannot use `:` as a delimiter because that is commonly found inside the pv name field and you cannot use `=` because the key is intepreted up to that symbol so spaces are important before it.

The _rf_ file contains commas in the _screenpath_ field so only the first piece of the column command can safely be used.   The _list-registered.py_ can be used to output nicely formated messages though (once [union qualifier issue](https://github.com/confluentinc/confluent-kafka-python/pull/785) is fixed).

### File Cleanup
Remove quotes from key:
```
sed 's/"//' <file> | sed 's/"//' > <newfile>
```

Collapse spaces (partially reset column formatting):
```
tr -s " " < <file> > <newfile>
```
