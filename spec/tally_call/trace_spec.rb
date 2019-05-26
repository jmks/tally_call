module TallyCall
  RSpec.describe Trace do
    let(:klass) do
      Class.new do
        def self.name
          "TestClass"
        end

        def method_1
        end

        def method_2
        end

        def uncalled_method
          raise "Do NOT call me in the specs"
        end
      end
    end

    let(:trace) { Trace.new }

    describe "#tally" do
      it "tally of zero for methods not called" do
        tally_method_calls_of(:uncalled_method)

        expect(trace.for(klass)).to include(uncalled_method: 0)
      end

      it "tallys calls to a method" do
        tally_method_calls_of(:method_1)

        call_methods(:method_1)

        expect(trace.for(klass)).to include(method_1: 1)
      end

      it "tallys calls to multiple methods" do
        tally_method_calls_of(:method_1, :method_2)

        call_methods(:method_1, :method_1, :method_2)

        expect(trace.for(klass)).to include(method_1: 2, method_2: 1)
      end

      context "when tallying method that does not exist on the class" do
        it "raises" do
          expect do
            tally_method_calls_of(:unexpected_method)
          end.to raise_error(NoMethodError, /TestClass does not implement method unexpected_method/)
        end
      end
    end

    describe "#report" do
      it "includes all tallys as strings" do
        tally_method_calls_of(:method_1, :method_2)

        call_methods(:method_1, :method_2, :method_2)

        expect(trace.report).to eq({ "TestClass" => { "method_1" => 1, "method_2" => 2 }})
      end
    end

    def tally_method_calls_of(*methods)
      trace.tally(klass, *methods)
      trace.start
    end

    def call_methods(*methods)
      instance = klass.new

      methods.each do |meth|
        instance.public_send(meth)
      end
    end
  end
end
