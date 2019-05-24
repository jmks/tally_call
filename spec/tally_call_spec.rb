RSpec.describe TallyCall do
  let(:klass) do
    Class.new do
      def some_method
      end
    end
  end

  it "a method that isn't called tally is zero" do
    TallyCall.tally(klass, :method_not_called)

    expect(TallyCall.tally_from(klass)).to include(method_not_called: 0)
  end

  it "counts method calls" do
    TallyCall.tally(klass, :some_method)

    instance = klass.new
    instance.some_method

    expect(TallyCall.tally_from(klass)).to include(some_method: 1)
  end
end
