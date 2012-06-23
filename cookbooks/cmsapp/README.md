Application cookbook
====================

This cookbook is initially designed to be able to describe and deploy web applications. Currently supported:

* Rails
* Java
* Django
* PHP

Other application stacks (Rack, WSGI, etc) will be supported as new recipes at a later date.

This cookbook aims to provide primitives to install/deploy any kind of application driven entirely by data defined in an abstract way through a data bag.

Note that as of version 0.99.10, this cookbook uses Chef 0.10's environments instead of the `app_environment` attribute. If you do not set up any environments for your nodes, they will be in the `_default` environment. See __Usage__ below for information on how to set up environments.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

The following Opscode cookbooks are dependencies, as this cookbook supports automating a large number of web application stacks.

* runit
* unicorn
* passenger_apache2
* tomcat
* python
* gunicorn
* apache2
* php

Recipes
=======

The application cookbook contains the following recipes.

default
-------

Searches the `apps` data bag and checks that a server role in the app exists on this node, adds the app to the run state and uses the role for the app to locate the recipes that need to be used. The recipes listed in the "type" part of the data bag are included by this recipe, so only the "application" recipe needs to be in the node or role `run_list`.

See below regarding the application data bag structure.



mod_php_apache2
-----------------

Requires `apache2` cookbook. Sets up a mod_php vhost template for the application using the `apache2` cookbook's `web_app` definition. See data bag example below.

php
---

Using the node's `run_state` that contains the current application in the search, this recipe will:

* install required packages and pears/pecls
* set up the deployment scaffolding
* creates a `local_settings.php` (specific file name and project path is configurable) file with the database connection information if required
* performs a revision-based deploy

This recipe can be used on nodes that are going to run the application, or on nodes that need to have the application code checkout available such as supporting utility nodes or a configured load balancer that needs static assets stored in the application repository.

Since PHP projects do not have a standard `local_settings.php` file (or format) that contains database connection information. This recipe assumes you will provide a template in an application specific cookbook.  See additional notes in the 'Application Data Bag' section below.

Deprecated Recipes
==================

The following recipes are deprecated and have been removed from the cookbook. To retrieve an older version, reference commit 4396ce6.

* `passenger-nginx`
* `rails_nginx_ree_passenger`

Application Data Bag 
=====================

The applications data bag expects certain values in order to configure parts of the recipe. Below is a paste of the JSON, where the value is a description of the key. Use your own values, as required. Note that this data bag is also used by the `database` cookbook, so it will contain database information as well. Items that may be ambiguous have an example.

The application used in examples is named `my_app` and the environment is `production`. Most top-level keys are Arrays, and each top-level key has an entry that describes what it is for, followed by the example entries. Entries that are hashes themselves will have the description in the value. In order to use the environment `production` you must create the environment as described below under __Usage__.

Note about "type": the recipes listed in the "type" will be included in the run list via `include_recipe` in the application default recipe based on the type matching one of the `server_roles` values.

Note about packages, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the package provider.


PHP version additional notes
----------------------------

Note about `databases`, the data specified will be rendered as the `local_settings.php` file. In the `database` cookbook, this information is also used to set up privileges for the application user, and create the databases.

Note about pears/pecls, the version is optional. If specified, the version will be passed as a parameter to the resource. Otherwise it will use the latest available version per the default `:install` action for the php_pear package provider.

The `local_settings_file` value is used to supply the name, and relative local project path, for the environment specific `local_settings.php`, since PHP projects do not have a standard name (or location) for this file.

For applications that look for this file in the project root just supply a name:

MediaWiki:

    "local_settings_file": "LocalSettings.php"
    

The template used to render this `local_settings.php` file is assumed to be provided in an application specific cookbook named after the application being deployed.  For example if you were deploying code for an application named `mediawiki` you would create a cookbook named `mediawiki` and in that cookbook place a template named `LocalSettings.php.erb`:

    mediawiki/
    +-- files
    |   +-- default
    |       +-- schema.sql
    +-- metadata.rb
    +-- README.md
    +-- recipes
    |   +-- db_bootstrap.rb
    |   +-- default.rb
    +-- templates
        +-- default
            +-- LocalSettings.php.erb

The template will be passed the following variables which can be used to dynamically fill values in the ERB:

* path - fill path to the 'current' project path
* host - database master fqdn
* database - environment specific database information from the application's data bag item
* app - Ruby mash representation of the complete application data bag item for this app, useful if other arbitrary config data has been stashed in the data bag item.

A few example `local_settings` templates are included in this cookbook at `examples/templates/defaults/*`:

* MediaWiki - LocalSettings.php.erb


An example is data bag item is included in this cookbook at `examples/data_bags/apps/php_app.json`.

Usage
=====

To use the application cookbook, we recommend creating a role named after the application, e.g. `my_app`. This role should match one of the `server_roles` entries, that will correspond to a `type` entry, in the databag. Create a Ruby DSL role in your chef-repo, or create the role directly with knife.

    % knife role show my_app -Fj
    {
      "name": "my_app",
      "chef_type": "role",
      "json_class": "Chef::Role",
      "default_attributes": {
      },
      "description": "",
      "run_list": [
        "recipe[application]"
      ],
      "override_attributes": {
      }
    }

Also recommended is a cookbook named after the application, e.g. `my_app`, for additional application specific setup such as other config files for queues, search engines and other components of your application. The `my_app` recipe can be used in the run list of the role, if it includes the `application` recipe.

You should also create an environment. We use `production` in the examples and the documentation above. An example is in the source code's "examples" directory, and the JSON for an environment is below:

    % knife environment show production -Fj
    {
      "name": "production",
      "description": "",
      "cookbook_versions": {
      },
      "json_class": "Chef::Environment",
      "chef_type": "environment",
      "default_attributes": {
      },
      "override_attributes": {
      }
    }

Changes/Roadmap
===============




License and Author
==================


