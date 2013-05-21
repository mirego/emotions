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

Most of the times, you would want to get a quick look at about how many users expressed a certain emotion towards a certain picture. That could be an expensive operation.

However, if the *emotive* record has an `<emotion>_emotions_count` column, Emotions will populate its value with how many users expressed that emotion towards it.

```ruby
user.happy_about!(picture)

picture.happy_about.count
# SQL query that counts records and returns `1`

picture.happy_emotions_count
# Quick lookup into the column and returns `1`
```
