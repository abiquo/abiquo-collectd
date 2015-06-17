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

require 'spec_helper'

describe 'abiquo-collectd::default' do
    let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
            node.set['abiquo_collectd']['endpoint'] = 'http://localhost'
            node.set['abiquo_collectd']['app_key'] = 'app-key'
            node.set['abiquo_collectd']['app_secret'] = 'app-secret'
            node.set['abiquo_collectd']['access_token'] = 'access-token'
            node.set['abiquo_collectd']['access_token_secret'] = 'access-token-secret'
        end
    end

    it 'uses the right Ubuntu package' do
        chef_run.node.automatic['platform'] = 'ubuntu'
        chef_run.converge(described_recipe)

        expect(chef_run.node['abiquo_collectd']['package']).to eq('collectd-core')
        expect(chef_run.node['collectd']['packages']).to eq(['collectd-core'])
    end

    it 'uses the right CentOS package and config' do
        chef_run.node.automatic['platform'] = 'centos'
        chef_run.converge(described_recipe)

        expect(chef_run.node['abiquo_collectd']['package']).to eq('collectd')
        expect(chef_run.node['collectd']['packages']).to eq(['collectd'])
        expect(chef_run.node['collectd']['conf_dir']).to eq('/etc')
    end

    it 'uses the right default package' do
        chef_run.node.automatic['platform'] = 'suse'
        chef_run.converge(described_recipe)

        expect(chef_run.node['abiquo_collectd']['package']).to eq('collectd')
        expect(chef_run.node['collectd']['packages']).to eq(['collectd'])
    end

    it 'installs and configures collectd' do
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe('collectd-lib::packages')
        expect(chef_run).to include_recipe('collectd-lib::directories')
        expect(chef_run).to include_recipe('collectd-lib::config')
        expect(chef_run).to include_recipe('collectd-lib::service')
    end

    it 'installs the python dependencies' do
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe('python::pip')
        expect(chef_run).to install_python_pip('requests').with(:version => '2.5.0')
        expect(chef_run).to install_python_pip('requests-oauthlib').with(:version => '0.4.2')
    end

    it 'uploads the Abiquo plugin script' do
        chef_run.converge(described_recipe)
        expect(chef_run).to create_cookbook_file('abiquo.py').with(
            :path => '/usr/lib/collectd/abiquo.py'
        )
    end

    it 'configures the Abiquo collectd plugin' do
        chef_run.converge(described_recipe)
        expect(chef_run).to create_collectd_conf('collectd-abiquo').with({
            :plugin => { 'python' => { 'Globals' => true } },
            :conf => { 'ModulePath' => '/usr/lib/collectd',
                'LogTraces' => true,
                'Interactive' => true,
                'Import' => 'collectd-abiquo',
                %w(Module collectd-abiquo) => {
                    'URL' => 'http://localhost',
                    'AppKey' => 'app-key',
                    'AppSecret' => 'app-secret',
                    'AccessToken' => 'access-token',
                    'AccessTokenSecret' => 'access-token-secret'
                }
            }
        })
    end
end
