# if you need insecure registeries (which you will to use OpenShift in this case) look at this:
# https://stackoverflow.com/questions/42211380/add-insecure-registry-to-docker

if [ -n "$app_image_name" ]; then
    echo "\$app_image_name found: $app_image_name"
else
    echo "\$app_image_name is not set (env var)"
    exit
fi

if [ -n "$app_kube_name" ]; then
    echo "\$app_kube_name found: $app_kube_name"
else
    echo "\$app_kube_name is not set (env var)"
    exit
fi

if [ -n "$project_name" ]; then
    echo "\$project_name found: $project_name"
else
    echo "\$project_name is not set (env var)"
    exit
fi

if [ -n "$tag" ]; then
    echo "\$tag found: $tag"
else
    tag="latest"
    echo "\$tag not found. Using: $tag"
fi

# way to id image on local machine
let "R =  $RANDOM*$RANDOM*$RANDOM*$RANDOM"
image_identifier=$app_image_name # "-"$R

# build current 
echo "building image with tag="$image_identifier
docker build -t $image_identifier . 

DOCKER_REGISTRY="docker-registry-default.apps.pub-openshift1.sc.ibm.com"
# DOCKER_SERVICE=$DOCKER_REGISTRY
DOCKER_SERVICE="docker-registry.default.svc:5000"
# project_name="rwe"
# app_name="rwe-drew"

echo "DOCKER_REGISTRY = "$DOCKER_REGISTRY
echo "DOCKER_SERVICE = "$DOCKER_SERVICE
echo "project_name = "$project_name
echo "app_image_name = "$app_image_name
echo "app_kube_name = "$app_kube_name
echo "tag = "$tag

echo "We are not building an image here, we are only pushing one that already has been built"

echo “login to openshift docker registry”
docker login -u root -p $(oc whoami -t) $DOCKER_REGISTRY

echo “tag image”
echo "docker tag $image_identifier $DOCKER_REGISTRY/$project_name/$app_image_name:$tag"
docker tag $image_identifier $DOCKER_REGISTRY/$project_name/$app_image_name:$tag

echo “push image”
docker push $DOCKER_REGISTRY/$project_name/$app_image_name:$tag

# docker run -P $DOCKER_REGISTRY/$project_name/$app_image_name:$tag
# docker run -P $image_identifier

docker rmi $image_identifier

# exit

## start of oc commands (this will use internel docker hub refrence)

# TODO checkout project if it is there
echo "oc new-project $project_name"
oc new-project $project_name

echo "oc project $project_name"
oc project $project_name

echo "sleep after make/switch project 10..."
sleep 10

echo "oc new-app --docker-image $DOCKER_SERVICE/$project_name/$app_image_name:$tag"
oc new-app --name $app_kube_name --docker-image $DOCKER_SERVICE/$project_name/$app_image_name:$tag

echo "sleep after make app 10..."
sleep 10

# expose the app with a service # TODO make port dynamic 
oc expose dc $app_kube_name --port=3000

# name is the name of the service (sub sub domain)
echo "oc expose svc $app_kube_name --name=$app_kube_name --port=3000"
oc expose svc $app_kube_name --name=$app_kube_name --port=3000
