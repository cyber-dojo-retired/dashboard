#!/bin/bash -Eeu

create_docker_compose_yml()
{
  echo_docker_compose_yml > ${ROOT_DIR}/docker-compose.yml
}

echo_docker_compose_yml()
{
# Use un-expanded ${COMMIT_TAG} to avoid needless git churn.
# Note tests/ is volume-mapped to test/ because
# of an implementation dependency in cyberdojo/check-test-results
# See scripts/test_in_containers.sh
cat <<-EOF
# This file was auto-generated by .../sh/create_docker_compose_yml.sh
# It is used by ../scripts/augmented_docker_compose.sh
# which saves a copy of the fully-augmented docker-compose.yml
# generated for each ./build_test_publish.sh command
# in /tmp/augmented-docker-compose.dashboard.peek.yml

version: '3.7'

services:

  nginx:
    build:
      context: $(sources_dir)/nginx_stub
    container_name: test_dashboard_nginx
    depends_on:
      - $(client_name)
    image: cyberdojo/nginx_dashboard_stub
    ports: [ ${CYBER_DOJO_NGINX_PORT}:${CYBER_DOJO_NGINX_PORT} ]
    user: root

  $(client_name):
    image: $(client_image):\${COMMIT_TAG}
    user: $(client_user)
    build:
      args: [ COMMIT_SHA ]
      context: $(sources_dir)/$(client_name)
    container_name: $(client_container)
    depends_on:
      - $(server_name)
    env_file: [ .env ]
    ports: [ $(client_port):$(client_port) ]
    read_only: true
    restart: "no"
    tmpfs: /tmp
    volumes:
      - ./$(sources_dir)/$(client_name):/app:ro
      - ./$(tests_dir):/test:ro

  $(server_name):
    image: $(server_image):\${COMMIT_TAG}
    user: $(server_user)
    build:
      args: [ COMMIT_SHA ]
      context: $(sources_dir)/$(server_name)
    container_name: $(server_container)
    depends_on:
      - differ
      - saver
    env_file: [ .env ]
    ports: [ $(server_port):$(server_port) ]
    read_only: true
    restart: "no"
    tmpfs: /tmp
    volumes:
      - ./$(sources_dir)/$(server_name):/app:ro
      - ./$(tests_dir):/test:ro
EOF
}
