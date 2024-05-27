# Ubuntu 18.04, GAE and PHP 7.2

## Ensure Windows Subsystem for Linux is installed.

1. Windows Settings > Updates & Security > For Developers > True
2. Control Panel > Programs and Features > Turn Windows features on or off > Windows Subsystem for Linux > True
3. Microsoft store > Ubuntu 18.04 > Get

Set the username and password

	Installing, this may take a few minutes...
	Please create a default UNIX user account. The username does not need to match your Windows username.
	For more information visit: https://aka.ms/wslusers
	Enter new UNIX username: user
	Enter new UNIX password:
	Retype new UNIX password:
	passwd: password updated successfully
	Installation successful!
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.

## Start using the WSL from the commandline and install PHP

	C:\>wsl
    sudo apt-get install php
    php -v
    sudo apt-get install php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml php-bcmath php-sqlite3 libapache2-mod-php php-bcmath php-cgi

Install sqlite3 and create a database.

    sudo apt-get install sqlite3 php-sqlite3

Create a database like this

    sqlite3 data.sqlite
    SQLite version 3.8.5 2014-05-29 12:36:14
    Enter ".help" for usage hints.
    sqlite> create table tbl1(one varchar(10), two smallint);
    sqlite> insert into tbl1 values('hello!',10);
    sqlite> insert into tbl1 values('goodbye', 20);
    sqlite> select * from tbl1;
    hello!|10
    goodbye|20
    sqlite>.exit

Then run the built in server to confirm it works.  This is just running the built in PHP server so you can't use any of the GAE features.

    php -S localhost:8080

## Install GAE

The PHP extensions to GAE are not available via apt-get.  The latest version for Linux is available at <https://cloud.google.com/sdk/docs/#linux>.  So download, up pack it to /home/user and install.

    cd /home/user
    curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-224.0.0-linux-x86_64.tar.gz --output google-cloud-sdk.tar.gz
    tar zxvf google-cloud-sdk.tar.gz google-cloud-sdk
    ./google-cloud-sdk/install.sh
    gcloud components list
    gcloud components install app-engine-php
    ./google-cloud-sdk/install.sh

Confirm the location like this:

    gcloud info --format='value(installation.sdk_root)'

And then get the components.

    gcloud components list

    Your current Cloud SDK version is: 224.0.0
    The latest available version is: 224.0.0

    ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    │                                                  Components                                                 │
    ├───────────────┬──────────────────────────────────────────────────────┬──────────────────────────┬───────────┤
    │     Status    │                         Name                         │            ID            │    Size   │
    ├───────────────┼──────────────────────────────────────────────────────┼──────────────────────────┼───────────┤
    │ Not Installed │ App Engine Go Extensions                             │ app-engine-go            │  56.6 MiB │
    │ Not Installed │ Cloud Bigtable Command Line Tool                     │ cbt                      │   6.4 MiB │
    │ Not Installed │ Cloud Bigtable Emulator                              │ bigtable                 │   4.3 MiB │
    │ Not Installed │ Cloud Datalab Command Line Tool                      │ datalab                  │   < 1 MiB │
    │ Not Installed │ Cloud Datastore Emulator (Legacy)                    │ gcd-emulator             │  38.1 MiB │
    │ Not Installed │ Cloud Pub/Sub Emulator                               │ pubsub-emulator          │  33.4 MiB │
    │ Not Installed │ Cloud SQL Proxy                                      │ cloud_sql_proxy          │   3.8 MiB │
    │ Not Installed │ Emulator Reverse Proxy                               │ emulator-reverse-proxy   │  14.5 MiB │
    │ Not Installed │ Google Cloud Build Local Builder                     │ cloud-build-local        │   6.0 MiB │
    │ Not Installed │ Google Container Registry's Docker credential helper │ docker-credential-gcr    │   1.8 MiB │
    │ Not Installed │ gcloud Alpha Commands                                │ alpha                    │   < 1 MiB │
    │ Not Installed │ gcloud Beta Commands                                 │ beta                     │   < 1 MiB │
    │ Not Installed │ gcloud app Java Extensions                           │ app-engine-java          │ 108.8 MiB │
    │ Not Installed │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras │  28.5 MiB │
    │ Not Installed │ kubectl                                              │ kubectl                  │   < 1 MiB │
    │ Installed     │ BigQuery Command Line Tool                           │ bq                       │   < 1 MiB │
    │ Installed     │ Cloud Datastore Emulator                             │ cloud-datastore-emulator │  17.7 MiB │
    │ Installed     │ Cloud SDK Core Libraries                             │ core                     │   8.8 MiB │
    │ Installed     │ Cloud Storage Command Line Tool                      │ gsutil                   │   3.5 MiB │
    │ Installed     │ gcloud app PHP Extensions                            │ app-engine-php           │           │
    │ Installed     │ gcloud app Python Extensions                         │ app-engine-python        │   6.2 MiB │
    └───────────────┴──────────────────────────────────────────────────────┴──────────────────────────┴───────────┘

Run the Google App Engine version (and watch if fail)

     dev_appserver.py --php_executable_path=/usr/bin/php-cgi --support_datastore_emulator=False ./app.yaml

GAE expects a local php.ini in development so rename `php.ini.UbuntuGAE` to `php.ini` and edit appropriately.  It should then load up the right extensions.  FYI note that the php-cgi is used not the plain php engine.

## Deploy the Google App Engine

The Azure Pipeline `azure-pipelines.yml` deploys the application to <https://colonel-white.appspot.com/> using a special user which is set as `App Engine Admin` and `Cloud Build Service Account` on a Google App Engine project.  The pipeline output can be seen at <https://joejcollins.visualstudio.com/ColonelWhite>.

