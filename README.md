# RecommendationSample

This source is the sample of recommendation proguram, such as Amazon's "Customers Who Bought This Item Also Bought".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recommendation_sample', :git => 'git://github.com/junaruga/recommendation_sample.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specific_install
    $ gem install recommendation_sample
    $ gem specific_install -l git://github.com/junaruga/recommendation_sample.git

## Usage

This source is the sample of recommendation proguram, such as Amazon's "Customers Who Bought This Item Also Bought".

Run target command.

    $ recommend_sample 2 3
    The users who purchased the items which you purchased are
    the below items.
      item_id: 8
      item_id: 1
      item_id: 2

Above case means that when one user (user_id: 2) by one item (item_id: 3), the system recommends items of item_id: 8, 1, 2 by this order, for this user.

### Command Argument

| Argument | Decription |
|--------------| -----------------------|
| 1st | user_id (1 <= n <= 5)  |
| 2nd | item_id (1 <= n <= 10) |

### Directory structure

I\'d like to explain about directry structure of this program.

data/ directory

    users.json
    {
        "id": 1, // user_id
        "sex": 1 or 2, // 1: Man、2: Woman
        "hobby_ids" : [
            1, 2, 3 // This item means hobby, which is registered when user do registeration.
        ]
    }

    payments.json
    {
        "id": 1, // Payment history(transattion) ID
        "user_id": 1, // user_id who bought the item.
        "item_ids": [
                4, // bought item ids (Multiple can be possible.)
        ]
    }

### Recommendation logic

Use Collaborative Filtering for user.

    bought item(a) - Buying user(b) - user group(c) - item group(d)

1. Get user group(c) which users bought item(a) which user(b) bought.
2. Get most correlated top 3 users by calculating the score for user(b) and user group(c).
3. Get item group(d) top 3 which user group(c) bought by order: newly.

If considering correlation of between bought item (a) and item group (d), when getting target user group, it looks much better.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/recommendation_sample. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

