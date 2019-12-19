
# Copyright 2016 Jan Pazdziora
#
# Licensed under the Apache License, Version 2.0 (the "License").

from django.urls import path

from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', views.index, name='index'),
    path('login', auth_views.LoginView.as_view(template_name='activity/login.html'), name='login'),
    path('logout', auth_views.LogoutView.as_view(next_page='/'), name='logout'),
]
