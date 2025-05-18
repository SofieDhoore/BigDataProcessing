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

### Processing details

```java
// StructuredStreamingExample1.java

Dataset<Row> counts = ... // result from previous part

DataStreamWriter<Row> writer = counts.writeStream()
    .format("console") // write to the console
    .outputMode(OutputMode.Complete()) // write everything
    .trigger(Trigger.ProcessingTime(1, TimeUnit.SECONDS)); // every second
```

### Start the Query

```java
// StructuredStreamingExample1.java

Dataset<Row> counts = ... // result from previous part

DataStreamWriter<Row> writer = counts.writeStream()
    .format("console") // write to the console
    .outputMode(OutputMode.Complete()) // write everything
    .trigger(Trigger.ProcessingTime(1, TimeUnit.SECONDS)); // every second

// start execution of writer (non-blocking method call)
StreamingQuery streamingQuery = writer.start();

// Prevent main thread from stopping
try {
  streamingQuery.awaitTermination();
} catch (StreamingQueryException e) {
    e.printStackTrace();
}
```

## Reading from Kafka: Java example

```java
// In main-methode of KafkaReadExample
SparkSession spark = SparkSession.builder(). // as before

final String topic = args[0]; // get topic from command line

Dataset<Row> messages = spark.readStream()
    .format("kafka")
    .option("kafka.bootstrap.servers", BOOTSTRAP_SERVERS)
    .option("subscribe", topic)
    .load();

// Cast the key and the value to Strings
messages = messages
    .withColumn("key", expr("CAST(key AS STRING)"))
    .withColumn("value", expr("CAST(value AS STRING)"));

StreamingQuery query = null;

try {
    query = messages.writeStream()
      .format("console")
      .outputMode(OutputMode.Append())
      .option("checkpointLocation", CHECKPOINT_LOCATION)
      .start();
} catch (TimeoutException e) {
      e.printStackTrace();
}

try {
    query.awaitTermination();
} catch (StreamingQueryException e) {
    e.printStackTrace();
}

spark.close();
```

## Word count based on time interval

```java
// in main-method of WindowedAggregationExample

SparkSession spark = SparkSession.builder() // as before

Dataset<Row> lines = spark.readStream()
    .format("socket")                   // read from socket
    .option("host", "localhost")        // obvious options
    .option("port", 9999)
    .option("includeTimestamp", true)   // add timestamp column
    .load();

// lines DataFrame has columns "value" and "timestamp"
Dataset<Row> output = lines // extract words as before
    .withColumn("word", explode(split(col("value"), "\\s")))
    .select("word", "timestamp")
    .groupBy( // Use window function
        window(col("timestamp"), "10 seconds", "5 seconds"),
        col("word"))
    .count()
    .orderBy(col("window"), col("count"));

StreamingQuery query = null;

try {
    query = output.writeStream()
        .format("console")
        .option("truncate", false)
        .option("numRows", 100)
        .outputMode(OutputMode.Complete())
        .trigger(Trigger.ProcessingTime(5, TimeUnit.SECONDS))
        .start();
} catch (TimeoutException e){
    e printStackTrace():
}

try {
    query.awaitTermination();
} catch (StreamingQueryException e) {
    e.printStackTrace();
}
```

## Watermarking Java Example

```java
// Example from: https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#handling-late-data-and-watermarking

Dataset<Row> words = ... // streaming DataFrame of schema { timestamp: Timestamp, word: String }

// Group the data by window and word and compute the count of each group
Dataset<Row> windowedCounts = words
    .withWatermark("timestamp", "10 minutes") // add watermark!
    .groupBy(
      window(col("timestamp"), "10 minutes", "5 minutes"),
      col("word"))
    .count();
```

## Stream-Static Joins: Java Example

```java
// Example code from https://spark.apache.org/docs/latest/structuredstreaming-programming-guide.html#stream-static-joins

Dataset<Row> staticDf = spark.read(). ...;
Dataset<Row> streamingDf = spark.readStream(). ...;

// inner equi-join with a static DF
streamingDf.join(staticDf, "type");

// left outer join with a static DF
streamingDf.join(staticDf, "type", "left_outer");
```

## Stream-Stream Joins: Java Example

```java
// Example based on book: Learning Spark, Lightning-fast data analytics

Dataset<Row> impressions = spark.readStream(). ...;
Dataset<Row> clicks = spark.readStream(). ...;

// inner equi-join with two streams
Dataset<Row> matched = impressions.join(clicks, "adId");
```

## Keep the State Bounded

```java
import static org.apache.spark.sql.functions.expr;

Dataset<Row> impressions = spark.readStream(). ...
Dataset<Row> clicks = spark.readStream(). ...

// Apply watermarks on event-time columns
Dataset<Row> impressionsWithWatermark =
    impressions.withWatermark("impressionTime", "2 hours");
Dataset<Row> clicksWithWatermark =
    clicks.withWatermark("clickTIme", "3 hours");

// Join with event-time constraints
impressionsWithWatermark.join(
    clicksWithWatermark,
      expr(
        "clickAdId = impressionAdId AND " +
        "clickTime >= impressionTime AND " +
        "clickTIme <= impressionTime + interval 1 hour "
      )
);
```

## Outer joins with watermarking

```java
impressionsWithWatermark.join(
    clickWithWatermark,
    expr(
      "clickAdId = impressionAdId AND " +
        "clickTime >= impressionTime AND " +
        "clickTIme <= impressionTime + interval 1 hour "
    ),
    "leftOuter" // specify the join type
);
```
