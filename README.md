<p align="center">
  <a href="https://github.com/mirego/emotions">
    <img src="http://i.imgur.com/9fhaEY4.png" alt="Emotions" />
  </a>
  <br />
  Emotions is a Ruby library that allows ActiveRecord records to<br /> express (and hopefully store) emotions about other records.
  <br /><br />
  <a href="https://rubygems.org/gems/emotions"><img src="http://img.shields.io/gem/v/emotions.svg" /></a>
  <a href="https://codeclimate.com/github/mirego/emotions"><img src="http://img.shields.io/codeclimate/github/mirego/emotions.svg" /></a>
  <a href="https://travis-ci.org/mirego/emotions"><img src="http://img.shields.io/travis/mirego/emotions.svg" /></a>
</p>

---

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'emotions'
```

And then execute:

```bash
$ bundle
```

Run the migration to add the `emotions` table and the `Emotion` model:

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
class Picture < ActiveRecord::Base
  acts_as_emotive
end

class User < ActiveRecord::Base
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

User.happy_about(picture)
# => #<ActiveRecord::Relation [#<User id=1>]>

user.express!(:sad, picture)
user.sad_about?(picure)
# => true
```

## Cache counters

Most of the times, you would want to get a quick look at about how many users expressed a certain emotion towards a certain picture. That could be an expensive operation.

However, if the *emotive* record has an `<emotion>_emotions_count` column, Emotions will populate its value with how many emotional records expressed that emotion towards it.

```ruby
user.happy_about!(picture)

picture.happy_about.count
# SQL query that counts records and returns `1`

picture.happy_emotions_count
# Quick lookup into the column and returns `1`
```

Same thing for emotional records. If there’s a `<emotion>_emotions_count` column in the emotional model, Emotions will update it each time one of its records expresses that emotion towards another record.

```ruby
user.happy_about!(picture)

user.happy_about.count
# SQL query that counts records and returns `1`

user.happy_emotions_count
# Quick lookup into the column and returns `1`
```

## License

`Emotions` is © 2013-2014 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/emotions/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
