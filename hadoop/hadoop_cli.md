# Command Line Interface for HDFS

Assuming the HDFS-culster is installed.

The following commands should be executed on the command line of the NameNode

How to get help? `hadoop fs -help`

You can choose between `hadoop fs` or `hdfs dfs`

## Copying Data to HDFS

`copyFromLocal` subcommand to copy data into HDFS:

`hadoop fs -copyFromLocal input/docs/quangle.txt hdfs://localhost/user/tom/quangle.txt`

Let the system pick up the default scheme and host the URI:

`hadoop fs -copyFromLocal input/docs/quangle.txt /user/tom/quangle.txt`

Rather than specifying an absolute path for our home directory in HDFS we could use a relative path:

`hadoop fs -copyFromLocal input/docs/quangle.txt quangle.txt`

`copyToLocal` subcommand to copy data from HDFS back to the local file system:

`hadoop fs -copyToLocal quangle.txt quangle.copy.txt`

## Directory Creation and Listing

Creating a directory:

`hadoop fs -mkdir books`

This creates a directory called 'books' in the current HDFS directory.

List the contents of the current directory:

`hadoop fs -ls`

This is similar to the information returned in Unix: `ls -l`

One difference in hadoop the replication factor is shown.