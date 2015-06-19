Chef cookbook for the abiquo-writer collectd plugin
===================================================

[![Build Status](https://travis-ci.org/abiquo/collectd-abiquo-cookbook.svg?branch=master)](https://travis-ci.org/abiquo/collectd-abiquo-cookbook)

This cookbook provides a recipe to install the [Abiquo collectd plugin](https://github.com/abiquo/collectd-abiquo).
It integrates any virtual machine deployed in the Abiquo platform with the
metrics system and allows them to push their own metrics to the Abiquo API.

## Requirements

The cookbook has been tested in the following platforms:

* CentOS 6.5
* Ubuntu 14.04

The cookbook depends on the following cookbooks:

* collectd-lib
* python
* yum-epel

## Recipes

* `recipe[collectd-abiquo]` - Installs collectd and the Abiquo monitoring plugin
* `recipe[collectd-abiquo::collectd]` - Installs and configures collectd and the default plugins
* `recipe[collectd-abiquo::plugin]` - Installs and configures the Abiquo collectd plugin

## Attributes

The following attributes are under the `node['collectd_abiquo']` namespace.

Attribute | Description | Type | Mandatory | Default value
----------|-------------|------|-----------|--------------
`['endpoint']` | The endpoint where the plugin will push the metrics | String | Yes | nil
`['auth_type']` | The authentication method used to push metrics to the Abiquo API (basic | oauth) | String | No | 'oauth'
`['username']` | The username used to authenticate to the Abiquo API | String | When using basic auth | nil
`['password']` | The password used to authenticate to the Abiquo API | String | When using basic auth | nil
`['app_key']` | The OAuth application key used to authenticate to the Abiquo API | String | When using OAuth | nil
`['app_secret']` | The OAuth application secret used to authenticate to the Abiquo API | String | When using OAuth | nil
`['access_token']` | The OAuth access token used to authenticate to the Abiquo API | String | When using OAuth | nil
`['access_token_secret']` | The OAuth access token secret used to authenticate to the Abiquo API | String | When using OAuth | nil
`['python_module_path']` | The path where python modules are installed | String | No | /usr/lib/collectd
`['packages']` | The names of the collectd packages to install | List | No | \['collectd'\] (\['collectd-core', 'libpython2.7'\] in Ubuntu)
`['plugins']` | The names of the default collectd plugins to install | List | No | \['cpu', 'disk', 'interface'\]
`['log_traces']` | Enables the Abiquo plugin log | Boolean | No | true
`['version']` | The version of the Abiquo plugin to install | String | No | master
`['url']` | The URL of the Abiquo plugin file | String | Yes | https://rawgit.com/abiquo/collectd-abiquo/master/abiquo-writer.py 
`['verify_ssl']` | Enable SSL validation when pushing the metrics | Boolean | No | false
`['flush_interval_secs']` | Interval in which the metrics are pushed, in seconds | Integer | No | 30

# Usage

The cookbook is pretty straightforward to use. Just set all the mandatory attributes with the values for
the notification endpoint and the OAuth credentials, and include the `recipe[collectd-abiquo]` in the
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
