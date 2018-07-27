FROM alpine:3.8
MAINTAINER Silicon Axon, hello@siliconaxon.com

# Install core utils and libs.
RUN echo "ipv6" >> /etc/modules
RUN apk update
RUN apk add curl \
  vim \
  zip unzip \
  man \
  less \
  groff

RUN apk add python \
  python3 \
  python-dev \
  python3-dev

RUN apk add gcc \
  make \
  musl-dev \
  libc-dev \
  libffi-dev \
  openssl-dev

ENV SETUP_DIR setup
RUN mkdir -p /${SETUP_DIR}
WORKDIR /${SETUP_DIR}

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

# Install Terraform
ENV TERRAFORM_VERSION 0.11.7
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip -d /usr/bin/ && rm terraform.zip

# Install Ansible
ENV ANSIBLE_VERSION 2.5.1
RUN pip install ansible==${ANSIBLE_VERSION}

# Install AWS CLI
ENV AWS_CLI_VERSION 1.15.62
RUN pip install awscli==${AWS_CLI_VERSION}

RUN mkdir -p /root/.aws

# Cleanup
RUN rm -rf ${SETUP_DIR}
