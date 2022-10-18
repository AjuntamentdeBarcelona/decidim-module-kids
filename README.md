# Decidim for Kids module

[![[CI] Lint](https://github.com/AjuntamentdeBarcelona/decidim-module-kids/actions/workflows/lint.yml/badge.svg)](https://github.com/AjuntamentdeBarcelona/decidim-module-kids/actions/workflows/lint.yml)
[![[CI] Test](https://github.com/AjuntamentdeBarcelona/decidim-module-kids/actions/workflows/test.yml/badge.svg)](https://github.com/AjuntamentdeBarcelona/decidim-module-kids/actions/workflows/test.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/82ab16cdaa0aa5d61d48/maintainability)](https://codeclimate.com/github/AjuntamentdeBarcelona/decidim-module-kids/maintainability)
[![codecov](https://codecov.io/gh/AjuntamentdeBarcelona/decidim-module-kids/branch/main/graph/badge.svg?token=X11YWWSMO4)](https://codecov.io/gh/AjuntamentdeBarcelona/decidim-module-kids)
[![Gem Version](https://badge.fury.io/rb/decidim-kids.svg)](https://badge.fury.io/rb/decidim-kids)

Module developed by Barcelona City Council to promote kids participation.

> NOTE: in development, not ready for production.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-kids', git: "https://github.com/AjuntamentdeBarcelona/decidim-module-kids"
```

And then execute:

```
bundle
bundle exec rails decidim_kids:install:migrations
```

## Usage

This module should work out of the box jut by adding it to your Gemfile.

However, if you wish to customize some of the default values, you can create an initializer and configure
any of the variables listed below:


```ruby
# config/initializers/decidim_kids.rb

Decidim::Kids.configure do |config|
  # If true, minor participation is enabled by default in any newly created organization
  config_accessor :enable_minors_participation do
    false
  end

  # Default value for the minimum age required for a minor in order to create an account
  config_accessor :minimum_minor_age do
    10
  end

  # Default value for the legal age of consent to create a minor account without parental permission
  config_accessor :minimum_adult_age do
    14
  end
end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AjuntamentdeBarcelona/decidim-module-kids.

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bin/rails s
```

Note that `bin/rails` is a convinient wrapper around the command `cd development_app; bundle exec rails`.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Webpacker notes

As latests versions of Decidim, this repository uses Webpacker for Rails. This means that compilation
of assets is required everytime a Javascript or CSS file is modified. Usually, this happens
automatically, but in some cases (specially when actively changes that type of files) you want to 
speed up the process. 

To do that, start in a separate terminal than the one with `bin/rails s`, and BEFORE it, the following command:

```
bin/webpack-dev-server
```

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
$ bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

#### Non-Ruby Code Styling

There are other linters for Javascript and CSS. These run using NPM packages. You can
run the following commands:

1. `npm run lint`: Runs the linter for Javascript files.
2. `npm run lint-fix`: Automatically fix issues for Javascript files (if possible).
3. `npm run stylelint`: Runs the linter for SCSS files.
4. `npm run stylelint-fix`: Automatically fix issues for SCSS files (if possible).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

https://crowdin.com/project/decidim-kids

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
