# Using the Command Line Interface

## Kafka Topics CLI: Create a Topic

`kafka-topics`: used to create, delete, describe or change a topics, typing this in kafka-broker you get an overview of all the options.

Creating a topic:

`kafka-topics --bootstrap-server kafka1:29092 --create --topic first_topic --partitions 3 --replication-factor 1`

REMARK! Replication factor can not be bigger than the number of brokers!

## List and Describe Topics

List the topics: `kafka-topics --bootstrap-server kafka1:29092 --list`

Information about a specific topic: `kafka-topics --bootstrap-server kafka1:29092 --topic first_topic --describe`

## Deleting Topics

`kafka-topics --bootstrap-server kafka1:29092 --delete --topic first_topic`

## Kafkacat Console Producer

Kafkacat = read data and publish to Kafka

`kafkacat`: manual how to use this command.

`-P`: produce mode

Two required options:

- `-b`: where to find Kafka brokers
- `-t`: which topic to write to

`Ctrl+C`: stop the producer

Example: `kafkacat -P -b 127.0.0.1:9092 -t first_topic`

## Producing to Non-Existing Topic

Configuration file `server.properties` with property `num.partitions` default = 1.

## Kafkacat Console Consumer

`kafkacat -C -b 127.0.0.1:9092 -t first_topic`: the messages which are sent earlier.

Default: consume from the beginning

`-o end`: to consume only the newest messages

Note: the order in which messages are read are not necessarily the same as the order in which the messages are sent.

## Kafkacat Console Consumer: Groups

`-G`-option to specify the group, `-t` is supplied after the name of the consumer group.

Example: `kafkacat -C -b 127.0.0.1:9092 -G my-first-application first_topic`

## Consumer groups: where to start?

`auto.offset.reset` - earliest - latest - none

## Kafakcat Console Consumer: Groups

To show all the messages written to the topic:

`kafkacat -C -b 127.0.0.1:9092 -G my-second-application first_topic -X auto.offset.rest=beginning`

Stop the command and run it again. The messages are not shown again.

## Kafka Consumer Groups

To show all the known consumer groups:

`kafka-consumer-groups --bootstrap-server kafka1:29092 --list`

To describe a consumer group:

`kafka-consumer-groups --bootstrap-server kafka1:29092 --describe --group my-first-application`

## Resetting offsets

`kafka-consumer-groups` has an option `-reset-offsets`, you can choose between:

- `-to-datetime`
- `-by-period`
- `-to-earliest`
- `-shift-by`

Example: `kafka-consumer-groups --bootstrap-server kafka1:29092 --group my-first-application --reset-offsets --to-earliest --execute --topic first_topic`

You will see the data once more.

Example: `kafka-consumer-groups --bootstrap-server kafka1:29092 --group my-first-application --reset-offsets --shift-by -2 --execute --topic first_topic`

You will see 6 messages, 2 messages back for each of the three partitions.
