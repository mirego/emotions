# Emotions

[![Gem Version](https://badge.fury.io/rb/emotions.png)](https://rubygems.org/gems/emotions)
[![Build Status](https://travis-ci.org/mirego/emotions.png?branch=master)](https://travis-ci.org/mirego/emotions)

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

Most of the times, you would want to get a quick look at about how many users expressed a certain emotion towards a certain picture. That could be an expensive operation.

However, if the *emotive* record has an `<emotion>_emotions_count` column, Emotions will populate its value with how many users expressed that emotion towards it.

```ruby
user.happy_about!(picture)

picture.happy_about.count
# SQL query that counts records and returns `1`

picture.happy_emotions_count
# Quick lookup into the column and returns `1`
```

## License

`Emotions` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/emotions/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
