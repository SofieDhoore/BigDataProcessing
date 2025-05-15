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
