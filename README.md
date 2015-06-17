Abiquo collectd plugin
======================

[![Build Status](https://travis-ci.org/abiquo/abiquo-collectd.svg?branch=master)](https://travis-ci.org/abiquo/abiquo-collectd)

This cookbook provides a recipe to install the Abiquo collectd plugin.
It integrates any virtual machine deployed in the Abiquo platform with the
metrics system and allows them to push their own metrics to the Abiquo API.

## Requirements

The cookbook has been tested in the following platforms:

* CentOS 6.5
* Ubuntu 14.04

The cookbook depends on the following cookbooks:

* yum-epel
* collectd-lib

## Recipes

* `recipe[abiquo-collectd]` - Installs colelctd and the Abiquo monitoring plugin

## Attributes

The following attributes are under the `node['abiquo_collectd']` namespace.

Attribute | Description | Type | Mandatory | Default value
----------|-------------|------|-----------|--------------
`['endpoint']` | The endpoint where the plugin will push the metrics | String | Yes | nil
`['app_key']` | The OAuth application key used to authenticate to the Abiquo API | String | Yes | nil
`['app_secret']` | The OAuth application secret used to authenticate to the Abiquo API | String | Yes | nil
`['access_token']` | The OAuth access token used to authenticate to the Abiquo API | String | Yes | nil
`['access_token_secret']` | The OAuth access token secret used to authenticate to the Abiquo API | String | Yes | nil
`['python_module_path']` | The path where python modules are installed | String | No | /usr/lib/collectd
`['package']` | The name of the collectd package to install | String | No | collectd (collectd-core in Ubuntu)

# Usage

The cookbook is pretty straightforward to use. Just set all the mandatory attributes with the values for
the notification endpoint and the OAuth credentials, and include the `recipe[abiquo-collectd]` in the
run list.

# Testing

In order to test the cookbook you will need to install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
Once installed you can run the unit and integration tests as follows:

    bundle install
    bundle exec berks install   # Install the cookbook dependencies
    bundle exec rake            # Run the unit and style tests
    bundle exec rake kitchen    # Run the integration tests

# License and authors

* Author:: Enric Ruiz (enric.ruiz@abiquo.com)
* Author:: Ignasi Barrera (ignasi.barrera@abiquo.com)

Copyright:: 2015, Abiquo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
