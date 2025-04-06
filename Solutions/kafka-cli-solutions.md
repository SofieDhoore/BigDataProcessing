# Solutions to CLI exercise

Create topic

```bash
docker exec -it kafka1 bash
kafka-topics --bootstrap-server kafka1:29092 --create --topic my-topic --partitions 5 --replication-factor 3
```

List the topics (in this case we use a different bootstrap server).

```bash
docker exec -it kafka1 bash
kafka-topics --bootstrap-server kafka2:29092 --list
```

Output

```console
__consumer_offsets
my-topic
```

Describe the topic in more detail

```bash
docker exec -it kafka1 bash
kafka-topics --bootstrap-server kafka2:29092 --describe --topic my-topic
```

Send some messages to `my-topic` using `kafkacat`:

```bash
for i in {1..16}; do echo message $i; done | kafkacat -b localhost:9092 -P -t my-topic
```

Run the following command

```bash
kafkacat -b localhost:9092 -C -t my-topic -o end
```

This will only show new messages!
Stop the consumer by issuing `CTRL-c`.

```bash
kafkacat -b localhost:9092 -C -t my-topic -o beginning
```

Will show all the messages that were sent to `my-topic`. Notice how we **do not** see the messages in the same order they were sent!

```console
message 2
message 7
message 11
message 4
message 6
message 9
message 12
message 13
message 14
message 15
% Reached end of topic my-topic [1] at offset 7
message 1
message 16
message 5
message 10
% Reached end of topic my-topic [0] at offset 2
message 3
message 8
% Reached end of topic my-topic [2] at offset 3
% Reached end of topic my-topic [4] at offset 2
% Reached end of topic my-topic [3] at offset 2
```

Stop the consumer.

Open up a new (third) terminal.
In the second and third terminal run

```bash
kafkacat -b localhost:9092 -C -G my-app my-topic
```

and then send some messages to the topic using the `kafkacat`. Some of the messages will be shown by the first consumer and some will be shown by the second consumer.

Leave the consumers running (but possible stop the producer). Run the following command to investigate the status of the consumer group `my-app`:

```bash
 kafka-consumer-groups --bootstrap-server kafka1:29092 --describe --group my-app
 ```

 This could show something like this:

 ```console
 GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                           HOST            CLIENT-ID
my-app          my-topic        0          2               2               0               console-consumer-6cbe079d-dbdc-4dfe-87bb-153c51b6f9cb /172.18.0.4     console-consumer
my-app          my-topic        1          4               4               0               console-consumer-6cbe079d-dbdc-4dfe-87bb-153c51b6f9cb /172.18.0.4     console-consumer
my-app          my-topic        2          5               5               0               console-consumer-6cbe079d-dbdc-4dfe-87bb-153c51b6f9cb /172.18.0.4     console-consumer
my-app          my-topic        3          7               7               0               console-consumer-76fa261e-b2d9-4d26-9d30-e7f4e9c0a94f /172.18.0.3     console-consumer
my-app          my-topic        4          5               5               0               console-consumer-76fa261e-b2d9-4d26-9d30-e7f4e9c0a94f /172.18.0.3     console-consumer
```

 After sending some messages, run the previous command again. You could see something like this:

```console
 Consumer group 'my-app' has no active members.

GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
my-app          my-topic        2          5               8               3               -               -               -
my-app          my-topic        1          4               4               0               -               -               -
my-app          my-topic        0          2               6               4               -               -               -
my-app          my-topic        4          5               7               2               -               -               -
my-app          my-topic        3          7               9               2               -               -               -
```

In this case, I sent 11 additional messages to the topic (because the sum of the values in the `LAG` column equals 11).
Restart on of the consumers, it will read these 11 messages!

Stop the consumer. You cannot reset the offsets while a consumer is active in the consumer group.  After stopping the consumer execute:

```bash
kafka-consumer-groups --bootstrap-server kafka1:19092 --group my-app --shift-by -2 --topic my-topic --reset-offsets --execute
```

If you now run the consumer again, you will read 10 messages.

## Sending `key:value` pairs using kafkacat

```bash
echo "key1:message100" | kafkacat -b localhost:9092 -P -K : -t test_topic
```

If you read with the same command as before:

```bash
kafkacat -b localhost:9092 -C -t test_topic
```

you will **not** see the keys.

You have the add options to `kafka-console-consumer` as follows:

```bash
kafkacat -b localhost:9092 -C -t test_topic -K :
```
