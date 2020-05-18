# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
describe Task::Datasource::Tsv do
  let(:source) { StringIO.new("H1\tH2\nV1\tV2\n") }
  let(:formatter) { double(H1: 'F1') }

  subject do
    allow(File).to receive(:open) { source }
    allow(File).to receive(:extname) { true }
    allow(Zlib::GzipReader).to receive(:new) { source }
    described_class.new('test')
  end

  describe 'should raise an error if initialize with invalid file' do
    subject { described_class.new('file-does-not-exist') }
    it { expect { subject }.to raise_error(StandardError) }
  end

  describe 'responds to' do
    it { is_expected.to respond_to :each_line }
  end

  describe '#each_line' do
    it 'should yield control' do
      expect { |b| subject.each_line(&b) }.to yield_control
    end

    it 'should assign values to headers' do
      subject.each_line do |param|
        expect(param).to eq('H1' => 'V1', 'H2' => 'V2')
      end
    end

    it 'should format values' do
      subject.formatter = formatter
      subject.each_line do |param|
        expect(param).to eq('H1' => 'F1', 'H2' => 'V2')
      end
    end

    it 'should respect formatter exceptions' do
      allow(formatter).to receive(:H2).and_raise(StandardError)
      subject.formatter = formatter
      expect { |b| subject.each_line(&b) }.to raise_error(StandardError)
    end
  end
end
# rubocop: enable Metrics/BlockLength
