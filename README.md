NOTE: This is not the authoritative/original source for the finicity gem available on rubygems.org.
While the commits here are based on an unbundling of the gem, there are no other sources available.

finicity
========

A gem to communicate easily with Finicity's API

Installation
============

gem install finicity

or

add ```gem 'finicity'``` to your project's Gemfile

Configuration
=============

You can configure the finicity gem with the following initializer

```Ruby
Finicity.configure do |config|
  config.base_url = "https://api.finicity.com/"
  config.partner_id = <partner_id>
  config.partner_secret = <partner_secret>
  config.app_key = <app_key>
end
```

or within a Rails project

add a file named ```config/finicity.yml```

with the keys of the same name, and this will be loaded automatically via railtie

Usage
=====

In order to connect with Finicity you must first create a session. This is
done by a partner_authentication POST request, and if successful the response
will contain a token that is valid for a limited time.

Creating a session can be done by making a new client and then authenticating

```Ruby
client = Finicity::Client.new
client.authenticate!
```

If you have an existing session, you can re-open your existing session

```Ruby
client = Finicity::Client.new("token-123")
```

If you have an existing session, and also need to re-open a mfa session,
you can pass both tokens into the client when you create it

```Ruby
client = Finicity::Client.new("token-123", "mfa_session-123")
```

Once you have established a session, you can begin to issue commands to the API
using your finicity client

```Ruby
client.get_institutions("Chase")
```

TODO: link to docs to list all API commands we support

test
