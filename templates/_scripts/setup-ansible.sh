#!/usr/bin/env bash

set -e
set -u
set -x

readonly RepoUrl="https://github.com/flaudisio/bootcamp-ansible-playbooks.git"
readonly RepoDir="/tmp/packer-ansible-playbooks"
readonly VenvDir="/tmp/packer-ansible-venv"

export DEBIAN_FRONTEND="noninteractive"


install_system_deps()
{
    sudo -H apt-get update --quiet

    sudo -H apt-get install --quiet --yes --no-install-recommends \
        git \
        make \
        python3 \
        python3-venv
}

install_ansible()
{
    rm -rf "$RepoDir"

    git clone --quiet --depth 1 --branch main "$RepoUrl" "$RepoDir"

    make -C "$RepoDir" install-all VENV_DIR="$VenvDir"

    export PATH="${PATH}:${VenvDir}/bin"
}

run_ansible()
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
    run_ansible
}


main "$@"
