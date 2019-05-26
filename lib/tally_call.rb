require "tally_call/version"

module TallyCall
  class Tally
    def initialize
      @klass_methods = {}
    end

    def tally(klass, *methods)
      @klass_methods[klass] ||= {}

      methods.each do |meth|
        @klass_methods[klass][meth] = 0
      end
    end

    def start
      TracePoint.trace(:call) do |tp|
        tally_for(tp.defined_class, tp.method_id)
      end
    end

    def from(klass)
      @klass_methods[klass]
    end

    private

    def tally_for(klass, meth)
      return unless method_tallied?(klass, meth)

      @klass_methods[klass][meth] += 1
    end

    def method_tallied?(klass, meth)
      @klass_methods.include?(klass) && @klass_methods[klass].include?(meth)
    end
  end
end
