# Capistrano Mongo

Provides some capistrano recipes for MonogoDB

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano_mongo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano_mongo

Require it in your Capfile or deploy.rb:

    require "capistrano_mongo/recipes"

## Usage

    $ cap db:console   # Opens a remote mongo console
    $ cap db:down      # Sync DB from remote server to local machine
    $ cap db:dump      # Create a dump from the remote db

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
