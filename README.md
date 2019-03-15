# Create Ruby App
[![Build Status](https://travis-ci.org/majjoha/create-ruby-app.svg)](https://travis-ci.org/majjoha/create-ruby-app)
[![Gem Version](https://badge.fury.io/rb/create-ruby-app.svg)](http://badge.fury.io/rb/create-ruby-app)

`create-ruby-app` is an opinionated tool for scaffolding Ruby applications
effortlessly inspired by [Create React
App](https://github.com/facebook/create-react-app). It generates only the
essentials needed to start working.

It specifically targets non-Rails applications. For Ruby on Rails apps, it might
be worth looking into [Rails Application
Templates](https://guides.rubyonrails.org/rails_application_templates.html)
instead, and if you are building a gem, please take a look at the `bundle gem`
command.

## Requirements
* Ruby (version 2.6.0 or newer).

## Installation
```
gem install create-ruby-app
```

## Usage
```
create-ruby-app new NAME [--ruby RUBY] [--gems GEMS]
```

### Example
```
create-ruby-app new my-app --gems sinatra,sequel --ruby ruby-2.6.1
```

This will generate the following project structure with
[Sinatra](http://sinatrarb.com) and [Sequel](http://sequel.jeremyevans.net)
added to the Gemfile.

```
my_app
├── bin/
│   └── my_app
├── lib/
│   ├── my_app/
│   └── my_app.rb
├── spec/
│   ├── lib/
│   │   └── my_app/
│   └── spec_helper.rb
├── .ruby-version
└── Gemfile
```

Once the project is generated, it will run `bundle install` so you can start
working.

## License
See [LICENSE](https://github.com/majjoha/create-ruby-app/blob/master/LICENSE).
