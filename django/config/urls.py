import json

from django.contrib import admin
from django.db import connection
from django.http import HttpResponse, JsonResponse
from django.urls import path


def index(_request):
    return HttpResponse("Django is running")


def health(_request):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        return JsonResponse({"status": "ok", "db": "ok"})
    except Exception as e:
        return JsonResponse({"status": "error", "db": str(e)}, status=500)


urlpatterns = [
    path("admin/", admin.site.urls),
    path("health/", health),
    path("", index),
]
