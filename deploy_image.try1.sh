# project name should be unique to developer/deployment
project_name=drew-test
deployment_name=db4

oc login

DOCKER_REGISTRY="docker-registry-default.apps.pub-openshift1.sc.ibm.com"

# need to build docker image upfront
tag=tag
docker build -t $deployment_name . 
docker login -u root -p $(oc whoami -t) $DOCKER_REGISTRY
docker tag $deployment_name docker-registry-default.apps.pub-openshift1.sc.ibm.com/$project_name/$deployment_name:$tag


# create project
echo "not running oc new-project $project_name"

# create application 
## oc new-app (IMAGE | IMAGESTREAM | TEMPLATE | PATH | URL ...) [flags]
oc new-app docker-registry-default.apps.pub-openshift1.sc.ibm.com/$project_name/$deployment_name:$tag

# make it accessable
oc expose svc/$deployment_name

# push image _https://docs.docker.com/registry/insecure/_
#
#
#
#
#

oc status 