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

