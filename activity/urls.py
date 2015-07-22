from django.conf.urls import url

from . import views
from django.contrib.auth.views import login, logout

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^login/$', login, name='login', kwargs={'template_name': 'activity/login.html'}),
    url(r'^logout/$', logout, name='logout', kwargs={'next_page': '/'}),
]
