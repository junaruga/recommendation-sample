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
      user_ids = user_ids_buying_the_item
      other_user_id = user_id_related_on_myself_from_user_ids(user_ids)
      item_ids = recommend_item_ids_of_user_id(other_user_id)
      item_ids
    end

    private

    def user_ids_buying_the_item
      payments = RecommendationSample::Record.new('payments')
      target_user_ids = []
      payments.each do |payment|
        next unless payment['item_ids'].include?(@item_id)
        target_user_ids.push(payment['user_id'])
      end
      target_user_ids.sort.uniq
    end

    # user - user recommendation
    def user_id_related_on_myself_from_user_ids(user_ids)
      fail ArgumentError 'user_ids is required.' if user_ids.nil?

      target_user = RecommendationSample::Record.find_one('users', @user_id)
      users = user_ids.map do |user_id|
        user = RecommendationSample::Record.find_one('users', user_id)
        user['score'] = get_relation_score_of_users(target_user, user)
        user
      end
      related_user = users.reduce do |highest_score_user, user|
        if highest_score_user['score'] > user['score']
          highest_score_user
        else
          user
        end
      end
      related_user['id']
    end

    def get_relation_score_of_users(target_user, user)
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
        break if count >= LATEST_ITEM_NUMBER
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
