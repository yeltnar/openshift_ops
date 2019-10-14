project_name=drew_cli_project

# create project
oc create-project $project_name

# create application _I think this is where it needs to be bound to an image stream_
## oc new-app (IMAGE | IMAGESTREAM | TEMPLATE | PATH | URL ...) [flags]
## Use a MySQL image in a private registry to create an app and override application artifacts' names
### oc new-app --docker-image=myregistry.com/mycompany/mysql --name=private
## Create an application from a remote repository using its beta4 branch
###oc new-app https://github.com/openshift/ruby-hello-world#beta4

# push image _https://docs.docker.com/registry/insecure/_
#
#
#
#
#