RSpec.describe DataAccessible do
  it "has a version number" do
    expect(DataAccessible::VERSION).not_to be nil
  end

  before do
    @expected_methods = DataAccessible::ClassMethods.public_instance_methods
  end

  it 'extends the including class with `ClassMethods`' do
    IncludedTest = Class.new { include DataAccessible }
    @expected_methods.each do |method|
      expect(IncludedTest).to respond_to(method)
    end
  end

  it 'returns a `Class` instance extended with `ClassMethods`' do
    CreateTestConst1 = DataAccessible.sources
    expect(CreateTestConst1).to be_instance_of(Class)

    @expected_methods.each do |method|
      expect(CreateTestConst1).to respond_to(method)
    end
  end

  it 'should yield the extended `Class` instance to a block if given' do
    DataAccessible.sources do |klass|
      expect(klass.name).to be_nil
      expect(klass).to be_instance_of(Class)
      @expected_methods.each do |method|
        expect(klass).to respond_to(method)
      end
    end
  end
end
