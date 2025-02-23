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

Give this command in two seperate CLI's: `kafkacat -C -b localhost:9093 -G group_oef topic_oef`

Use `kafka-consumer-groups` to investigate the consumer group that you created. Stop the consumers and send some more messages to the topic. Describe the topic once more and notice how the LAG increased for some (or all) partitions.

`kafka-consumer-groups --bootstrap-server kafka1:29092 --describe --group group_oef`

```console

Consumer group 'group_oef' has no active members.

GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
group_oef       topic_oef       2          205             223             18              -               -               -
group_oef       topic_oef       3          188             201             13              -               -               -
group_oef       topic_oef       4          211             228             17              -               -               -
group_oef       topic_oef       0          229             246             17              -               -               -
group_oef       topic_oef       1          220             238             18              -               -               -
```

Use `kafka-consumer-groups` to reset the offsets and notice how you will reread some messages.

`kafka-consumer-groups --bootstrap-server kafka1:29092 --group group_oef --reset-offsets --to-earliest --execute --topic topic_oef`

```console
GROUP                          TOPIC                          PARTITION  NEW-OFFSET
group_oef                      topic_oef                      2          0
group_oef                      topic_oef                      3          0
group_oef                      topic_oef                      4          0
group_oef                      topic_oef                      0          0
group_oef                      topic_oef                      1          0
```

Figure out how you can send messages containing a `key` and a `value` using `kafkacat`. Use `kafkacat --help` to figure out how this is done.

In WSL-CLI writ this command: `echo "key1:value1" | kafkacat -b localhost:9093 -t topic_oef -K: -P`

Verify that a key and a value were sent using `kafkacat`.

`kafka-consumer-groups --bootstrap-server kafka1:29092 --group group_oef --describe`

```console
GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                  HOST            CLIENT-ID
group_oef       topic_oef       2          446             446             0               rdkafka-5d901538-bebc-4d88-851e-8c880d034cfd /172.18.0.1     rdkafka
group_oef       topic_oef       3          406             406             0               rdkafka-5d901538-bebc-4d88-851e-8c880d034cfd /172.18.0.1     rdkafka
group_oef       topic_oef       4          437             438             1               rdkafka-5d901538-bebc-4d88-851e-8c880d034cfd /172.18.0.1     rdkafka
group_oef       topic_oef       0          447             447             0               rdkafka-5d901538-bebc-4d88-851e-8c880d034cfd /172.18.0.1     rdkafka
```

`kafkacat -b localhost:9093 -t topic_oef -C -o beginning -K:`

`kafkacat -b localhost:9093 -t topic_oef -C -K:`