microservice-twitter-search-ruby
================================

This docker container searches for URLs within tweets.

## To Build This Image

from inside the repository root folder

    docker build -t cloudspace/twitter-search-ruby ./

## To Run This Image

this will run this docker image as a one shot container, it will output JSON for each tweet found, line break delimited.

    docker run --rm cloudspace/twitter-search-ruby /.rbenv/versions/2.1.2/bin/ruby /run.rb "[JSON]"


## To Run This Image For Troubleshooting

start the docker image in daemon mode and open port 22, set a root password

    docker run -e "root_pw=cersei" -p 22 -d cloudspace/twitter-search-ruby
    
find out what port number has been opened to your local system by checking the current running docker images. this port will be mapped to 22 in the container

    docker ps
    
then ssh into the container and give it the password you had it set

    ssh root@0.0.0.0 -p [port_number]
    
now you can poke around and run things manually to troubleshoot any errors