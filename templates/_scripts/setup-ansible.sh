#!/usr/bin/env bash

set -e
set -u
set -x

readonly RepoUrl="https://github.com/flaudisio/bootcamp-ansible-playbooks.git"
readonly RepoDir="/tmp/packer-ansible-playbooks"
readonly VenvDir="/tmp/packer-ansible-venv"

export DEBIAN_FRONTEND=noninteractive


install_system_deps()
{
    sudo -H apt update -q
    sudo -H apt install -q -y --no-install-recommends python3 python3-venv git make
}

install_ansible()
{
    rm -rf "$RepoDir"

    git clone --quiet --depth 1 --branch main "$RepoUrl" "$RepoDir"

    make -C "$RepoDir" install-all VENV_DIR="$VenvDir"

    export PATH="${PATH}:${VenvDir}/bin"
}

run_ansible_playbooks()
{
    pushd "$RepoDir"

    ansible-playbook --become --connection "local" --inventory "localhost," --verbose \
        playbooks/init-ansible-venv.yml

    popd
}

run_cleanup()
{
    rm -rf "$RepoDir" "$VenvDir"
}

main()
{
    trap run_cleanup EXIT

    install_system_deps
    install_ansible
    run_ansible_playbooks
}


main "$@"
