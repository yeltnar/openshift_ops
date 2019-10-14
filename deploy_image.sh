# way to id image on local machine
image_identifier="drew" 

DOCKER_REGISTRY="docker-registry-default.apps.pub-openshift1.sc.ibm.com"
DOCKER_SERVICE="docker-registry.default.svc:5000"
project_name="pj1"
app_name="drew"
# app_pretty_name="app1"
tag="latest"


echo DOCKER_REGISTRY = $DOCKER_REGISTRY
echo DOCKER_SERVICE = $DOCKER_SERVICE
echo project_name = $project_name
echo app_name = $app_name
echo tag = $tag

echo "We are not building an image here, we are only pushing one that already has been built"

echo “login to openshift docker registry”
docker login -u root -p $(oc whoami -t) $DOCKER_REGISTRY

echo “tag image”
echo "docker tag $image_identifier $DOCKER_REGISTRY/$project_name/$app_name:$tag"
docker tag $image_identifier $DOCKER_REGISTRY/$project_name/$app_name:$tag

echo “push image”
docker push $DOCKER_REGISTRY/$project_name/$app_name:$tag

echo “oc login”
oc login

echo "oc new-project $project_name"
oc new-project $project_name

echo "oc new-app --docker-image $DOCKER_SERVICE/$project_name/$app_name:$tag"
oc new-app --docker-image $DOCKER_SERVICE/$project_name/$app_name:$tag

# name is the name of the service (sub sub domain)
echo "oc expose svc $app_name --name=$app_name"
oc expose svc $app_name --name=$app_name
