# frozen_string_literal: true

require 'English'
require 'bundler/setup'
require 'cookstyle'
require 'rubocop/rake_task'
require 'foodcritic'

RuboCop::RakeTask.new

FoodCritic::Rake::LintTask.new do |f|
  f.options = { fail_tags: %w(any),
                cookbook_paths: %w(cookbooks/code_generator) }
end

task default: %w(rubocop foodcritic)
