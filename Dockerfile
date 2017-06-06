FROM registry.fedoraproject.org/fedora:25

MAINTAINER Jan Pazdziora

RUN dnf install -y python-pip python-virtualenv && dnf clean all
RUN mkdir -p /var/www/django \
	&& cd /var/www/django \
	&& virtualenv . \
	&& source bin/activate \
	&& pip install Django \
	&& django-admin startproject mysite \
	&& cd mysite \
	&& python manage.py startapp activity \
	&& python manage.py migrate
COPY manage.py /app/
COPY mysite /app/mysite/
COPY activity /app/activity/
RUN diff -ru /var/www/django/mysite /app || :

EXPOSE 8000
ENTRYPOINT cd /var/www/django && source bin/activate && cd mysite && python manage.py runserver 0.0.0.0:8000
