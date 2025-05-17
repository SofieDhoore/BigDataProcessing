# Spark SQL API

## SQL API: Example

```java
result = df.select(”year”, ”subject”, ”score”).groupBy(”year”,”subject”)
    .agg(max(”score”).alias(”max”),
         min(”score”).alias(”min”),
         round(avg(”score”),2).alias(”average”));
```

```sql
SELECT year, subject, MAX(score) AS max, MIN(score) AS min,
        ROUND(AVG(score), 2) AS average
FROM student_tbl
GROUP BY year, subject
```

```java
public static void main(String[] args) { // class SqlExample1
     // Create Spark Session
    SparkSession spark = // as before

    Dataset<Row> df = spark.read(). .. // as before students.csv

    // Register DataFrame as temporary view.
    // Choose any name you want for this view.
    df.createOrReplaceTempView(”student_tbl”);

    // execute SQL-statements on the SparkSession object
    Dataset<Row> results = spark.sql(
      ”SELECT year, subject, MAX(score) AS max, ”
      + ”MIN(score) AS min, ROUND(AVG(score), 2) AS average ”
      + ”FROM student_tbl ”
      + ”GROUP BY year, subject”);

    results.show();
}
```

## User Defined Function in SQL

```java
public static void main(String[] args) { // class UDFExample2
    SparkSession spark = // as before

    Dataset<Row> df = spark.read(). .. // as before students.csv

    df.createOrReplaceTempView(”student_tbl”);

    spark.udf().register(”hasPassed”, /* See previous slides */)

    // Use the hasPassed UDF as a regular SQL function
    Dataset<Row> result = spark.sql(
      ”SELECT subject, year, grade, hasPassed(grade) AS has_passed ”
      + ”FROM student_tbl”);

    result.show(5);
}
```

## Join in SQL

```java
// in SqlJoinExample.java
// Register temporary views
personDF.createOrReplaceTempView(”person_tbl”);
graduateProgramDF.createOrReplaceTempView(”graduate_pgm_tbl”);
statusDF.createOrReplaceTempView(”status_tbl”);

// inner join
Dataset<Row> joined = spark.sql(”SELECT * FROM ”
    + ” person_tbl JOIN graduate_pgm_tbl”
    + ” ON person_tbl.graduate_program = graduate_pgm_tbl.id”);

// outer join
Dataset<Row> joinedOuter = spark.sql(”SELECT * FROM ”
    + ” person_tbl FULL OUTER JOIN graduate_pgm_tbl”
    + ” ON person_tbl.graduate_program = graduate_pgm_tbl.id”);
```
