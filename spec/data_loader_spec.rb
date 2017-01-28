RSpec.describe DataAccessible::DataLoader do
  before do
    @file_path = File.expand_path('fixtures/sample.yml', File.dirname(__FILE__))
    @empty_path = File.expand_path('fixtures/empty.yml', File.dirname(__FILE__))
  end

  describe 'loading yaml' do
    it 'returns the file contents as a hash' do
      expect(DataAccessible::DataLoader.load_from_file(@file_path)).to be_instance_of(Hash)
    end

    it 'returns the file contents as a hash with keys unaltered' do
      expect(DataAccessible::DataLoader.load_from_file(@file_path)['numbers']['integers']['one']).not_to be_nil
    end

    it 'returns an empty hash if the file has no contents' do
      expect(DataAccessible::DataLoader.load_from_file(@empty_path)).to eq({})
    end
  end

  describe 'loading source' do
    it 'accepts a hash and returns it' do
      data = DataAccessible::DataLoader.load_source({ a: 'a' })
      expect(data).to eq({a: 'a'})
    end

    it 'accepts a symbol and returns the correspdonding data' do
      DataAccessible.data_path = "#{__dir__}/fixtures/config"
      data = DataAccessible::DataLoader.load_source(:config)
      expect(data).to eq({'data' => 'data from config'})
    end

    it 'raises an exception when not given a hash, symbol, or string' do
      expect {
        DataAccessible::DataLoader.load_source(100)
      }.to raise_error(RuntimeError)
    end
  end
end
