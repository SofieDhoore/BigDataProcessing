# Spark installation & exercises

Go to the right directory: `cd spark`

Start the yml-file: `docker compose -f docker-compose-no-yarn.yml up -d`

Inspecting the docker containers: `docker ps`

## Running an example application

Log in to the spark master node: `docker exec -it spark-master bash`

Go to the spark directory: `cd /spark`

Submit a spark application to the cluster to calculate pi:

`./bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://spark-master:7077 examples/jars/spark-examples_2.12-3.3.0.jar`

## Making submitting easier

Go to the bin directory: `cd bin`

Open a new terminal in the directory where the files to copy are located.

`docker cp spark-submit.sh spark-master:/spark/`

```console
PS C:\Users\sofie\Opleiding TIAO\2 Big Data Processing\BigDataProcessing\spark> docker cp spark-submit.sh spark-master:/spark/
Successfully copied 2.56kB to spark-master:/spark/
```

`docker cp log4j.properties spark-master:/spark/`

## Connecting to Spark Web Interface

Go to `http://localhost:18080` with a firefox browser and got to `http://spark-master:8080` within that browser.

Now you can run the Pi-application by this command:

`./spark-submit.sh org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.12-3.3.0.jar`

```console
bash-5.0# ./spark-submit.sh org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.12-3.3.0.jar
25/04/06 08:49:09 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Pi is roughly 3.1356556782783915
```

## Running a History Server

NOTE: You will have to do this every time when you shut down the container.

Go to the directory conf: `cd conf`

Make a new file with a new line: `echo spark.eventLog.enabled true > spark-defaults.conf`

Add a second line to the file: `echo spark.eventLog.dir hdfs://namenode:9000/eventlogging >> spark-defaults.conf`

And a third line: `echo spark.history.fs.logDirectory hdfs://namenode:9000/eventlogging >> spark-defaults.conf`

If you made a typo, open the file with: `vi spark-defaults.conf`, to save the file, press 'ESC' and then: `:wq`

Go one directory back with: `cd ..`, check if you are in the spark-directory: `pwd`

Start the history server: `./sbin/start-history-server.sh`

```console
bash-5.0# ./sbin/start-history-server.sh
starting org.apache.spark.deploy.history.HistoryServer, logging to /spark/logs/spark--org.apache.spark.deploy.history.HistoryServer-1-feaa707d5f97.out
```

Within firefox you can go to the history server by `spark-master:18080`

## Shutting down the cluster

`docker compose -f docker-compose-no-yarn.yml down`
