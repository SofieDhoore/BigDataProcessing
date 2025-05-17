# Elastic Search installation

Go to your WSL on Windows, log in. I could find a docker with `docker --version` but I couldn't start or enable it. So I had to remove it again and install it all over.

To remove it: `sudo apt purge docker*` and `sudo rm -rf /var/lib/docker /var/lib/containerd`

After that do an update, it's better to do this everytime you want to install something: `sudo apt update`.

Then I've installed some other stuff: `sudo apt install ca-certificates curl gnup lsb-release`

Next: `sudo mkdir -p /etc/apt/keyrings`

Then: `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

Then the following command-block:

```linux
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

After that it's better to do an update again: `sudo apt update`

Install docker: `sudo apt install docker-ce docker-ce-cli containerd.io`

Enable docker: `sudo systemctl enable docker`

Start docker: `sudo systemctl start docker`

Check your docker: `docker info`

I've made an `elasticsearch`-directory in the main directory: `mkdir elasticsearch`

Go to the new directory `cd elasticsearch` and run the following command: `curl -fsSL https://elastic.co/start-local | sh`

Now, there are some containers starting up. You can find your Username and password to log in on Elastic Search and Kibana.

Go to `http://localhost:9200` and to `http://localhost:5601` to test some stuff.

To find the `.env`-file, go to the right directory `cd elasticsearch` and `cd elastic-start-local` in my case. But the command `ls -la` to see the hidden files.
