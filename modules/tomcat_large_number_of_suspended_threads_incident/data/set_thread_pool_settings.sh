

#!/bin/bash

# Set the thread pool settings in Tomcat configuration

sed -i 's/<Connector port="8080"/<Connector port="8080" maxThreads="${MAX_THREADS}" maxIdleTime="${MAX_IDLE_TIME}"/' /path/to/your/server.xml


# Restart Tomcat service

systemctl restart tomcat