# OpenDialog Local Development

This package helps you get setup for local development using Docker. It could also be user to inform deployment of OpenDialog on an online virtual machine. 

This template is based on the [Laradock](https://laradock.io) project with (most) unnecessary components removed. 

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
* run `cp .env.example .env; php artisan key:generate;`
* Edit .env file and configure the app name, URL and DB settings
    * Use the database credentials you defined above.
    * Use 'mysql' for MySQL host
    * Use `server` for the DGraph host
* run `php artisan migrate` to setup tables
* run `php artisan user:create` to create a user
* run `bash update-web-chat.sh -iy` to build the webchat widget for interacting with the bot
* run `php artisan webchat:setup` to setup default values for webchat
* run `php artisan conversations:setup` to setup default conversations
* run `yarn install` and `yarn run dev` to setup the admin interface


### Confirm OpenDialog works

To ensure that it is all working visit http://opendialog.test, you should see the OpenDialog welcome screen and be able to login with the user you created. If you visit http://opendialog.test/admin/demo the bot should load in the page and give you the default welcome message.

### Confirm Dgraph works

To ensure that Dgraph is working visit http://opendialog.test:9001/?latest and point it to od-demo.test:8080

You should be able to use the console to run queries such as:

`{
  node(func: eq(ei_type,"conversation_template")) {
    uid
    expand(_all_)
  }
}`


## Working on OpenDialog Core and Webchat

The OpenDialog application is a Laravel application that makes use of [OpenDialog Core](https://github.com/opendialogai/core) and [OpenDialog Webchat](https://github.com/opendialogai/webchat) where a lot of the key functionality is present. If you want to work on those packages locally and checkout their git repositories you can use the following command:
`php artisan packages:install`

## Automated testing

To run automated tests with PHPUnit first ensure that phpunit.xml has the correct information for connecting to Dgraph.

`
<env name="DGRAPH_URL" value="server"/>
<env name="DGRAPH_PORT" value="8080"/>
`

You can then run `phpunit`






