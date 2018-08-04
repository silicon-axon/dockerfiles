# toolbox

[Docker Hub](https://hub.docker.com/r/siliconaxon/toolbox/)

Contains tools for your devops needs. Includes:

* Terraform
* Ansible
* AWS CLI.

## How to Use

Run and create the container from wherever.

    docker run --rm -ti \
      -v $(pwd):/workspace \
      -v ~/.aws:/root/.aws \
      -w /workspace \
      -e AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY \
      -e AWS_SECURITY_TOKEN \
      -e AWS_SESSION_TOKEN \
      siliconaxon/toolbox:latest
