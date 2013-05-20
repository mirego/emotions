# Emotions

Emotions is a Ruby library that allows ActiveRecord records to express (and hopefully store) emotions about other records.

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'emotions'
```

And then execute:

```bash
$ bundle
```

Run the migration to add the `emotions` table:

```bash
$ rails generate emotions:install
```

## Usage

Here’s what I want to be able to do with Emotions:

```ruby
class Picture < ActiveRecord::Base
  acts_as_emotive
  emotions :happy, :sad
end

class User < ActiveRecord::Base
  acts_as_emotional
end

user = User.find(1)
picture = Picture.find(2)

user.happy_about(picture)
user.sad_about(picture)
user.emotions_about(picture)
# => [:happy, :sad]

user.happy_about?(picture)
# => true

user.not_sad_about(picture)
user.sad_about?(picture)
# => false

picture.happy_about
# => [#<User id=1>]
```

As you can see from the `lib` directory, nothing is done yet.
