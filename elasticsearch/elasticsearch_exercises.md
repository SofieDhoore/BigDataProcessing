# Elastic Search Exercises

## Create the index

Create an index called the-big-data-theory with the following mappings:

```json
PUT /the-big-data-theory
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  },
  "mappings": {
        "properties": {
            "title": { "type": "text" },
            "synopsis": { "type": "text" },
            "first_air_date": { "type": "text" },
            "rating": { "type": "float" },
            "episode_number": { "type": "integer" },
            "season_number": { "type": "integer" },
            "series_id": { "type": "integer" },
            "topics": { "type": "keyword" }
        }
  }
}
```

Result:

```json
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "the-big-data-theory"
}
```

## Insert documents

Insert documents by using the `POST` method, using the bulk API to improve efficiency:

```json
POST /the-big-data-theory/_bulk

    { "index": { "_id": 1 } }
    {
        "title": "The Data Deluge",
        "synopsis": "In the pilot episode, we meet our nerdy protagonist, Sheldon Data,
        a brilliant but socially awkward big data analyst working at CalTech. Sheldon
        struggles to cope with the overwhelming influx of data pouring into the
        university''s servers. When the university's HDFS (Hadoop Distributed File System)
        crashes due to the sheer volume of data, Sheldon must team up with his equally
        quirky colleagues, Leonard, Howard, and Raj, to come up with a solution before
        chaos ensues.",
        "first_air_date": "2024-01-01",
        "rating": 8.2,
        "episode_number": 1,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Big Data", "HDFS", "CalTech", "Hadoop", "Nerdy"]
    }
    { "index": { "_id": 2 } }
    {
        "title": "The Spark of Genius",
        "synopsis": "Sheldon becomes obsessed with Spark, a powerful data processing
        framework, after attending a seminar by a renowned data scientist. He convinces
        his friends to join him in a hackathon to optimize their data pipelines using
        Spark. Meanwhile, Penny, their non-technical neighbor, inadvertently stumbles upon
        a breakthrough idea that helps them win the hackathon. Sheldon grudgingly admits
        that sometimes simplicity is the key to success.",
        "first_air_date": "2024-01-08",
        "rating": 8.5,
        "episode_number": 2,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Spark", "Hackathon", "Data Processing", "Nerdy", "Innovation"]
    }
    { "index": { "_id": 3 } }
    {
        "title": "Streaming Shenanigans",
        "synopsis": "The gang faces a new challenge when they're tasked with
        implementing real-time data processing using Spark Streaming. Sheldon's
        perfectionism leads to endless debates over the best streaming algorithms, while
        Leonard struggles to keep up with the fast-paced nature of streaming data. Things
        take a hilarious turn when Howard accidentally sends a stream of cat videos
        through their prototype system, causing it to crash spectacularly.",
        "first_air_date": "2024-01-15",
        "rating": 8.0,
        "episode_number": 3,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Spark Streaming", "Real-Time Data", "Cat Videos", "Nerdy", "Comedy"]
    }
    { "index": { "_id": 4 } }
    {
        "title": "The Kafka Conundrum",
        "synopsis": "Sheldon's nemesis, Barry Kripke, introduces a Kafka cluster to the
        university's data infrastructure, sparking a rivalry between the two data teams.
        Sheldon is determined to prove that Spark is superior to Kafka for real-time data
        processing. However, when their systems are put to the test during a high-stakes
        data competition, Sheldon must swallow his pride and begrudgingly admit that Kafka
        has its advantages.",
        "first_air_date": "2024-01-22",
        "rating": 8.3,
        "episode_number": 4,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Kafka", "Data Infrastructure", "Rivalry", "Nerdy", "Competition"]
    }
    { "index": { "_id": 5 } }
    {
        "title": "Elasticsearch Extravaganza",
        "synopsis": "When the university's Elasticsearch cluster becomes overwhelmed
        with queries, Sheldon and his friends must race against the clock to optimize
        their search algorithms. Meanwhile, Penny enlists their help to analyze social
        media data for her burgeoning online business. As they delve deeper into the world
        of Elasticsearch, they uncover surprising insights about their own lives and
        relationships, leading to some unexpected revelations and plenty of laughs.",
        "first_air_date": "2024-01-29",
        "rating": 8.6,
        "episode_number": 5,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Elasticsearch", "Search Algorithms", "Social Media Analysis",
        "Nerdy", "Insights"]
    }  
```

## Search for documents

Find the document with episode_number equal to 3:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "match": {
          "episode_number": 3
        }
    }
}
```

Find the document with rating greater than 8.3, order by rating descending:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "range": {
            "rating": {
              "gte": 8.3
            }
        }
    },
    "sort": [
        {
            "rating": {
                "order": "desc"
            }
        }
    ]
}
```

Find the document with topics containing Elasticsearch:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "term": {         
            "topics": "Elasticsearch"          
        }
    }
}
```

Find documents with a fuzzy search on the synopsis field for the term barrie:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "fuzzy": {
          "synopsis": "barrie"
        }
    }
}
```

## Delete a document by id

Search for a document, and use a second request delete by id:

```json
GET /the-big-data-theory/_doc
{
  "query": {
    "match": {
      "title": "The Kafka Conundrum"
    }
  }
}
```

```json
DELETE /the-big-data-theory/_doc/4
```

## Update a document by id

Search for a document, and use a second POST request to update the rating of the episode:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "match": {
          "title": "The Spark of Genius"
        }
    }
}
```

```json
POST /the-big-data-theory/_update/2
{
    "doc": {
        "rating": 9
    }
}
```

Use optimistic version control to prevent overwriting changes:

```json
POST /products/_update/2?if_primary_term=1&if_seq_no=2
{ "doc" : {
    "rating" : 10
    }
}
```

## Solution bulk_lesson11

```json
PUT /_bulk
    {"index": {"_index": "the-big-data-theory"}}
    {
        "title": "The Data Deluge",
        "synopsis": "In the pilot episode, we meet our nerdy protagonist, Sheldon Data,
        a brilliant but socially awkward big data analyst working at CalTech. Sheldon
        struggles to cope with the overwhelming influx of data pouring into the
        university''s servers. When the university's HDFS (Hadoop Distributed File System)
        crashes due to the sheer volume of data, Sheldon must team up with his equally
        quirky colleagues, Leonard, Howard, and Raj, to come up with a solution before
        chaos ensues.",
        "first_air_date": "2024-01-01",
        "rating": 8.2,
        "episode_number": 1,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Big Data", "HDFS", "CalTech", "Hadoop", "Nerdy"]
    }
    { "index": { "_index": "the-big-data-theory" } }
    {
        "title": "The Spark of Genius",
        "synopsis": "Sheldon becomes obsessed with Spark, a powerful data processing
        framework, after attending a seminar by a renowned data scientist. He convinces
        his friends to join him in a hackathon to optimize their data pipelines using
        Spark. Meanwhile, Penny, their non-technical neighbor, inadvertently stumbles upon
        a breakthrough idea that helps them win the hackathon. Sheldon grudgingly admits
        that sometimes simplicity is the key to success.",
        "first_air_date": "2024-01-08",
        "rating": 8.5,
        "episode_number": 2,
        "season_number": 1,
        "series_id": 1,
        "topics": ["Spark", "Hackathon", "Data Processing", "Nerdy", "Innovation"]
    }
```

## Search for documents solutions lesson 11

Find the document with episode_number equal to 3:

```json
GET /the-big-data-theory/_search
{
    "query": {
        "term": {
          "episode_number": 3
        }
    }
}
```
