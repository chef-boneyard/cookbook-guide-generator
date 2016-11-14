# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: cookbook-guide-generator
# Recipe:: cookbook.rb
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
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

# cookbook root dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
  variables(issues: node['code_generator']['issues'],
            source: node['code_generator']['source'])
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# TESTING
template "#{cookbook_dir}/TESTING.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Rakefile
template "#{cookbook_dir}/Rakefile" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# License
template "#{cookbook_dir}/LICENSE" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Rubocop
template "#{cookbook_dir}/.rubocop.yml" do
  source 'rubocop.yml.erb'
  action :create_if_missing
end

# Travis
template "#{cookbook_dir}/.travis.yml" do
  source 'travis.yml.erb'
  action :create_if_missing
end

# contributing
template "#{cookbook_dir}/CONTRIBUTING.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

# Gemfile
cookbook_file "#{cookbook_dir}/Gemfile"

# Guardfile
cookbook_file "#{cookbook_dir}/Guardfile"

if context.use_berkshelf

  # Berks
  cookbook_file "#{cookbook_dir}/Berksfile" do
    action :create_if_missing
  end
else

  # Policyfile
  template "#{cookbook_dir}/Policyfile.rb" do
    source 'Policyfile.rb.erb'
    helpers(ChefDK::Generator::TemplateHelper)
  end

end

# TK & Serverspec
template "#{cookbook_dir}/.kitchen.yml" do
  if context.use_berkshelf
    source 'kitchen.yml.erb'
  else
    source 'kitchen_policyfile.yml.erb'
  end

  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{cookbook_dir}/test/integration/default/" do
  recursive true
end

template "#{cookbook_dir}/test/integration/default/default_spec.rb" do
  source 'inspec_default_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Chefspec
directory "#{cookbook_dir}/spec/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/spec/spec_helper.rb" do
  source 'spec_helper.rb'
  action :create_if_missing
end

template "#{cookbook_dir}/spec/unit/recipes/default_spec.rb" do
  source 'default_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source 'recipe.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# git
if context.have_git
  unless context.skip_git_init

    execute('initialize-git') do
      command('git init .')
      cwd cookbook_dir
    end

  end

  cookbook_file "#{cookbook_dir}/.gitignore" do
    source 'gitignore'
  end

  unless context.skip_git_init

    execute('git-add-new-files') do
      command('git add .')
      cwd cookbook_dir
    end

    execute('git-commit-new-files') do
      command('git commit -m "Add generated cookbook content"')
      cwd cookbook_dir
    end
  end
end

include_recipe 'code_generator::build_cookbook' if context.enable_delivery
