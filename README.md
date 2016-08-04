Chef Partner Cookbook-guide Generator
===================
[![Build Status](http://img.shields.io/travis/chef-partners/cookbook-guide-generator.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/chef-partners/cookbook-guide-generator.svg)][codeclimate]

[travis]: http://travis-ci.org/chef-partners/cookbook-guide-generator
[codeclimate]: https://codeclimate.com/github/chef-partners/cookbook-guide-generator

A Chef repo for a customized Chef-DK generator cookbook. See
`cookbooks/code_generator/README.md` for more details.

Requirements
============

This repo operates standalone with no cookbook dependencies.

Usage
=====

Download the repo and point `chef generate` at the cookbooks dir, e.g.

    chef generate cookbook -g ~/cookbook-guide-generator/cookbooks cookbook-name

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================

- Author: JJ Asghar <jj@chef.io>

Copyright 2016 Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

NOTE: I'd like to thank [RoboticCheese](https://github.com/RoboticCheese/) for creating his [repo](https://github.com/RoboticCheese/generator-chef-repo) as an influence and guide for me. :metal:
