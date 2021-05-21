# OpenDialog Local Development

This package helps you get setup for local development using Docker. It is based on the [Laradock](https://laradock.io) project with (most) unnecessary components removed and allows you to spin up OpenDialog using pre-made docker images from Laradock, the standard [Dgraph](https://dgraph.io) images and the OpenDialog source code.

We first walk through setting up the Docker environment and then setting up OpenDialog within that environment. 

## Setup Docker Environments

To deploy OpenDialog using this package run through the following steps:

+ Make sure the environment you are going to be working in (locally or on a VM) has Docker and Git installed

+ Create a directory called `od-app` (or whatever you prefer to call it, ensuring that any references of od-app in the documentation that follows is replaced by the name you chose).


+ Clone the OpenDialog [application](https://github.com/opendialogai/opendialog) in a directory called `opendialog` (or your own app name) within od-app.

`git clone git@github.com:opendialogai/opendialog.git opendialog`

+ Clone the OpenDialog Dev package (i.e. this package), in a directory named `opendialog-dev-environment`.

`git clone git@github.com:opendialogai/opendialog-dev-environment.git`

+ The folder structure should resemble the example below (the names of the directories are important, if you change them to match your project name please follow through in all the other parts mentioned in this doc):
    
  ```
     + od-app
     ++ opendialog
     ++ opendialog-dev-environment
   ```

+ Create a copy of `opendialog-dev-environment/nginx/sites/opendialog.conf.example` in the same directory, and create `opendialog.conf` (or your own app name). This is your new vhost file, that handles nginx config. 
  Make sure the `server_name` is using the URL you want to use locally and that `root` is pointing to the correct directory (the `public` directory of the OpenDialog application cloned from GitHub). If you are not changing any of the defaults no change is required. 
+ Add the server name that you defined in the nginx configuration to /etc/hosts (e.g. `127.0.0.1 opendialog.test` )
+ Within the `opendialog-dev-environment` directory copy `env.example` to `.env`.
+ In `.env`, change the `DATA_PATH_HOST` to `DATA_PATH_HOST=~/.laradock/opendialog/data` - this ensures that each application will have its own data directory so data will not be shared between multiple installations of OpenDialog apps. 
+ Modify COMPOSE_PROJECT_NAME to match `opendialog` (or your own app name) - this ensures that you are using different containers for each OpenDialog application.
+ In your copy of `.env` you can set `CHOSEN_DATABASE` to be `mysql` or `postgres`. This will affect which images are spun up by the scripts.
+ If you require a different version of DGraph for your project, update `DGRAPH_VERSION` in your copy of `.env` to the version you require
+ Set `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD`  (or the PostgreSQL values based on the DB choice) to appropriate values (you will use this when setting up OpenDialog itself as well)
+ If you change the value of `MYSQL_USER`, update the user in `mysql/docker-entrypoint-initdb.d/createdb.sql` (similarly for PostgreSQL)

### Starting up the environment

From within opendialog-dev-environment start all the containers with:
    
    `docker-compose up -d`

Please note that if you have another OpenDialog application (or other Docker containers in general) up and running you may need to stop those containers in order to avoid port clashing.     
    
`docker-compose up -d` will start all containers including `workspace`,  `dgraph ratel`, `dgraph-zero-test` and `dgraph-server-test` which are not needed to just test an application. 

To run just the required containers, run

    `bash scripts/start.sh`

To connect to the workspace container to run scripts use:

    `bash scripts/ssh-workspace.sh`

This will start up the workspace container for you to work in and then close it when you exit

You are now ready to setup OpenDialog itself.

## Setting up OpenDialog

+ Connect to the workspace container as described above and run the following commands through that container to set the application up:

in `/var/www/opendialog`:

* run `composer install`
* run `cp .env.example .env; php artisan key:generate;`
* in `.env` ensure that `FORCE_HTTPS=false` is set to false as the dev setup does not use certificates currently
* Edit .env file and configure the app name, URL and DB settings
    * Use the database credentials you defined above.
    * Use 'mysql' for MySQL host
    * Use `dgraph-server` for the DGraph host
* run `php artisan migrate` to setup tables
* run `php artisan user:create` to create a user
* run `php artisan configurations:create` to create the default component configurations
* run `php artisan webchat:setup` to setup default values for webchat
* run `php artisan schema:init` to setup the Dgraph schema
* run `yarn install` and `yarn run dev` to setup the admin interface


### Confirm OpenDialog works

To ensure that it is all working visit http://opendialog.test, you should see the OpenDialog welcome screen and be able to login with the user you created. 

Visit http://opendialog.test/admin/conversations and ensure that the imported conversations are there and activated. 

Finally, if you visit http://opendialog.test/admin/demo the bot should load in the page and give you the default welcome message.

### Confirm Dgraph works

To ensure that Dgraph is working visit http://opendialog.test:9001/?latest and point it to http://opendialog.test:8080

You should be able to use the console to run queries such as:

``{
  node(func: eq(ei_type,"conversation_template")) {
    uid
    expand(_all_)
  }
}``

## Bundled Scripts

This application comes bundled with some useful scripts in the `/scripts` directory. As much as possible, these should
be used to perform commands as they will also deal with spinning up and down the requried containers.

A brief description of each:

* `build-php.sh` - Rebuilds any containers that use PHP. Useful if you change php settings in `.env`
* `reload-nginx.sh` - Reload Nginx in the Nginx container. Use this is you have altered Nginx config
* `ssh-nginx.sh` - SSH to the nginx container
* `ssh-workspace.sh` - SSH to the Workspace container
* `start.sh` - Starts only the containers needed to run the app. Will not start workspace or test containers
* `start-test-containers.sh` - Starts the containers needed for running tests
* `start-workspace.sh` - Starts only the workspace and related containers
* `stop-test-containers.sh` - Stops all test containers
* `stop-workspace.sh` - Stops the workspace container 
* `up-with-rebuild.sh` - Spins rebuilds and starts the core containers 
* `update-conversations.sh` - Makes sure the right containers are running and installs the newest OD conversations
* `update-opendialog.sh` - Installs the latest composer and node requirements on the project as well as the webchat component
* `update-webchat-settings.sh` - Updates the webchat settings based on the artisan command

## Automated testing

To run automated tests with PHPUnit first ensure that phpunit.xml has the correct information for connecting to Dgraph.

`
<env name="DGRAPH_URL" value="dgraph-server-test"/>
<env name="DGRAPH_PORT" value="8082"/>
`

Test suites run against 2 test DGraph containers `dgraph-zero-test` and `dgraph-server-test` and these must be running
before you can run tests. Keep in mind that this is a separate Dgraph instance, so it will not be changing any data that
the application itself is using.  

You can spin up the required containers, login to the workspace environment and then run the tests 

        bash scripts/start-test-containers.sh
        bash scripts/ssh-workspace.sh
        cd opendialog
        phpunit

## Setting up xDebug

- Open the .env file, search for `WORKSPACE_INSTALL_XDEBUG` and set it to `true`
- Still in .env, search for `PHP_FPM_INSTALL_XDEBUG` and set that to `true`
- Rebuild the containers with `docker-compose build workspace php-fpm`


## Configuring PHPStorm

The OpenDialog team is primarily on PhpStorm but these instructions should give you a sense of what is required for any similar IDE.

- In Preferences > Languages & Frameworks > PHP next to the CLI Interpreter drop-down click on the three dotted lines to add a new interpreter.
- Click on + and select "From Docker, Vagrant, VM Remote"
- In the "Configure Remote PHP Interpreter pop-up select Docker Compose"
- Then add the Docker Compose configuration file that is in opendialog-dev-environment.
- PhpStorm will automatically pick-up the available services, select `workspace` from the drop-down. Confirm to close the pop-up.
- In CLI Interpreters next to "php executable" click the reload phpinfo button. If that is succesfully retrieving the phpinfo you are one step closer.
- Confirm the interpreter and in the following page add path mappings from whatever your local path is to the root of the OpenDialog application to `/var/www/opendialog/`.
- Next go to Preferences > Languages & Frameworks > PHP > Test Frameworks and add 'PHPUnit by Remote Interpreter' and select the `workspace` interpreter.
- Make sure that "Use Composer Autoloader" is selected and add `/var/www/opendialog/vendor/autoload.php` as the path to script.
- Hit Refresh next to the "Path to Script" field. If it correctly identifies the PHPUnit version installed you should be good to go. 


## Working on OpenDialog Core

You can use this same environment to work on [OpenDialog Core](https://github.com/opendialogai/core) on its own. Clone the [core](https://github.com/opendialogai/core) repository within the `od-app` directory and you can access it through the `workspace` container to run tests. From an IDE perspective you could either setup a different PHPStorm environment to set the paths correctly or update your existing configurationt to match paths to the core repository. 

## Local Package Development

If you want to work on Core or Webchat as repositories while they are used by the main OpenDialog application follow the instructions here. 

The `packages:install` artisan command will checkout and symlink `opendialog-core` and / or `opendialog-webchat` to a `vendor-local` directory.

To install dependencies using it, you can run `artisan packages:install`. You will be asked if you want to use local versions of core and webchat.
If so, you can now use, edit and version control these repositories directly from your `vendor-local` directory.

After doing so, you may need to run `php artisan package:discover` to pick up any new modules.

Note:
Before a final commit for a feature / fix, please be sure to run `composer update` to update the `composer-lock.json` file so that it can be tested and deployed with all composer changes in place

### Reverting

To revert back to the dependencies defined in `composer.json`, run the `artisan packages:install` command again and answer no to installing core and webchat locally.

## Running Code Sniffer
To run code sniffer, run the following command
```./vendor/bin/phpcs --standard=od-cs-ruleset.xml app/ --ignore=*/migrations/*,*/tests/*```

## Git Hooks

To set up the included git pre-commit hook, first make sure the pre-commit script is executable by running

```chmod +x .githooks/pre-commit```

Then configure your local git to use this directory for git hooks by running:

```git config core.hooksPath .githooks/```

Now every commit you make will trigger php codesniffer to run. If there is a problem with the formatting
of the code, the script will echo the output of php codesniffer. If there are no issues, the commit will
go into git.






