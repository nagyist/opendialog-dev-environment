# OpenDialog Local Development

This package helps you get setup quickly for local development and can also be used to deploy OpenDialog in a single virtual machine online for testing purposes. 

This is a template created from the [Laradock](https://laradock.io) project with all unnecessary parts removed.

It allows you to spin up OpenDialog using pre-made docker images from Laradock along with the standard [Dgraph](https://dgraph.io) image.

We first walk through setting up the Docker environment and then setting up OpenDialog within that environment. 

## Setup Docker Environments

To deploy OpenDialog using this package run through the following steps:

+ Make sure the environment you are going to be working in (locally or on a VM) has Docker and Git installed

+ Create a directory called `od-app` (or whatever you prefer to call it, ensuring that any references of od-app in the documentation that follows is replaced by the name you chose).


+ Clone the OpenDialog [appication](https://github.com/opendialogai/opendialog) in a directory called `opendialog` (or your own app name) within od-app.

`git clone git@github.com:opendialogai/opendialog.git opendialog`

+ Clone the OpenDialog Deploy package (i.e. this package), in a directory named `opendialog-deploy`.

`git clone git@github.com:opendialogai/opendialog-deploy.git`

+ The folder structure should be (the names of the directories are important, if you change them to match your project name please follow through in all the other parts mentioned in this doc):
    
  ```
     + od-app
     ++ opendialog
     ++ opendialog-deploy
   ```

+ Create a copy of `opendialog-deploy/nginx/sites/opendialog.conf.example` in the same directory, and create `opendialog.conf` (or your own app name). This is your new vhost file, that handles nginx config. 
  Make sure the `server_name` is using the URL you want to use locally and that `root` is pointing to the correct directory (the `public` directory of the OpenDialog application cloned from GitHub). If you are not changing any of the defaults no change is required. 
+ Add the server name that you defined in the nginx configuration to /etc/hosts (e.g. `127.0.0.1 opendialog.test` )
+ Copy `env.example` to `.env`.
+ Change the `DATA_PATH_HOST` to `DATA_PATH_HOST=~/.laradock/opendialog/data` - this ensures that each application will have its own data directory so data will not be shared between multiple installations of OpenDialog apps. 
+ Modify COMPOSE_PROJECT_NAME to match `opendialog` (or your own app name) - this ensures that you are using different containers for each OpenDialog application.
+ Set `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` to appropriate values (you will use this when setting up OpenDialog itself as well)
+ If you change the value of `MYSQL_USER`, update the user in `mysql/docker-entrypoint-initdb.d/createdb.sql`

### Starting up the environment

From withing opendialog-deploy start all the containers with:
    
    `docker-compose up -d`

Please note that if you have another OpenDialog application up and running you may need to stop those containeds in order to avoid port clashing.     
    
This will start all containers including `workspace` and `dgraph ratel` which are not needed for production deploys. To run just the required containers, run

    `docker-compose up -d php-fpm mysql nginx zero server memcached`

Connect to the workspace container to run scripts with:
`docker-compose exec workspace bash`.

You are now ready to setup OpenDialog itself.

## Setting up OpenDialog

+ Connect to the workspace container as described above and run the following scripts to set the application up:

in `/var/www/opendialog`:

* run `composer install`
* run `cp .env.example .env; php artisan key:generate`
* Edit .env file and configure the app name, URL and DB settings
    * Use the database credentials you defined above.
    * Use 'mysql' for MySQL host
    * Use `server` for the DGraph host
* run `php artisan migrate` to setup tables
* run `php artisan user:create` to create a user
* run `bash update-web-chat.sh -iy` to build the webchat widget for interacting with the bot
* run `php artisan webchat:setup` to setup default values for webchat
* run `php artisan conversations:setup` to setup default conversations
* run `yarn add` and `yarn run dev` to setup the admin interface

## Testing 





