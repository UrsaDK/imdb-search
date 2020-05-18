# frozen_string_literal: true

describe Task::Import do
  subject { described_class }

  let(:progressbar) { double(increment: true) }
  let(:block) { double.as_null_object }

  describe 'responds to' do
    it { is_expected.to respond_to :title_basics }
  end

  describe '::title_basics' do
    before(:each) do
      allow(Task::Model::TitleBasics).to receive(:total_records) { 100 }
      allow(ProgressBar).to receive(:create) { progressbar }
      allow(Task::Model::TitleBasics).to receive(:each_line).and_yield(block)
    end

    it 'should add db records' do
      expect(App::Model::TitleBasics).to receive(:add_row)
      expect(progressbar).to receive(:increment)
      subject.title_basics('test')
    end
  end
end
