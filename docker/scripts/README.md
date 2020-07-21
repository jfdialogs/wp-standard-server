Create custom server scripts by copying a script from the Docker `server` folder into this folder, or create a new script using this boilerplate script:
```shell script
#!/usr/bin/env bash

if [ -z "$PROJECT_DIR" ] || [ -z "$DOCKER_DIR" ]; then
  echo "PROJECT_DIR and DOCKER_DIR are required."
else
  echo "This command will [describe scripts purpose]."
  echo ""
  
  # Do something with shell scripts.
  #
  # When using other shell scripts, call them through the front controller:
  #
  #   "$PROJECT_DIR/server" some-other-command
fi
```
When copying current script, the script in the Docker `scripts` directory will take precedence (override). It is recommended to always copy scripts to this directory in a project, instead of editing scripts for customizing for a project directly in the `server` directory.

Additionally, scripts added to the Docker `scripts` directory do not need to be added to the project's `server` front controller script as a command, which means no deployment validation occurs. In these scenarios, use the following boilerplate script:
```shell script
#!/usr/bin/env bash

if [ -z "$PROJECT_DIR" ] || [ -z "$DOCKER_DIR" ]; then
  echo "PROJECT_DIR and DOCKER_DIR are required."
elif [ -z "$DEPLOY_ENV" ] || [ "$DEPLOY_ENV" != local ]; then
  echo "[Edit this message! This will block this script from running except in a local deployment.]"
else
  echo "This command will [describe scripts purpose]."
  echo ""
  
  # Do something with shell scripts.
  #
  # When using other shell scripts, call them through the front controller:
  #
  #   "$PROJECT_DIR/server" some-other-command
fi
```
