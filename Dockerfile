FROM registry.fedoraproject.org/fedora

MAINTAINER Jan Pazdziora

RUN dnf install -y python3-virtualenv && dnf clean all
RUN mkdir -p /var/www/django \
	&& cd /var/www/django \
	&& virtualenv . \
	&& source bin/activate \
	&& pip install 'Django == 2.2.*'\
	&& django-admin startproject mysite \
	&& cd mysite \
	&& python manage.py startapp activity \
	&& sed -i 's#^\(ALLOWED_HOSTS\).*#\1 = [ "*" ]#' mysite/settings.py \
	&& python manage.py migrate \
	&& echo 'from django.contrib.auth.models import User; User.objects.create_superuser("admin", "admin@example.test", "nimda")' | python manage.py shell

COPY manage.py /app/
COPY mysite /app/mysite/
RUN diff -ru /var/www/django/mysite/mysite /app/mysite || :
RUN rm -rf /var/www/django/mysite/mysite && cp -r /app/mysite /var/www/django/mysite/mysite
COPY activity /var/www/django/mysite/activity

EXPOSE 8000
ENTRYPOINT cd /var/www/django && source bin/activate && cd mysite && python manage.py runserver 0.0.0.0:8000
