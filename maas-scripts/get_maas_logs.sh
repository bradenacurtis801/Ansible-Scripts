#!/bin/bash

# SSH into the remote server and cat out the contents of /var/log/postgresql-14-main.log,
# then store it into postgresql-14-main.log in the current directory

ssh -o StrictHostKeyChecking=no prasad@10.10.200.119 'cat /var/log/postgresql/postgresql-14-main.log' > postgresql-14-main.log

# Output the last 10 lines of postgresql-14-main.log to the console
tail -n 10 postgresql-14-main.log

