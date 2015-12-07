module Recommendation
  class Engine
    LATEST_ITEM_NUMBER = 3
    SCORE_USER_SEX = 5

    def initialize(user_id, item_id)
      @user_id = user_id
      @item_id = item_id
    end

    def recommend_item_id
      users = users_from_payments
      other_user_id = recommend_user_id_by_user_ids(users)
      item_ids = recommend_item_ids_of_user_id(other_user_id)
      item_ids
    end

    private

    def users_from_payments
      target_users = []
      payments = Recommendation::Record.new('payments')
      payments.each do |row|
        if row.key?('item_ids')
          row['item_ids'].each do |item_id|
            if item_id == @item_id
              target_users.push(row['user_id'])
              break
            end
          end
        end
      end
      target_users.sort.uniq
    end

    # user - user recommendation
    def recommend_user_id_by_user_ids(user_ids)
      if user_ids.nil?
        raise ArgumentError.new("user_ids is required.")
      end

      records = Recommendation::Record.new('users')
      target_user = records.find_one(@user_id)

      recommended_user_id = 0
      max_score = 0
      user_ids.each do |user_id|
        if @user_id == user_id
          next
        end
        user = records.find_one(user_id)
        score = get_correlated_score_by_user(target_user, user)
        if score > max_score
          max_score = score
          recommended_user_id = user_id
        end
      end

      if recommended_user_id == 0
        raise RuntimeError,
          "user data is not enough to recommend."
      end
      recommended_user_id
    end

    def get_correlated_score_by_user(target_user, user)
      if target_user.nil?
        raise ArgumentError.new("target_user is required.")
      end
      if user.nil?
        raise ArgumentError.new("user is required.")
      end

      score = 0
      if target_user.key?('sex') and user.key?('sex')
        if target_user['sex'] == user['sex']
          score += SCORE_USER_SEX
        end
      end

      if target_user.key?('hobby_ids') and user.key?('hobby_ids')
        duplications = target_user['hobby_ids'] & user['hobby_ids']
        score += duplications.size
      end
      score
    end

    def recommend_item_ids_of_user_id(other_user_id)
      if other_user_id.nil?
        raise ArgumentError.new("other_user_id is required.")
      end

      payments = Recommendation::Record.new('payments')

      recommended_item_ids = []
      item_ids = []

      payments.each do |row|
        if row.key?('user_id') and row['user_id'] == other_user_id
          if row.key?('item_ids')
            item_ids |= row['item_ids']
          end
        end
      end

      # TODO item-item recommend

      # get latest LATEST_ITEM_NUMBER items of this user
      item_ids = item_ids.reverse
      count = 0
      item_ids.each do |item_id|
        if LATEST_ITEM_NUMBER <= count
          break
        end
        recommended_item_ids.push(item_id)
        count += 1
      end

      if recommended_item_ids.size == 0
        raise RuntimeError,
          "recommended user's item is not registered at data." 
      end

      recommended_item_ids
    end
  end
end
