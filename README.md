Chizuru
=======
re-structured twitter bot framework

Installation
============

Add this line to your application's Gemfile:

    gem 'Chizuru'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Chizuru

How To
======
Notice: See `test.rb`.

1. Define `Consumer` and `Deliverer`.
2. Acquire the consumer secret and access token, and save it. We use YAML file that have these keys: `consumer_key`, `consumer_secret`, `access_token`, `access_token_secret`.
3. Prepare the source. We provide the default source that uses UserStreaming. If you decide not to use it, you must define the source class that is inherited from `Chizuru::Source`.
4. Configure the bot. Use `Chizuru::Bot.configure`.
5. Start it!

Basic Structure
===============

Source
------
**Source** provides the tweets. We provide `UserStream` class. It uses UserStreaming.

Consumer
--------
**Consumer** receives tweets.
Consumer must be inherited from `Chizuru::Consumer`, and must have `receive(data)` method.

Deliverer
---------
**Deliverer** posts tweets.
`Deliverer` must have `deliver(data)` method.

Contributing to Chizuru
=======================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========
Copyright (c) 2013 mayth.

Chizuru is licensed under the MIT License. See LICENSE.txt.
