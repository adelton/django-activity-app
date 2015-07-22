# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.contrib.auth.models import User

def index(request):
    activity_list = User.objects.order_by('-last_login')[:20]
    context = {'activity_list': activity_list}
    return render(request, 'activity/index.html', context)
