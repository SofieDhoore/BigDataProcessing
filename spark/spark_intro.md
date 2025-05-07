# Spark introduction

## Inspecting Spark's Physical Plan

```java
// read a Dataframe --> See later
Dataset<Row> flightData2015 = spark.read()
        .option("header", true)
        .option("inferschema", true)
        .csv("src/main/resources/2015-summary.csv");
// sort on the column "count" and show the physical plan
flightData2015.sort("count").explain();

List<Row> result = flightData2015.sort("count").takeAsList(3);
```

Let's set a number of shuffle partitions to 5 to perform a grouping operation.

```java
// Set 5 output partitions for shuffling
spark.conf().set("spark.sql.shuffle.partitions", "5");

flightData2015.groupby("DEST_COUNTRY_NAME").count().explain();
```

A longer example

```java
flightData2015
  .groupBy("DEST_COUNTRY_NAME")
  .sum("count")
  .withColumnRenamed("sum(count)", "destination_total")
  .sort(desc("destination_total"))
  .limit(5)
  .explain();
```
