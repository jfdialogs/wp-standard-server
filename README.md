# Standard WordPress Container
**Runnable WordPress Docker environment.**

---
 
## Server Dock
 
The following commands are available:
 
 - **help**: Show these commands.
 - **start**: Start running the container. If no `.env(.*)` files are present, it will go through install routine.
 - **stop**: Run `docker-compose stop` on the relevent network services and environment settings.
 - **setup**: Setup local database to match prod database. Requires `.env.prod` connection to be working.
 - **install**: Runs routine for installing `.env(.*)` files for installation purposes.
 - **uninstall**: Remove `.env(.*)` files and optionally data-related directory and files for hard reset.
 
Other commands:

 - **use-app**: Open interactive shell in running (web) `app` container environment.
 - **use-data**: Open interactive shell in running (mysql) `data` container environment.

## How to Use

```shell script
$ ./server start         # Runs docker-compose up.
$ ./server stop          # Runs docker-compose stop.
$ ./server setup         # Dump and replace local database with PROD data using .env.prod settings.
$ ./server install       # Install environment files with interactive prompts.
$ ./server uninstall     # Remove environment files and optionally data/local database.
$ ./server use-app       # Open shell into local (web) app container.
$ ./server use-data      # Open shell into local (mysql) data container.
```

### Alternate Method
To call on the command line each individual script in the `/docker` folder, the 
`PROJECT_DIR` and `DOCKER_DIR` environment variables need to be provided. For instance:

```shell script
export PROJECT_DIR=/var/www
export DOCKER_DIR="$PROJECT_DIR/docker"

# These are both called implicitly during './server start'.
source "$DOCKER_DIR/install-environment"
source "$DOCKER_DIR/setup-database-server"
```

## Environment Files
Environment variables are used to pass contextual configuration such as connection 
information, service configuration and other needed settings and context to the 
application container. Use the various `.env` files to pass critical settings and 
other errata used by the container for request resolution.

### Environment Variables

### `.env`
Used to store application-level concerns. The `.env` is read before Docker Compose 
loads, variables placed in this file are available in the `compose-local.yaml`
container server configuration.

- `PROJECT_KEY`: Used for the container name; e.g. `project-name`.
- `APP_ENV`: Use `dev`, `test` or `prod`.
- `WEB_PORT`: Used for running the container's request port.

### `.env.local`

These are the actual settings for the Wordpress docker installation. These are used
primarily by the WordPress image.

- `WORDPRESS_DB_HOST`: Generated with the given `PROJECT_KEY`, e.g. `project-name-data`.
- `WORDPRESS_DB_NAME`: Name of database to use.
- `WORDPRESS_DB_USER`: Database user for project.
- `WORDPRESS_DB_PASSWORD`: Database user password.

> **Note** The following keys are used for configuring the MySQL service on first
> run. These should be copies of the `WORDPRESS` environment variables and are
> automatically copied when using the install script.
>
> - `MYSQL_DATABASE`
> - `MYSQL_USER`
> - `MYSQL_PASSWORD`

### `.env.prod`

- `PROD_DB_HOST`: Remote host url to MySQL instance.
- `PROD_DB_PORT`: Port to access on remote, required.
- `PROD_DB_NAME`: Database name of remote.
- `PROD_DB_USER`: Database user on remote.
- `PROD_DB_PASSWORD`: Database user password on remote.
