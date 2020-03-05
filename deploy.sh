#!/bin/bash

# Build Production Images
docker build -t darpham/multi-client:latest -t darpham/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t darpham/multi-server:latest -t darpham/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t darpham/multi-worker:latest -t darpham/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push Production Images
docker push darpham/multi-client:latest
docker push darpham/multi-server:latest
docker push darpham/multi-worker:latest

docker push darpham/multi-client:$SHA
docker push darpham/multi-server:$SHA
docker push darpham/multi-worker:$SHA

# Apply Kubernetes Config files in k8s dir
kubectl apply -f k8s

kubectl set image deployments/server-deployment server=darpham/multi-server:$SHA
kubectl set image deployments/client-deployment client=darpham/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=darpham/multi-worker:$SHA