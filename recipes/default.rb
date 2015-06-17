# Cookbook Name:: abiquo-collectd
# Recipe:: default
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

# Use the right package for each platform
node.set['collectd']['packages'] = [node['abiquo_collectd']['package']]

if node['platform'] == 'centos'
    # The collectd package is only in the EPEl repo
    include_recipe 'yum-epel'
end

include_recipe 'collectd-lib::packages'
include_recipe 'collectd-lib::directories'
include_recipe 'collectd-lib::config'
include_recipe 'collectd-lib::service'

cookbook_file "abiquo.py" do
    path "#{node['collectd']['plugin_dir']}/abiquo.py"
    action :create
end

collectd_conf 'collectd-abiquo' do
  plugin 'python' => { 'Globals' => true }
  conf  'ModulePath' => node['abiquo_collectd']['python_module_path'],
        'LogTraces' => node['abiquo_collectd']['log_traces'],
        'Interactive' => node['abiquo_collectd']['interactive'],
        'Import' => 'collectd-abiquo',
        %w(Module collectd-abiquo) => {
            'URL' => node['abiquo_collectd']['endpoint'],
            'AppKey' => node['abiquo_collectd']['app_key'],
            'AppSecret' => node['abiquo_collectd']['app_secret'],
            'AccessToken' => node['abiquo_collectd']['access_token'],
            'AccessTokenSecret' => node['abiquo_collectd']['access_token_secret']
        }
end
