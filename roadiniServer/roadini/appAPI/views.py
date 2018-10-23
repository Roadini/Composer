from django.shortcuts import render
from rest_framework import viewsets
from .models import PathsTable
from .serializers import PathsTableSerializer

# Create your views here.

class PathsTableView(viewsets.ModelViewSet):
    queryset = PathsTable.objects.all()
    serializer_class = PathsTableSerializer
