require 'spec_helper'

describe RecommendationSample::Engine do
  let(:engine) do
    RecommendationSample::Engine.new(user_id, item_id)
  end

  describe '#user_ids_buying_the_item' do
    subject do
      # To test private method
      engine.send(:user_ids_buying_the_item)
    end
    context 'user_id: 2, item_id: 3' do
      let(:user_id) do
        2
      end
      let(:item_id) do
        3
      end

      it "check return value" do
        expect(subject).to_not be_nil
        expect(subject.length).to be > 0
        expect(subject).to eq [1, 2, 3, 4]
        # See https://github.com/rspec/rspec-expectations Equivalence
      end
    end
  end

  describe '#user_id_related_on_myself_from_user_ids' do
    subject do
      # To test private method
      users = [ 1, 2, 3, 4 ]
      engine.send(:user_id_related_on_myself_from_user_ids, users)
    end
    context 'user_id: 2, item_id: 3' do
      let(:user_id) do
        2
      end
      let(:item_id) do
        3
      end

      it "check return value" do
        expect(subject).to_not be_nil
        expect(subject).to be 2
      end
    end
  end

  describe '#recommend_item_ids_of_user_id' do
    subject do
      # To test private method
      other_user_id = 2
      engine.send(:recommend_item_ids_of_user_id, 2)
    end
    context 'user_id: 2, item_id: 3' do
      let(:user_id) do
        2
      end
      let(:item_id) do
        3
      end

      it "check return value" do
        expect(subject).to_not be_nil
        expect(subject.length).to be > 0
        expect(subject).to eq [2, 3, 1]
      end
    end
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
        expect(subject).to_not be_nil
        is_expected.to eq [2, 3, 1]
      end
    end
  end
end
