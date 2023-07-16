#!/bin/sh

if [ -d "/run/secrets" ]; then
    echo "User secret key exists - move to ~/.ssh"
    mkdir -p /root/.ssh && ln -s /run/secrets/user_ssh_key /root/.ssh/id_rsa
    chown -R root:root /root/.ssh
    cat > /root/.ssh/config << EOF
Host ${DESTINATION}
    StrictHostKeyChecking no
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
EOF
fi

echo "$SCHEDULE flock -n /data /rsync.sh /data/ ${USER}@${DESTINATION}:${TARGET}" > /etc/crontabs/root
echo "Directory will be synced to ${USER}@${DESTINATION}:${TARGET} according to the following cron expression: ${SCHEDULE}"
## Always run under tini, since we need to reap the leftovers
exec /sbin/tini -- "$@"
