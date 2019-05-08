
build:
	docker build -t django-activity .
	docker build -t django-activity-client -f Dockerfile.client .

run:
	docker rm -f django-activity || :
	docker run --rm -t --name django-activity -p 8000:8000 django-activity &
	sleep 1

test:
	docker run --rm -ti --link django-activity:app.example.test django-activity-client http://app.example.test:8000 admin nimda

