# Spark Dataframes

## The Dataframe API: example

```java
public static void(String[] args){ // class DataFrameExample1
  SparkSession spark = SparkSession.builder()
    .appName("example").master("local[*]")
    .getOrCreate();

  // Create some in memory data
  List<Row> inMemory = new ArrayList<>();
  inMemory.add(RowFactory.create("Brooke", 20));
  inMemory.add(RowFactory.create("Brooke", 25));
  inMemory.add(RowFactory.create("Denny", 31));
  inMemory.add(RowFactory.create("Jules", 30));
  inMemory.add(RowFactory.create("TD", 35));

  // The data types of this data
  List<StructField> fields = Arrays.aslist(
    DataTypes.createStructField("name", DataTypes.StringType, true),
    DataTypes.createStructField("age", DataTypes.StringType, true)
  );

  // Create the schema
  StructType schema = DataTypes.createStructType(fields);

  // Create the DataFrame
  Dataset<Row> df = spark.createDataFrame(inMemory, schema);

  // Work with the DataFrame
  Dataset<Row> result = df.groupBy("name").avg("age");

  // Show the result
  result.show();

  spark.close():
}
```

## Reading in a DataFrame

```java
public static void main(String[] args){ // class DataFrameReadExample
  // Create Spark Session
  SparkSession spark = // as before

  // The data types of this data
  List<StructField> fields = // as before

  // Create the schema (as before)
  StructType schema = DataTypes.createStructType(fields);

  // Read the DataFrame
  Dataset<Row> df = spark.read()
    .option("header", true) //file has a header
    .schema(schema)
    .csv("src/main/resources/small.csv");

  // Work with the DataFrame and close SparkSession (as before)
}
```

## Inferring the Schema

```java
// Read the DataFrame
Dataset<Row> df = spark.read()
  .option("header", true) // file has a header
  .option("inferschema", true) // infer the schema
  .option("samplingRatio", 0.0001) // use small sample to infer schema
  .csv("src/main/resources/small.csv");
```

## Writing DataFrames

```java
public static void main(String[] args){ // DataFrameWriteExample
  Logger.getLogger("org.apache").setLevel(Level.WARN);

  // Create Spark Session
  SparkSession spark = SparkSession.builder()
    .appName("DataFrameWriteExample").master("local[*]")
    .getOrCreate();

  // Define schema
  List<StructField> fields = Arrays.asList(
    DataTypes.createStructField(
      "student_id", DataTypes.IntegerType, false
    ),
    /* other fields here */
  );

  StructType schema = DataTypes.createStructType(fields);

  // in main
  Dataset<Row> df = spark.read().option("header", true)
    .schema(schema)
    .csv("src/main/resources/students.csv");

  System.out.println("Number of rows: " + df.count());

  String path = "file:///C:/tmp/students";

  // Save the DataFrame to Parquet format
  df.write().format("parquet").mode("overwrite").save(path);

  // Read back in. No need to specify schema when using Parquet
  Dataset<Row> dfParquet = spark.read().parquet(path);

  System.out.println("Number of rows after saving and reading: "
    + dfParquet.count());
  
  spark.close();
}
```

## DataFrame Columns

```java
import org.apache.spark.sql.Column;
import static org.apache.spark.sql.functions.*;

// main
Column name = df.col("name"); // not very useful by itself

// add 1 to all ages. Does not change the DataFrame or Column
df.select(expr("age + 1")).show();
```

## Adding Columns to a DataFrame

```java
import org.apache.spark.sql.Column;
import static org.apache.spark.sql.functions.*;

// in main
Column ageNextYear = expr("age + 1");

// do not forget to reassign
df = df.withColumn("ageNextYear", ageNextYear);
```

```java
public static void main(String[] args) { // class ColumnExample
  Logger.getLogger("org.apache").setLevel(Level.WARN);

  // Create Spark Session
  SparkSession spark = // as before

  // Read the DataFrame
  Dataset<Row> df = // as before (read small.csv)

  // do not forget to reassign. Chain method calls
  df = df.withColumn("ageNextYear", expr("age + 1"))
          .withColumn("over30", expr("age > 30"));
  df.show();

  spark.close();
}
```

## Projecting Columns

```java
public static void main(String[] args) { // class SelectExample

  // Create Spark Session
  SparkSession spark = SparkSession.builder()
    .appName(”example”).master(”local[*]”)
    .getOrCreate();

  // new (larger) dataset
  Dataset<Row> df = spark.read()
    .option(”header”, true)
    .option(”inferschema”, true)
    .option(”sampleRatio”, 0.001)
    .csv(”src/main/resources/students.csv”);

  // df.columns() returns an array of String with the
  // column names
  System.out.println("Prior to selecting columns: "
      + Arrays.toString(df.columns()));

  // only keep three columns
  df = df.select("score", "quarter", "year");

  System.out.println("After selecting columns: "
      + Arrays.toString(df.columns()));
  
  spark.close();
}
