# Petstore: Build with docker, Deploy to kubernetes 

docker and kubernetes manifest files to transform and deploy legacy monolith petstore app with kubernetes and istio  

## Requirements

- local kubernetes cluster
- add local dns name `petstore.lol` in your host file. in windows `C:\Windows\System32\drivers\etc\hosts`

## Run in local cluster

* build & tag petstore image with 

`cd k8s`

`docker build -t citizendiop/petstore-ee7 .`

* build & tag nginx front image 

`cd front`

`docker build -t citizendiop/petstore-nginx:v1 .`

* run petstore manualy to test
`docker run -it -p 8080:8080 citizendiop/petstore-ee7`

Once deployed go to the following URL:

http://localhost:8080/applicationPetstore

stop container

* tag image

`docker tag citizendiop/petstore-ee7:latest citizendiop/petstore-ee7:v1`

* push

`docker login`

`docker push citizendiop/petstore-ee7:v1`

* deploy resources to kubernetes cluster

`kubectl apply -f k8s/`

* check 

if you have kubernetes dashboard, check
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

in command line, 

* to see the status of each pod.

`kubectl get po -o wide --watch`

OR

`kubectl get all`

OR

`kubectl get deploy,svc,pods`

* to get logs

`kubectl logs -f pod/petstore-645669b85f-66x9b`

* to kill pods

`kubectl delete pod/petstore-645669b85f-66x9b`

kubernetes will restart pod automaticaly

* delete all resources

`kubectl delete -f k8s/`

## References

based in a tutoriel of David Gageot on devoxx 2018 prez :

[Docker, Kubernetes et Istio, c'est utile pour mon monolithe? (D. Gageot)](https://www.youtube.com/watch?v=Z_sNyT0hcVw)

- [A Java Petstore using the Java EE 7 (by Antonio Goncalves)](https://github.com/agoncal/agoncal-application-petstore-ee7)


## TODO

1. [x] Dockerise application with multi-stage build
2. [x] Deploy to kubernetes with external service
3. [ ] Improve app with `facade pattern` or `sidecar`, add nginx http server (with gzip, 404 and nice url)
4. [ ] Set ingress service : one domain -> One service

- [ ] manage the statefull aspect of app
- [ ] 
- [ ] 