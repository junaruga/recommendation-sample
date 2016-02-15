module RecommendationSample
  # A class which manages recommend logic.
  class Engine
    LATEST_ITEM_NUMBER = 3
    SCORE_USER_SEX = 5

    def initialize(user_id, item_id)
      fail ArgumentError 'user_id is required.' if user_id.nil?
      fail ArgumentError 'item_id is required.' if item_id.nil?

      @user_id = user_id
      @item_id = item_id
    end

    def recommend_item_id
      users = users_buying_the_item
      other_user_id = user_related_on_myself_from_users(users)
      item_ids = recommend_item_ids_of_user_id(other_user_id)
      item_ids
    end

    private

    def users_buying_the_item
      payments = RecommendationSample::Record.new('payments')
      target_users = []
      payments.each do |payment|
        next unless payment['item_ids'].include?(@item_id)
        target_users.push(payment['user_id'])
      end
      target_users.sort.uniq
    end

    # user - user recommendation
    def user_related_on_myself_from_users(user_ids)
      fail ArgumentError 'user_ids is required.' if user_ids.nil?

      records = RecommendationSample::Record.new('users')
      target_user = records.find_one(@user_id)

      recommended_user_id = 0
      max_score = 0

      user_ids.each do |user_id|
        next if @user_id == user_id

        user = records.find_one(user_id)
        score = get_score_from_users(target_user, user)
        if score > max_score
          max_score = score
          recommended_user_id = user_id
        end
      end

      fail 'user data is not enough to recommend.' if recommended_user_id == 0
      recommended_user_id
    end

    def get_score_from_users(target_user, user)
      fail ArgumentError 'target_user is required.' if target_user.nil?
      fail ArgumentError 'user is required.' if user.nil?

      score = 0
      if target_user.key?('sex') && user.key?('sex')
        score += SCORE_USER_SEX if target_user['sex'] == user['sex']
      end

      if target_user.key?('hobby_ids') && user.key?('hobby_ids')
        duplications = target_user['hobby_ids'] & user['hobby_ids']
        score += duplications.size
      end
      score
    end

    def recommend_item_ids_of_user_id(other_user_id)
      fail ArgumentError 'other_user_id is required.' if other_user_id.nil?

      payments = RecommendationSample::Record.new('payments')
      recommended_item_ids = []
      item_ids = []
      payments.each do |row|
        next unless row.key?('user_id')
        next unless row['user_id'] == other_user_id
        next unless row.key?('item_ids')

        item_ids |= row['item_ids']
      end

      # TODO: item-item recommend

      # get latest LATEST_ITEM_NUMBER items of this user
      item_ids = item_ids.reverse
      count = 0
      item_ids.each do |item_id|
        break if LATEST_ITEM_NUMBER <= count
        recommended_item_ids.push(item_id)
        count += 1
      end

      if recommended_item_ids.size == 0
        fail 'recommended user\'s item is not registered.'
      end

      recommended_item_ids
    end
  end
end
