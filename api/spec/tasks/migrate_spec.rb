# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
describe Task::Migrate do
  subject { described_class }

  let(:migration_dir) { '/test/migration/dir' }
  let(:config) { double.as_null_object }
  let(:block) { double.as_null_object }

  describe 'responds to' do
    it { is_expected.to respond_to :all }
    it { is_expected.to respond_to :to }
  end

  describe '::all' do
    before(:each) do
      allow(File).to receive(:join) { migration_dir }
      allow(YAML).to receive(:load_file) { config }
      allow(Sequel).to receive(:connect).and_yield(block)
    end

    it 'should run all migrations' do
      expect(Sequel::Migrator).to receive(:run).with(block, migration_dir)
      subject.all
    end
  end

  describe '::to' do
    before(:each) do
      allow(File).to receive(:join) { migration_dir }
      allow(YAML).to receive(:load_file) { config }
      allow(Sequel).to receive(:connect).and_yield(block)
    end

    it 'should move to a specified migration' do
      expect(Sequel::Migrator).to receive(:run).with(block, migration_dir, target: 3)
      subject.to(3)
    end
  end
end
# rubocop: enable Metrics/BlockLength
