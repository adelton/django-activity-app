
# Copyright 2016--2019 Jan Pazdziora
#
# Licensed under the Apache License, Version 2.0 (the "License").

from django.urls import path

from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.index, name='index'),
    path('login', views.login, name='login'),
    path('logout', auth_views.LogoutView.as_view(next_page='/'), name='logout'),
]
