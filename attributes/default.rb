# Cookbook Name:: abiquo-collectd
# Attributes:: abiquo-collectd
#
# Copyright 2014, Abiquo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Package to install
case node['platform']
when 'ubuntu'
    default['abiquo_collectd']['package'] = 'collectd-core'
when 'centos'
    override['collectd']['conf_dir'] = '/etc'
    default['abiquo_collectd']['package'] = 'collectd'
else
    default['abiquo_collectd']['package'] = 'collectd'
end

# Collectd plugin configuration
default['abiquo_collectd']['log_traces'] = true
default['abiquo_collectd']['interactive'] = true
default['abiquo_collectd']['python_module_path'] = '/usr/lib/collectd'
