#!/usr/bin/env bash
source /startup/tools.sh


set -e

info ">> Creating user and group"
info ">> User uid=${PUID}(${UNAME}) gid=${PGID}(${UNAME})"

if [[ "${UNAME}" != "root" ]]; then
    PUID="${PUID:-1000}"
    PGID="${PGID:-1000}"
    UMASK="${UMASK:-000}"

    if id -u "${PUID}" &>/dev/null; then
        # need to delete the old user $PUID then change $UNAME's UID
        # default ubuntu image comes with user `ubuntu` and UID 1000
        oldname=$(id -nu "${PUID}")
        userdel -r "${oldname}" &> /logs/userdel.log
    fi

    groupadd -f -g "${PGID}" ${UNAME} &> /logs/groupadd.log
    useradd -m -d ${HOME} -u "${PUID}" -g "${PGID}" -s /bin/bash ${UNAME} &> /logs/useradd.log

    umask "${UMASK}"

    chown "${PUID}:${PGID}" "${HOME}"

    chown -R "${PUID}:${PGID}" "${XDG_RUNTIME_DIR}"
else
    warn ">> Container running as root. Nothing to do. Do not use it, potentially unsafe"
fi

info ">> User created"
