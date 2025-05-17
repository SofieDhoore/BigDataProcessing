# Spark Dataframe API

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

## Example using RDD

Inside the Spark shell (using Python)

```python
textFile = sc.textFile("README.md")
textFile.count() #Number of items in this RDD
#124
textFile.first() #First item in this RDD
#u '# Apache Spark'
lineswithSpark = textFile.filter(lambda line: "Spark" in line)
textFile.filter(lambda line: "Spark" in line).count() #How many lines contain "Spark"
#20
```

Same example using Java

```java
package be.hogent.dit.tin;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

public class RDDExample {
  public static void main(String[] args) {
    Logger.getLogger("org.apache").setLevel(Level.WARN);

    /* Create Spark Context */
    SparkConf conf = new SparkConf()
      .setAppName("RDDExample").setMaster("local[*]");
    JavaSparkContext sc = new JavaSparkContext(conf);

    /* Create RDD from a text file */
    JavaRDD<String> textFile = sc.textFile(
      "src/main/resources/README.md");

    System.out.println("Number of lines:" + textFile.count());

    System.out.println("The first line is:" + textFile.first());

    /* Create new RDD consisting of only lines with 'Spark' */
    JavaRDD<String> linesWithSpark = textFile.filter(
      line -> line.contains("Spark"));
    
    System.out.println("Number of lines with 'Spark': " +
      linesWithSpark.count());

    sc.close(); 
  }
}
```

## DataFrame Example

Inside the Spark Shell (using Python)

```python
textFile = spark.read.text("README.md")
textFile.count() # Number of items in this RDD
# 126
textFile.first() # First item in this RDD
# u '# Apache Spark'
linesWithSpark = textFile.filter(textFile.value.contains("Spark"))
linesWithSpark.count()
# 15
textFile.filter(textFile.value.contains("Spark")).count() # How many lines contain "Spark"?
# 15
```

Note: the variable `spark` represents a SparkSession, this is an object that provides the point of entry to interact with the underlying Spark functionality.

Same example using Java

```java
package be.hogent.dit.tin;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;

public class IntroductionDataFrameExample {

    public static void main(String[] args) {
      Logger.getLogger("org.apache").setLevel(Level.WARN);

    // Create Spark Session
      SparkSession spark = SparkSession.builder()
        .appName("IntroductionDataFrameExample")
        .master("local[*]").getOrCreate();

      Dataset<Row> textFile = spark.read().text(
        "src/main/resources/README.md");

      System.out.println("Number of lines: " + textFile.count());

      System.out.println("The first line is: " + textFile.first());

      /* Filter lines containing spark. Note: getString(0) gets the
        first (index 0) element and casts it to a String. */
      Dataset<Row> linesWithSpark = textFile.filter(
        line -> line.getString(0).contains("Spark"));

      System.out.println("Number of lines with 'Spark': " +
        linesWithSpark.count());

      spark.close();
  }
}
```

## Selecting Rows

```java
// class WhereExample
Dataset<Row> df = // as before. students.csv

// Select students with grade "A+"
Dataset<Row> dfAplus = df.select("student_id", "year", "subject", "grade")
                          .where(col("grade").equalTo("A+"));

dfAplus.show(2);

// Select students with grade B in the year 2010 or 2011

Dataset<Row> dfB1011 =
  df.select("student_id", "year", "subject", "grade")
    .where(col("grade").equalTo("B")
          .and(col("year").isin(2010,2011))
          );
dfB1011.show(2);
```

## Removing Duplicate Rows

```java
// Distinct students with grade B in any course the year 2010 or 2011
Dataset<Row> dfDistinct =
  df.select("student_id", "year", "grade")
    .where(col("grade").equalTo("B")
    .and(col("year").isin(2010,2011)))
    .distinct();
```

## Simple Aggregation Example

```java
// class: AggregationExample
Dataset<Row> df = spark.read() .... //students.csv
// Example one: count the number of exams in each year.
//              order the results by count, descending
// df is the Dataframe of students
df.select("year").groupBy("year")
    .count().orderBy(desc("count")).show();
```

## General Aggregations

```java
df.select("year", "subject", "score").groupBy("year", "subject")
    .agg(max("score"), min("score"), avg("socre")).show();
```

```java
df.select("year", "subject", "score").groupBy("year", "subject")
    .agg(max("score").alias("max"), 
    min("score").alias("min"),
    round(avg("socre"), 2).alias("average")).show();
```
