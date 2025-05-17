# Spark Structured Streaming

## Defining a Streaming Query

### Define Input Sources

```java
// StructuredStreamingExample1.java

SparkSession spark = SparkSession.builder(). // as before

Dataset<Row> lines = spark.readStream()
  .format("socket")               // read from socket
  .option("host", "localhost")    // obvious options
  .option("port", 9999)
  .load();                        // load stream into DataFrame
```
