# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
describe App::Model::TitleBasics do
  context 'class methods' do
    subject { described_class }

    describe 'responds to' do
      it { is_expected.to respond_to :add_row }
      it { is_expected.to respond_to :find_by_column }
    end

    describe '::add_row' do
      let(:data) { double.as_null_object }
      let(:tb) { double.as_null_object }

      before(:each) do
        allow(data).to receive(:delete) { [1] }
        allow(Sequel::Model).to receive(:create) { tb }
      end

      it 'should add rows to the db' do
        expect(App::Model::Genre).to receive(:find_or_create)
        expect(tb).to receive(:add_genre)
        subject.add_row(data)
      end
    end

    describe '::find_by_column' do
      let(:selfi) { double.as_null_object }

      before(:each) do
        allow(Sequel).to receive(:ilike) { double.as_null_object }
        allow(Sequel::Model).to receive(:where) { [selfi] }
      end

      it 'should call to_api on each found row' do
        expect(selfi).to receive(:to_api)
        subject.find_by_column('col', 'query')
      end
    end
  end

  context 'instance methods' do
    subject { described_class.new }

    describe 'responds to' do
      it { is_expected.to respond_to :to_api }
    end

    describe '#to_api' do
      before(:each) do
        allow(subject).to receive(:to_hash) do
          { one: 'a', two: 'b' }
        end
        allow(subject).to receive(:genres) do
          [double(id: 1, name: 'c'), double(id: 2, name: 'd')]
        end
      end

      it 'should return an api hash' do
        expect(subject.to_api).to eq(one: 'a', two: 'b', genres: %w[c d])
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
