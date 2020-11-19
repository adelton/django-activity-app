
build:
	docker build -t django-activity .
	docker build -t django-activity-client -f Dockerfile.client .

run:
	docker rm -f django-activity || :
	docker run --rm -t -d --name django-activity -p 8000:8000 django-activity
	docker attach --no-stdin django-activity &
	for i in $$( seq 1 10 ) ; do docker logs django-activity | grep -q 'Quit the server with CONTROL-C' && break ; sleep 1 ; done

test:
	docker run --rm --link django-activity:app.example.test django-activity-client http://app.example.test:8000 admin nimda

