# Using the Kafka CLI

## Some exercises

Use `Kafka-topics` to create a new topic with 5 partitions and a replication factor of 3.

`kafka-topics --bootstrap-server kafka1:29092 --create --topic topic_oef --partitions 5 --replication-factor 3`

Check in WSL the new topic, `topic_oef` with command: `kafkacat -L -b localhost:9093`

Result:

```console
Metadata for all topics (from broker 2: localhost:9093/2):
 3 brokers:
  broker 1 at localhost:9092
  broker 2 at localhost:9093
  broker 3 at localhost:9094 (controller)
 1 topics:
  topic "topic_oef" with 5 partitions:
    partition 0, leader 2, replicas: 2,3,1, isrs: 2,3,1
    partition 1, leader 3, replicas: 3,1,2, isrs: 3,1,2
    partition 2, leader 1, replicas: 1,2,3, isrs: 1,2,3
    partition 3, leader 3, replicas: 3,1,2, isrs: 3,1,2
    partition 4, leader 1, replicas: 1,2,3, isrs: 1,2,3
```

Use `kafkacat` to send some messages to this topic.

`cat large.txt | pv -L 10k | kafkacat -b localhost:9092 -P -t topic_oef`

Use `kafkacat` to read these messages.

`kafkacat -C -b localhost:9093 -t topic_oef`

Use `kafkacat` to create two consumers that are part of the same consumer group. Notice how each of these two consumers receives only part of the messages.
