FROM registry.fedoraproject.org/fedora

RUN dnf install -y python3-virtualenv diffutils && dnf clean all
RUN mkdir -p /var/www/django \
	&& cd /var/www/django \
	&& virtualenv . \
	&& source bin/activate \
	&& pip install 'Django == 3.0.*' \
	&& django-admin startproject mysite \
	&& cd mysite \
	&& python manage.py startapp activity

COPY manage.py /app/
COPY mysite /app/mysite/
COPY activity /app/activity/
RUN grep '^SECRET_KEY' /var/www/django/mysite/mysite/settings.py | sed -i -e 's/^SECRET_KEY.*//;T;R /dev/stdin' -e 'd' /app/mysite/settings.py
# Catch when django-admin starts producing different content
RUN diff --exclude=__pycache__ -ru /var/www/django/mysite /app
RUN cp -rp /app/* /var/www/django/mysite/

EXPOSE 8000
ENTRYPOINT cd /var/www/django && source bin/activate && cd mysite && python manage.py runserver 0.0.0.0:8000
