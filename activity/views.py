
from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, world. We will show the activity of users here.")
