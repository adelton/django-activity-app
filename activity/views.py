
# Copyright 2016 Jan Pazdziora
#
# Licensed under the Apache License, Version 2.0 (the "License").

from django.shortcuts import render
from django.contrib.auth.models import User

def index(request):
    activity_list = User.objects.order_by('-last_login')[:20]
    user_permissions = request.user.get_all_permissions()
    context = {'user_permissions': user_permissions, 'activity_list': activity_list}
    return render(request, 'activity/index.html', context)
