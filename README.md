## Recommendation Sample

This source is the sample of recommendation proguram, such as Amazon's "Customers Who Bought This Item Also Bought".

## Getting Started

1. Change your git directory, and download files.

        $ cd $GIT_DIR
        $ https://github.com/junaruga/recommendation-sample.git
        $ cd recommendation-sample/src/bin

2. Run target command.

        $ ./recommend 2 3
        The users who purchased the items which you purchased are
        the below items.
          item_id: 8
          item_id: 1
          item_id: 2

    Above case means that when one user (user_id: 2) by one item (item_id: 3), the system recommends items of item_id: 8, 1, 2 by this order, for this user.

    1st argument means user_id (1 <= n <= 5)
    2nd argument means item_id (1 <= n <= 10)

## Directory structure

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

## Recommendation logic

Use Collaborative Filtering for user.

    bought item(a) - Buying user(b) - user group(c) - item group(d)

1. Get user group(c) which users bought item(a) which user(b) bought.
2. Get most correlated top 3 users by calculating the score for user(b) and user group(c).
3. Get item group(d) top 3 which user group(c) bought by order: newly.

If considering correlation of between bought item (a) and item group (d), when getting target user group, it looks much better.



