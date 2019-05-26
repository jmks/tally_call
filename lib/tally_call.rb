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
        next unless @klass_methods.key?(tp.defined_class)

        method_tallys = @klass_methods[tp.defined_class]

        next unless method_tallys.include?(tp.method_id)

        method_tallys[tp.method_id] += 1
      end
    end

    def from(klass)
      @klass_methods[klass]
    end
  end
end
