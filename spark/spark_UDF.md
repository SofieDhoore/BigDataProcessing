# User Defined Functions

## Example (Registering)

```java
// Register the UDF:
// 1. udf() fives access to UDFRegistration
// 2. register method has three arguments:
//    a. The name you will give to this method
//    b. The actual implementation (in this case using lambda-syntax)
//    c. The return type of the method
spark.udf().register(
    "hasPassed",
    (String grade) -> { return grade.startsWith("A") ||
        grade.startsWith("B") || grade.startsWith("C");
    },
    DataTypes.BooleanType);
```

## Example (Using)

```java
// class UDFExample
SparkSession spark = SparkSession.builder(). // as before

Dataset<Row> df = // as before. students.csv

spark.udf().register("hasPassed", /* previous example */);

df = df.select("subject", "year", "grade") // fewer columns in output
        .withColumn("has_passed",
        functions.call_udf("hasPassed", col("grade")));

df.show(5);
```
