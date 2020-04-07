# Petstore: Build with docker, Deploy to kubernetes 

Docker and kubernetes manifest files to transform and deploy legacy monolith petstore app with kubernetes and istio, without changes in application code  

## References

based in a tutoriel of David Gageot on devoxx 2018 prez :

- [youtube -> Docker, Kubernetes et Istio, c'est utile pour mon monolithe? (D. Gageot)](https://www.youtube.com/watch?v=Z_sNyT0hcVw)

- [github -> A Java Petstore using the Java EE 7 (Antonio Goncalves)](https://github.com/agoncal/agoncal-application-petstore-ee7)


## Requirements

You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. 


e.g : for a local cluster in windows 10 pro

- Enable Hyper-V
- Install Docker for Windows and enable Kubernetes
- enable ingress : install ingress controller in your local cluster 
	- https://docs.docker.com/ee/ucp/kubernetes/cluster-ingress/ingress/
	- https://github.com/docker/for-win/issues/1901
	- https://stackoverflow.com/questions/59255445/how-can-i-access-nginx-ingress-on-my-local
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

* create custom namespace

`kubectl apply -f namespaces/`

* deploy resources to kubernetes cluster

`kubectl apply -f k8s/`

* check 

if you have kubernetes dashboard, check
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

in command line, 

* to see the status of each pod.

`kubectl get po -o wide --watch`

* to check deployed resources

`kubectl get all --namespace=petstore-development`

`kubectl get deploy,svc,pods --namespace=petstore-development`

* to check namespaces

`kubectl get namespaces --show-labels`

* to get logs

`kubectl logs -f pod/petstore-645669b85f-66x9b`

* to kill pods

`kubectl delete pod/petstore-645669b85f-66x9b`

kubernetes will restart pod automaticaly

* delete all resources in namespace

`kubectl delete -f k8s/`

or 

`kubectl delete -f namespaces\namespace-development.yaml`


## TODO

1. [x] Dockerise application with multi-stage build
2. [x] Deploy to kubernetes with external service
3. [x] Improve app with `facade pattern` or `sidecar`
	- [x] add nginx http server (with gzip, 404 and nice url)
	- [x] Set ingress service for local 'petstore.lol': one domain -> One service
4. [x] Using Kubernetes Namespaces to Manage Multiple Environments (development/staging/production)
5. [ ] init isio service mesh (based on `facade` / `sidecar` pattern)


- [ ] manage the statefull aspect of app
- [ ] add github actions to build and push image to dockerhub
- [ ] set up with [helm](https://helm.sh/)
- [ ] set up with [kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)
- [ ] with jenkins-x or github actions, automate CI/CD with multiple environments on Kubernetes cloud(GKE or AKS) using GitOps