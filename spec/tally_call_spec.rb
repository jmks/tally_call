module TallyCall
  RSpec.describe Tally do
    let(:klass) do
      Class.new do
        def method_1
        end

        def method_2
        end
      end
    end

    let(:tally) { Tally.new }

    it "a method that isn't called tally is zero" do
      tally_method_calls_of(:method_not_called)

      expect(tally.from(klass)).to include(method_not_called: 0)
    end

    it "counts calls to a method" do
      tally_method_calls_of(:method_1)

      call_methods(:method_1)

      expect(tally.from(klass)).to include(method_1: 1)
    end

    it "counts calls to many methods" do
      tally_method_calls_of(:method_1, :method_2)

      call_methods(:method_1, :method_1, :method_2)

      expect(tally.from(klass)).to include(method_1: 2, method_2: 1)
    end

    def tally_method_calls_of(*methods)
      tally.tally(klass, *methods)
      tally.start
    end

    def call_methods(*methods)
      instance = klass.new

      methods.each do |meth|
        instance.public_send(meth)
      end
    end
  end
end
