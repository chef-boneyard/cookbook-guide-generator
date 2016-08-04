# encoding: utf-8
# frozen_string_literal: true

require 'rubygems'
require 'English'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'

RuboCop::RakeTask.new

FoodCritic::Rake::LintTask.new do |f|
  f.options = { fail_tags: %w(any),
                cookbook_paths: %w(cookbooks/code_generator) }
end

task default: %w(rubocop foodcritic)
