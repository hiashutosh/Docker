above dockerfile is used to create an apache webserver on ubuntu

save dockerfile and run following commands

	docker build -t <image-name> <path where dockerfile is saved or use . if in same direcory>
	docker run -td -p 80:80 --name <container-name> <image-name>

to get inside container

	docker exec -it <container-name> /bin/bash



example:
	
	docker build -t websever .
	docker run -td -p 80:80 cont1 webserver
	docker exec -it cont1 /bin/bash

Docker image pull command 

	docker pull yadavashu/project_apache
	
# For file Wordpress-compose-secret.yml

## create secret files with base64 encoded (replace password with desired password)
 	echo password | base64
  	echo pass1234 | base64
copy output and paste in another files lets name it mysql_password.txt and mysql_root_password.txt:
	
 	docker secret create db_password mysql_password.txt
 	docker secret create db_root_password mysql_root_password.txt


# Create wp-relpicated
to deploy this cluster we need to use docker stack deploy command
but perquisite is that docker swarm should already be initialized

to initialize docker swarm:

	docker swarm init
to run this cluster:

	docker stack deploy -c wp-replicated.yml my_stack
we can further scale 

	docker service scale mystack_db=<replicas> mystack_wordpress=<replicas>
