# Periodic rsync

Use docker instead of system crontab to sync directories

# General

We mount the local data source to be synced to the docker `/data` mount point and set a `DESTINATION` in args:
```
services:
  rsync:
    restart: unless-stopped
    build:
      context: ./periodic-rsync
      dockerfile: Dockerfile
      args:
        - DESTINATION=x.x.x.x
    volumes:
      - "./directory-to-sync:/data"
    environment:
      - USER=username
      - TARGET=directory
      - SCHEDULE=30 9 * * 1-5 # Every weekday (Monday to Friday) at 9:30 AM
    # If your destination requires ssh authentication
    # The service references the secret file defined in docker-compose `secrets`
    secrets:
      - user_ssh_key
# Top-level secrets in your compose file
secrets:
  user_ssh_key:
    file: ~/.ssh/id_rsa # Path to ssh key on your host system with rsync rights to the destination
```

# Build args

We require the following build args:
  - DESTINATION: (required) Destination IP or domain

# Environment

This container takes the following environment variables:
  - USER: (required) The username that has the necessary ssh rights on the destination
  - TARGET: The target directory on the destination host (default is /)
  - SCHEDULE: A cron expression that defines how often rsync is run (default is every hour)

# Secret

If you require an ssh key for rsync, you can create a `secrets` entry both in the service and at the top level of docker-compose:

The `secrets` attribute in the service should match the name of the secret in the top-level `secrets` element:

```
services:
  service:
    ...
    secrets:
      - user_ssh_key
secrets:
  user_ssh_key:
    file: ~/.ssh/id_rsa # Path to ssh key on your host system granting ssh rights to the destination
```
