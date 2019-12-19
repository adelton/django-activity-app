
build:
	docker build -t django-activity .

run:
	docker rm -f django-activity || :
	docker run --rm -t -d --name django-activity -p 8000:8000 django-activity
	docker attach --no-stdin django-activity &
	for i in $$( seq 1 10 ) ; do docker logs django-activity | grep -q 'Quit the server with CONTROL-C' && break ; sleep 1 ; done

test:
	docker exec django-activity curl -s http://localhost:8000/ | grep Congratulations

