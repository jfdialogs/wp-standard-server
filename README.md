# Standard WordPress Container
**Runnable Docker environment, using environment variable files.**

---
 
## Server Dock
 
To properly use the local runnable server, observe these commands:
 
 - **help**: Show these commands.
 - **start**: Start server. If no .env(.*) files are present, it will go through install routine.
 - **stop**: Run docker-compose stop on the relevent network services.
 - **setup**: Setup local database to match prod database. Requires .env.prod connection to be working.
 - **install**: Runs routine for installing .env(.*) files for installation purposes.
 - **uninstall**: Remove .env(.*) files and optionally data-related directory and files for hard reset.

## How to Use

```shell script
# 'server start' has an implicit install/setup feature.
./server start
./server stop
./server setup
./server install
./server uninstall
```

The use of `./` in the `./server` and other other script calls allows the file to be executed.

### Alternate Method
To call on the command line each individual script in the `/docker` folder, the 
`PROJECT_DIR` and `DOCKER_DIR` environment variables need to be provided. For instance:

```shell script
export PROJECT_DIR=/var/www
export DOCKER_DIR="$PROJECT_DIR/docker"

source "$DOCKER_DIR/setup-database-server"
source "$DOCKER_DIR/install-environment"
```

## Environment Files
Environment variables are the glue between the system and it's externalities. Use
the various `.env` files to pass critical settings and other errata used by the
system to determine a response to a request to take action of some kind.
