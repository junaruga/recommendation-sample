require 'spec_helper'

describe RecommendationSample::Record do
  let(:record) do
    RecommendationSample::Record.new(table_name)
  end

  describe '#table_name' do
    subject do
      record.table_name
    end
    context 'users' do
      let(:table_name) do
        'users'
      end
      it do
        is_expected.to eq 'users'
      end
    end
    context 'payments' do
      let(:table_name) do
        'payments'
      end
      it do
        is_expected.to eq 'payments'
      end
    end
  end

  describe '#each' do
    let(:table_name) do
      'users'
    end

    it 'do each' do
      record.each do |row|
        true
      end
    end
  end

  describe '#find_one' do
    let(:table_name) do
      'users'
    end

    it 'find id: 3' do
      target_user = record.find_one(3)
      expect(target_user['id']).to_not be_nil
      expect(target_user['id']).to eq(3)
      expect(target_user['sex']).to eq(2)
      expect(target_user['hobby_ids']).to eq([3])
    end
  end
end
