#!/bin/bash

# dockerize script with custom tags and packages.
# Each package is assumed to be a subfolder to the path where this
# dockerize script is executed. Then inside each package/ subfolder
# contains the Dockerfile and a single file "TAG" that has a string
# indicating the current tag to be used for the docker image.
#
# Albert Tedja <albert@siliconaxon.com>

# Color stuff
yellow='\e[1;33m'
nc='\e[0m'
color=$yellow


ctrl_c () {
  echo
  info "CTRL-C pressed. TERMINATED BY USER"
  exit $?
}
trap ctrl_c INT


info () {
  echo -e "${color}[dockerize] ${1}${nc}"
}

# Grab flags
APPLICATION_NAME=${1%/}

if [[ ! -d $APPLICATION_NAME ]] ; then
  info "Package $APPLICATION_NAME does not exist"
  exit 1
fi

shift

while getopts bpr opts; do
  case ${opts} in
    b) BUILD=true ;;
    p) PUSH=true ;;
    r) REBUILD=true ;;
  esac
done

# Show usage if no options are not specified
if [[ -z $APPLICATION_NAME ]] && [[ -z $BUILD ]] && [[ -z $REBUILD ]] && [[ -z $PUSH ]] ; then
  echo -e "Simplify building, pushing, and running docker images."
  echo -e "Usage:"
  echo -e "\tdockerize <package> [OPTIONS]\n"
  echo -e "Options:"
  echo -e "\tpackage\tName of the package."
  echo -e "\t-b\tBuild image."
  echo -e "\t-p\tPush image to the registry."
  echo -e "\t-r\tRebuild by removing existing image with the same name and tag."
  echo
  echo -e "Example:"
  echo -e "\tdockerize -bp"
  exit 1
fi

# Docker user. Replace
DOCKER_USER="siliconaxon"

IMAGE_TAG=$(<$APPLICATION_NAME/TAG)
IMAGE_ID="${DOCKER_USER}/${APPLICATION_NAME}"
IMAGE_ID_TAG="${IMAGE_ID}:${IMAGE_TAG}"

info "Application name: ${APPLICATION_NAME}"
info "Commit: ${IMAGE_TAG}"
info "Image: ${IMAGE_ID_TAG}"

# Check for existing image
exist=$(docker images | grep $IMAGE_ID | grep $IMAGE_TAG)

# Rebuild. Always delete existing image.
if [[ -n $REBUILD ]]; then
  if [[ -n $exist ]]; then
    info "Removing old image."
    docker rmi $IMAGE_ID_TAG
  fi

  set -e
  info "Building image"
  cd $APPLICATION_NAME
  docker build --no-cache -t $IMAGE_ID_TAG .
  docker tag $IMAGE_ID_TAG $IMAGE_ID:latest
  set +e

# Build
elif [[ -n $BUILD ]]; then
  if [[ -z $exist ]]; then
    set -e
    info "Building image"
    cd $APPLICATION_NAME
    docker build -t $IMAGE_ID_TAG .
    docker tag $IMAGE_ID_TAG $IMAGE_ID:latest
    set +e
  else
    info "Image already exist."
  fi
else
  info "No build command specified."
fi

# Push
if [[ -n $PUSH ]] ; then
  info "Pushing to registry"
  docker push $IMAGE_ID_TAG
  docker push $IMAGE_ID:latest
fi

echo $IMAGE_ID_TAG
