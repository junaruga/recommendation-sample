require 'spec_helper'

describe RecommendationSample::Engine do
  let(:engine) do
    RecommendationSample::Engine.new(user_id, item_id)
  end

  describe '#recommend_item_id' do
    subject do
      engine.recommend_item_id
    end
    context 'user_id: 2, item_id: 3' do
      let(:user_id) do
        2
      end
      let(:item_id) do
        3
      end
      it do
        is_expected.to eq [8, 1, 2]
      end
    end
  end
end
