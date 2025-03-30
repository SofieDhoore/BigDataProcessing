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

```
console
PS C:\Users\sofie\Opleiding TIAO\2 Big Data Processing\BigDataProcessing\spark> docker cp spark-submit.sh spark-master:/spark/
Successfully copied 2.56kB to spark-master:/spark/
```

`docker cp log4j.properties spark-master:/spark/`

## Connecting to Spark Web Interface

Go to `http://localhost:18080` with a firefox browser and got to `http://spark-master:8080` within that browser.

Now you can run the Pi-application by this command:

`./spark-submit.sh org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.12-3.3.0.jar`
