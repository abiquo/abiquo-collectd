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

abiquo_writer_config = {
    'Authentication' => node['collectd_abiquo']['auth_type'],
    'URL' => node['collectd_abiquo']['endpoint'],
    'FlushIntervalSecs' => node['collectd_abiquo']['flush_interval_secs']
}

# The verify ssl must only be present when true
if node['collectd_abiquo']['verify_ssl']
    abiquo_writer_config['VerifySSL'] = node['collectd_abiquo']['verify_ssl']
end

case node['collectd_abiquo']['auth_type']
when 'oauth'
    abiquo_writer_config.merge!({
        'ApplicationKey' => node['collectd_abiquo']['app_key'],
        'ApplicationSecret' => node['collectd_abiquo']['app_secret'],
        'AccessToken' => node['collectd_abiquo']['access_token'],
        'AccessTokenSecret' => node['collectd_abiquo']['access_token_secret']
    })
when 'basic'
    abiquo_writer_config.merge!({
        'Username' => node['collectd_abiquo']['username'],
        'Password' => node['collectd_abiquo']['password']
    })
else
    Chef::Application.fatal!('Attribute node["collectd_abiquo"]["auth_type"] must "oauth" or "basic"')
end

collectd_conf 'abiquo-writer' do
    priority 15
    plugin 'python' => { 'Globals' => true }
    conf 'ModulePath' => node['collectd']['plugin_dir'],
        'LogTraces' => node['collectd_abiquo']['log_traces'],
        'Interactive' => false,
        'Import' => 'abiquo-writer',
        %w(Module abiquo-writer) => abiquo_writer_config
end
