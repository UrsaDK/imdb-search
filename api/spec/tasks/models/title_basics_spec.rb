# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
describe Task::Model::TitleBasics do
  subject { described_class }

  let(:datasource) { double.as_null_object }
  let(:block) { double.as_null_object }

  describe 'responds to' do
    it { is_expected.to respond_to :each_line }
    it { is_expected.to respond_to :total_records }
  end

  describe '::each_line' do
    before(:each) do
      allow(Task::Datasource::Tsv).to receive(:new) { datasource }
      allow(datasource).to receive(:each_line).and_yield(block)
    end

    it 'should pass each line of the datasource to the supplied block' do
      subject.each_line('test') do |param|
        expect(param).to eq(block)
      end
    end
  end

  describe '::total_records' do
    let(:datasource) { double(source: double.as_null_object) }
    let(:empty_file) { StringIO.new('') }
    let(:file_with_headers) { StringIO.new("1\n") }
    let(:file_with_records) { StringIO.new("1\n2\n") }

    before(:each) do
      allow(Task::Datasource::Tsv).to receive(:new) { datasource }
    end

    it 'should return 0 records for an empty file' do
      allow(datasource).to receive(:source) { empty_file }
      expect(subject.total_records('test')).to eq(0)
    end

    it 'should return 0 records for a file with only the headers row' do
      allow(datasource).to receive(:source) { file_with_headers }
      expect(subject.total_records('test')).to eq(0)
    end

    it 'should return 1 record for a file with 2 lines' do
      allow(datasource).to receive(:source) { file_with_records }
      expect(subject.total_records('test')).to eq(1)
    end
  end
end

describe Task::Model::TitleBasics::Formatter do
  subject { described_class }

  describe 'responds to' do
    it { is_expected.to respond_to :titleType }
    it { is_expected.to respond_to :primaryTitle }
    it { is_expected.to respond_to :originalTitle }
    it { is_expected.to respond_to :startYear }
    it { is_expected.to respond_to :endYear }
    it { is_expected.to respond_to :runtimeMinutes }
    it { is_expected.to respond_to :isAdult }
    it { is_expected.to respond_to :genres }
  end

  describe '::titleType' do
    it { expect(subject.titleType('\N')).to eq(nil) }
    it { expect(subject.titleType('test')).to eq('test') }
    it { expect(subject.titleType('Test')).to eq('test') }
  end

  describe '::primaryTitle' do
    it { expect(subject.primaryTitle('\N')).to eq(nil) }
    it { expect(subject.primaryTitle('test')).to eq('test') }
    it { expect(subject.primaryTitle('Test')).to eq('Test') }
  end

  describe '::originalTitle' do
    it { expect(subject.originalTitle('\N')).to eq(nil) }
    it { expect(subject.originalTitle('test')).to eq('test') }
    it { expect(subject.originalTitle('Test')).to eq('Test') }
  end

  describe '::startYear' do
    it { expect(subject.startYear('\N')).to eq(nil) }
    it { expect(subject.startYear('1900')).to eq(1900) }
    it { expect(subject.startYear('test')).to eq(0) }
  end

  describe '::endYear' do
    it { expect(subject.endYear('\N')).to eq(nil) }
    it { expect(subject.endYear('1900')).to eq(1900) }
    it { expect(subject.endYear('test')).to eq(0) }
  end

  describe '::runtimeMinutes' do
    it { expect(subject.runtimeMinutes('\N')).to eq(nil) }
    it { expect(subject.runtimeMinutes('1900')).to eq(1900) }
    it { expect(subject.runtimeMinutes('test')).to eq(0) }
  end

  describe '::isAdult' do
    it { expect(subject.isAdult('\N')).to eq(nil) }
    it { expect(subject.isAdult('')).to eq(false) }
    it { expect(subject.isAdult('test')).to eq(false) }
    it { expect(subject.isAdult('1')).to eq(true) }
    it { expect(subject.isAdult('0')).to eq(false) }
    it { expect(subject.isAdult(0)).to eq(false) }
  end

  describe '::genres' do
    it { expect(subject.genres('\N')).to eq(nil) }
    it { expect(subject.genres('test')).to eq(['Test']) }
    it { expect(subject.genres('Test')).to eq(['Test']) }
    it { expect(subject.genres('alpha,bravo')).to eq(%w[Alpha Bravo]) }
  end
end
# rubocop: enable Metrics/BlockLength
