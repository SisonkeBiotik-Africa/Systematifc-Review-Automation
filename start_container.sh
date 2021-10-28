#!/usr/bin/env bash

## image name ##
PATH_IMAGE_NAME=${PWD}/.container_image_name
if [ -f ${PATH_IMAGE_NAME} ]
then
  CONTAINER_IMAGE_NAME=$(cat ${PATH_IMAGE_NAME})
else
  echo "please build your dev container image first..."
  echo "try running: bash build.sh"
  exit
fi

IMAGE_POINTER="${CONTAINER_IMAGE_NAME}"
IMAGE_HASH=latest

## useful reminders for users 
LIGHT_BLUE='\033[1;34m' 
echo -e "${LIGHT_BLUE}*hint: use command 'bash start_container.sh' to enter this same active container in another terminal tab"
echo -e "${LIGHT_BLUE}*hint: run 'python -m jupyterlab --ip=0.0.0.0 --port=8888 --no-browser' and ctrl + click the last URL to start and open jupyter notebook in your browser - or copy pasta the url '0.0.0.0:8888' to your browser"
echo -e "${LIGHT_BLUE}*hint: use 'python -m <python module>' to run python modules e.g. 'python -m pytest'"
echo -e "${LIGHT_BLUE}*hint: use 'docker ps' to list active containers "
echo -e "${LIGHT_BLUE}*hint: use 'docker kill <container name>' to kill / turn off an active container"
echo -e "${LIGHT_BLUE}*hint: tab is your friend =)"

## new or existing container ##  
PATH_CONTAINER_ID=${PWD}/.container_id
if [ -f ${PATH_CONTAINER_ID} ]
then
  CONTAINER_ID=$(cat ${PATH_CONTAINER_ID})
  if [ "$( docker container inspect -f '{{.State.Running}}' ${CONTAINER_ID} )" == "true" ] 
  then
    docker exec -it ${CONTAINER_ID} zsh
  else 
    echo
    echo Starting your existing container with ID:
    docker start ${CONTAINER_ID}
    docker attach ${CONTAINER_ID}
  fi
else
  echo Creating new container... 
  docker run -it --cidfile=".container_id"\
  -v ${PWD}:/home/${USER}/dev_dir \
  -v ~/.aws:/home/${USER}/.aws \
  -v ~/.ssh:/home/${USER}/.ssh \
  -v ~/.gitconfig:/home/${USER}/.gitconfig \
  -p 8888:8888 \
  -p 5000:5000 \
  ${IMAGE_POINTER}:${IMAGE_HASH}
fi