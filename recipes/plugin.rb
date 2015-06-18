# Cookbook Name:: collectd-abiquo
# Recipe:: plugin
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

include_recipe 'python::pip'

python_pip 'requests' do
    version '2.5.0'
end

python_pip 'requests-oauthlib' do
    version '0.4.2'
end

remote_file "#{node['collectd']['plugin_dir']}/abiquo-writer.py" do
    source node['collectd_abiquo']['url']
end

collectd_conf 'abiquo-writer' do
    priority 15
    plugin 'python' => { 'Globals' => true }
    conf 'ModulePath' => node['collectd']['plugin_dir'],
        'LogTraces' => node['collectd_abiquo']['log_traces'],
        'Interactive' => false,
        'Import' => 'abiquo-writer',
        %w(Module abiquo-writer) => {
            'Authentication' => 'oauth',
            'URL' => node['collectd_abiquo']['endpoint'],
            'ApplicationKey' => node['collectd_abiquo']['app_key'],
            'ApplicationSecret' => node['collectd_abiquo']['app_secret'],
            'AccessToken' => node['collectd_abiquo']['access_token'],
            'AccessTokenSecret' => node['collectd_abiquo']['access_token_secret']
        }
end
