#!/bin/bash -Eeu

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPTS_DIR="${ROOT_DIR}/scripts"

source "${SCRIPTS_DIR}/build_images.sh"
source "${SCRIPTS_DIR}/config.sh"
source "${SCRIPTS_DIR}/containers_down.sh"
source "${SCRIPTS_DIR}/containers_up_healthy_and_clean.sh"
source "${SCRIPTS_DIR}/copy_in_saver_test_data.sh"
source "${SCRIPTS_DIR}/create_docker_compose_yml.sh"
source "${SCRIPTS_DIR}/echo_seconds.sh"
source "${SCRIPTS_DIR}/exit_non_zero_unless_installed.sh"
source "${SCRIPTS_DIR}/exit_zero_if_build_only.sh"
source "${SCRIPTS_DIR}/exit_zero_if_show_help.sh"
source "${SCRIPTS_DIR}/ip_address.sh"
source "${SCRIPTS_DIR}/on_ci_publish_images.sh"
source "${SCRIPTS_DIR}/test_in_containers.sh"

export $(docker run --rm cyberdojo/versioner)

export CYBER_DOJO_MODEL_SHA=d67cbf7a91384e1c277e6bc781250540985316ca
export CYBER_DOJO_MODEL_TAG=d67cbf7

#- - - - - - - - - - - - - - - - - - - - - -
t1=$(echo_seconds)

exit_zero_if_show_help "$@"
exit_non_zero_unless_installed docker
exit_non_zero_unless_installed docker-compose

create_docker_compose_yml
build_images "$@"
exit_zero_if_build_only "$@"

server_up_healthy_and_clean "$@"
client_up_healthy_and_clean "$@"
copy_in_saver_test_data

test_in_containers "$@"

containers_down
on_ci_publish_images

t2=$(echo_seconds)
echo "script took $(( t2-t1)) seconds"