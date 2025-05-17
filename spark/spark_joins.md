# Joins

## Inner Join example

```java
Column.joinExpression = personDF.col("graduate_program")
    .equalTo(graduateProgramDF.col("id"));
Dataset<Row> joined = personDF.join(graduateProgramDF, joinExpression);
joined.show();
```

## Outer Join example

```java
Column joinExpression = personDF.col("graduate_program")
    .equalTo(graduateProgramDF.col("id"));
// note to use of 'outer' as the type
Dataset<Row> outerJoined = personDF.join(graduateProgramDF, 
    joinExpression, "outer");
outerJoined.show();
```
