# Kafka

I've made a typo, in my case the topicname is random-topic instead of random_topic with an underscore

## Commands in WSL Linux

List all the available topics: `kafkacat -L -b localhost:9093`

Create a large file with random data: `base64 /dev/urandom | nl | head -c 1000000000 > large.txt`

Sending data to this topic: `cat large.txt | pv -L 10k | kafkacat -b localhost:9092 -P -t random_topic`

Starting a Kafka-consumer: `kafkacat -b localhost:9092 -G random_group random_topic`

## Commands in terminal in VSC

Starting Docker containers: `docker compose up -d`

Stopping Docker containers: `docker compose down`

Dive into a kafka-broker: `docker exec -it kafka1 bash`

List all the topics: `kafka-topics --bootstrap-server kafka1:29092 --list`

Create a topic: `kafka-topics --bootstrap-server kafka2:29092 --create --replication-factor 2 --partitions 3 --topic random_topic`

Overview of the created topic: `kafka-topics --bootstrap-server kafka3:29092 --describe --topic random_topic`

Go to the directory: `cd /tmp/kraft-combined-logs/`

List the entries starting with 'random': `ls -ld random*`

List contents of directory 'random-topic-1': `ls -lh random-topic-1`

Tailing this file to see data is still added: `tail -f random-topic-1/00000000000000000000.log`
