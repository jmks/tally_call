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

    it "a method that isn't called tally is zero" do
      tally = Tally.new
      tally.tally(klass, :method_not_called)
      tally.start

      expect(tally.from(klass)).to include(method_not_called: 0)
    end

    it "counts calls to a method" do
      tally = Tally.new
      tally.tally(klass, :method_1)
      tally.start

      instance = klass.new
      instance.method_1

      expect(tally.from(klass)).to include(method_1: 1)
    end

    it "counts calls to many methods" do
      tally = Tally.new
      tally.tally(klass, :method_1, :method_2)
      tally.start

      instance = klass.new
      instance.method_1
      instance.method_1
      instance.method_2

      expect(tally.from(klass)).to include(method_1: 2, method_2: 1)
    end
  end
end
