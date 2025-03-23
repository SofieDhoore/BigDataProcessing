#!/bin/bash

# Usage: ./spark-submit.sh <class> <jar>

# See: https://stackoverflow.com/questions/42230235/spark-submit-how-to-specify-log4j-proper
# See: https://stackoverflow.com/questions/1537673/how-do-i-forward-parameters-to-other-comm

log4j_setting="-Dlog4j.configuration=file:log4j.properties"


./bin/spark-submit \
  --conf "spark.driver.extraJavaOptions=${log4j_setting}" \
  --conf "spark.executor.extraJavaOptions=${log4j_setting}" \
  --conf spark.eventLog.enabled=true \
  --conf spark.eventLog.dir=hdfs://namenode:9000/eventlogging \
  --files ./log4j.properties \
  --class $1 --master spark://spark-master:7077 $2 ${@:3} \