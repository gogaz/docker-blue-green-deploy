# Blue-Green deployment using Docker and NGINX

This project implements the blue-green deployment strategy using Docker and Docker Compose.
The architecture consists of two identical application instances (blue and green)
and a load balancer (NGINX) that routes traffic between them.

## Blue-Green deployment architecture

This implementation of the blue-green deployment strategy allows for seamless and low-risk
deployments by maintaining two identical production environments (blue and green) that can
be switched between with ease.

The architecture consists of the following components:

1. Two Docker containers running the blue and green instances of the application.
2. A load balancer (e.g., NGINX) that routes traffic between the blue and green instances.
3. A remote Git repository with a hook that triggers a deployment upon pushing to the correct branch.
4. A Docker container running on the same machine as the Git remote repository, responsible for executing the deployment script.

## Using on production

To set up the blue-green deployment architecture:

1. Set up a remote Git repository with a `post-receive` hook to trigger the deployment script. There's a working example below
2. On the same machine, install Docker and start all services.
3. Push to your remote, and enjoy verbose deployment process directly in Git output.


```sh
#!/bin/bash

# hooks/post-receive

BRANCH="main"
WORKING_DIRECTORY=/path/to/your/project
GIT_DIR=$(pwd)
GIT_REV=$(git log --oneline -n 1 | awk '{ print $1 }')


while read oldrev newrev ref
do
    if [[ $ref = refs/heads/$BRANCH ]];
    then
        echo "Ref $ref received. Deploying ${BRANCH} branch..."
        git --work-tree=$WORKING_DIRECTORY --git-dir=$GIT_DIR checkout -f $BRANCH
        cd $WORKING_DIRECTORY
        bash deploy.sh $GIT_REV
    else
        echo "Ref $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
    fi
done
```

## Basic (local) usage

1. Start the services using `docker-compose up -d`.
2. Make changes to the app.
3. Deploy the new version of the application with zero downtime using `./deploy.sh`.

