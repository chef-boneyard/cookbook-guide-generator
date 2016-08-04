# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: cookbook-guide-generator
# Recipe:: build_cookbook.rb
#
# Copyright 2016 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
context = ChefDK::Generator.context
delivery_project_dir = context.delivery_project_dir
dot_delivery_dir = File.join(delivery_project_dir, '.delivery')

directory dot_delivery_dir

cookbook_file File.join(dot_delivery_dir, 'config.json') do
  source 'delivery-config.json'
end

build_cookbook_dir = File.join(dot_delivery_dir, 'build-cookbook')

# cookbook root dir
directory build_cookbook_dir

# metadata.rb
template "#{build_cookbook_dir}/metadata.rb" do
  source 'build-cookbook/metadata.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# README
cookbook_file "#{build_cookbook_dir}/README.md" do
  source 'build-cookbook/README.md'
  action :create_if_missing
end

# LICENSE
template "#{build_cookbook_dir}/LICENSE" do
  source "LICENSE.#{context.license}.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{build_cookbook_dir}/chefignore"

# Berksfile
template "#{build_cookbook_dir}/Berksfile" do
  source 'build-cookbook/Berksfile.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes
directory "#{build_cookbook_dir}/recipes"

%w(default deploy functional lint provision publish quality security smoke syntax unit).each do |phase|
  template "#{build_cookbook_dir}/recipes/#{phase}.rb" do
    source 'build-cookbook/recipe.rb.erb'
    helpers(ChefDK::Generator::TemplateHelper)
    variables phase: phase
    action :create_if_missing
  end
end

# Test Kitchen build node
cookbook_file "#{build_cookbook_dir}/.kitchen.yml" do
  source 'build-cookbook/.kitchen.yml'
end

directory "#{build_cookbook_dir}/data_bags/keys" do
  recursive true
end

file "#{build_cookbook_dir}/data_bags/keys/delivery_builder_keys.json" do
  content '{"id": "delivery_builder_keys"}'
end

directory "#{build_cookbook_dir}/secrets"

file "#{build_cookbook_dir}/secrets/fakey-mcfakerton"

directory "#{build_cookbook_dir}/test/fixtures/cookbooks/test/recipes" do
  recursive true
end

file "#{build_cookbook_dir}/test/fixtures/cookbooks/test/metadata.rb" do
  content %(name 'test'
version '0.1.0')
end

cookbook_file "#{build_cookbook_dir}/test/fixtures/cookbooks/test/recipes/default.rb" do
  source 'build-cookbook/test-fixture-recipe.rb'
end

# Construct git history as if we did all the work in a feature branch which we
# merged into master at the end, which looks like this:
#
# ```
# git log --graph --oneline
# *   5fec5bd Merge branch 'add-delivery-configuration'
# |\
# | * 967bb9f Add generated delivery build cookbook
# | * 1558e0a Add generated delivery configuration
# |/
# * db22790 Add generated cookbook content
# ```
#
if context.have_git && context.delivery_project_git_initialized && !context.skip_git_init

  execute('git-create-feature-branch') do
    command('git checkout -t -b add-delivery-configuration')
    cwd delivery_project_dir
  end

  execute('git-add-delivery-config-json') do
    command('git add .delivery/config.json')
    cwd delivery_project_dir

    only_if 'git status --porcelain |grep "."'
  end

  execute('git-commit-delivery-config') do
    command('git commit -m "Add generated delivery configuration"')
    cwd delivery_project_dir

    only_if 'git status --porcelain |grep "."'
  end

  execute('git-add-delivery-build-cookbook-files') do
    command('git add .delivery')
    cwd delivery_project_dir

    only_if 'git status --porcelain |grep "."'
  end

  execute('git-commit-delivery-build-cookbook') do
    command('git commit -m "Add generated delivery build cookbook"')
    cwd delivery_project_dir

    only_if 'git status --porcelain |grep "."'
  end

  execute('git-return-to-master-branch') do
    command('git checkout master')
    cwd delivery_project_dir
  end

  execute('git-merge-delivery-config-branch') do
    command('git merge --no-ff add-delivery-configuration')
    cwd delivery_project_dir
  end

  execute('git-remove-delivery-config-branch') do
    command('git branch -d add-delivery-configuration')
    cwd delivery_project_dir
  end
end
