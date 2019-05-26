module TallyCall
  class Trace
    def initialize
      @klass_methods = {}
    end

    def tally(klass, *methods)
      @klass_methods[klass] ||= {}

      methods.each do |meth|
        validate_method(klass, meth)

        @klass_methods[klass][meth] = 0
      end
    end

    def start
      TracePoint.trace(:call) do |tp|
        tally_for(tp.defined_class, tp.method_id)
      end
    end

    def for(klass)
      @klass_methods[klass]
    end

    def report
      @klass_methods.each_with_object({}) do |(klass, method_tallys), acc|
        method_counts = method_tallys.each_with_object({}) do |(meth, tally), memo|
          memo[meth.to_s] = tally
        end

        acc[klass.name] = method_counts
      end
    end

    private

    def validate_method(klass, meth)
      return if klass.method_defined?(meth)

      raise NoMethodError, "#{klass.name} does not implement method #{meth}"
    end

    def tally_for(klass, meth)
      return unless method_tallied?(klass, meth)

      @klass_methods[klass][meth] += 1
    end

    def method_tallied?(klass, meth)
      @klass_methods.include?(klass) && @klass_methods[klass].include?(meth)
    end
  end
end
