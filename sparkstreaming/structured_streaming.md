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

### Transform data

```java
// StructuredStreamingExample1.java

Sparksession spark = Sparksession.builder(). // as before

Dataset<Row> lines = spark.readStream(). // previous code

// Regular  (stateless) transformation: split line, put each word in
// new record (explode).
Dataset<Row> words = lines.select(
    explode(split(col("value"), "\\s")).as("word"));

// Regular (stateful) transformation
Dataset<Row> counts = words.groupBy("word").count();
```

### Define Output Sink/Mode

```java
// StructuredStreamingExample1.java

Dataset<Row> counts = ... // result from previous part

DatasStreamWriter<Row> writer = counts.writeStream()
  .format("console") // write to the console
  .outputMode(OutputMode.Complete()) // write everything
  // more code to follow in next steps
```
