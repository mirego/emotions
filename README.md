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

Configure the allowed emotions.

```ruby
Emotions.configure do |config|
  config.emotions = [:happy, :sad]
end
```

Create a couple of models.

```ruby
class Picture < ActiveRecord::Base
  acts_as_emotive
end

class User < ActiveRecord::Base
  acts_as_emotional
end
```

Express emotions towards other records.

```ruby
user = User.find(1)
picture = Picture.find(2)

user.happy_about!(picture)
user.sad_about!(picture)
user.emotions_about(picture)
# => [:happy, :sad]

user.happy_about?(picture)
# => true

user.no_longer_sad_about!(picture)
user.sad_about?(picture)
# => false

picture.happy_about.map(&:emotional)
# => [#<User id=1>]

user.express!(:sad, picture)
user.sad_about?(picure)
# => true
```
