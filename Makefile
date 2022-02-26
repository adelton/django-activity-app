
docker := docker

build:
	$(docker) build -t django-activity .
	$(docker) build -t django-activity-client -f Dockerfile.client .

run-docker:
	docker rm -f django-activity || :
	docker run --rm -t -d --name django-activity -p 8000:8000 django-activity

run-podman:
	podman pod rm -f django-activity-pod || :
	podman pod create --name django-activity-pod --hostname=app.example.test
	podman run --pod django-activity-pod --rm -t -d --name django-activity django-activity

run: run-$(docker)
	$(docker) attach --no-stdin django-activity &
	for i in $$( seq 1 10 ) ; do $(docker) logs django-activity | grep -q 'Quit the server with CONTROL-C' && break ; sleep 1 ; done

test-docker:
	docker run --rm --link django-activity:app.example.test django-activity-client http://app.example.test:8000 admin nimda

test-podman:
	podman run --pod django-activity-pod --rm django-activity-client http://app.example.test:8000 admin nimda

test: test-$(docker)

