from django.contrib import admin
from django.http import HttpResponse
from django.urls import path


def index(_request):
    return HttpResponse("Django is running")


urlpatterns = [
    path("admin/", admin.site.urls),
    path("", index),
]
