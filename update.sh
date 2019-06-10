#!/bin/bash

set -eu

# Refresh frequency in seconds
readonly FREQ="${FREQ:-300}"
# Run only once
readonly ONLY_ONCE="${ONLY_ONCE:-false}"
# Show all commands run (will log password)
readonly VERBOSE="${VERBOSE:-false}"
# Show response
readonly SHOW_RESPONSE="${SHOW_RESPONSE:-true}"

# Password to refresh the DDNS register
readonly PASSWORD="${PASSWORD}"
# Domain to update IP for
readonly DOMAIN="${DOMAIN}"

# list of hosts from args
readonly HOSTS=( "$@" )

if [ ${#HOSTS[@]} -eq 0 ]; then
    echo "in: $@"
    echo "You need to pass at least one host."
    exit 1
fi

while true; do
    ip="$(curl -s https://ipinfo.io/ip)"

    echo "Updating DDNS registries for ${HOSTS[*]}:"
    for host in ${HOSTS[@]}; do
        url="https://dynamicdns.park-your-domain.com/update?host=${host}&domain=${DOMAIN}&password=${PASSWORD}&ip=${ip}"

        cmd="curl -s ${url}"
        if ${VERBOSE}; then
            cmd="curl -v ${url}"
        fi

        rm -f /tmp/ddns.log
        set +e
        ${cmd} &> /tmp/ddns.log
        retval=$?

        grep "No Records updated." /tmp/ddns.log > /dev/null
        norecord=$?
        set -e

        if [ ${retval} -eq 0 ] && [ ${norecord} -eq 1 ]; then
            echo -e " \033[32mOK\e[0m  -> ${host}.${DOMAIN} ${ip}"
        else
            echo -e " \033[31mFAIL\e[0m -> ${host}.${DOMAIN} ${ip}"
            if [ ${norecord} -ne 0 ]; then
                echo -e "     \033[33mRecord '${host}' not found\e[0m"
            fi
        fi

        if ${VERBOSE} || ${SHOW_RESPONSE} || [ ${retval} -ne 0 ] || [ ${norecord} -ne 1 ]; then
            echo -e "     \033[94mexecuted:\e[0m ${cmd}"
            echo -e "     \033[94mreturned:\e[0m ${retval}"
            echo -e "     \033[94mlog:\e[0m"
            cat /tmp/ddns.log
        fi
        echo -e "\n\n"
    done

    if ${ONLY_ONCE}; then
        exit 0
    fi
    echo "Next refresh in ${FREQ} seconds..."
    sleep ${FREQ}
done
