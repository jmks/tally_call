require "tally_call/version"

module TallyCall
  def self.tally(klass, meth)
    @tallys ||= Hash.new do |hash, key|
      hash[key] = {}
    end

    @tallys[klass][meth] = 0
    # TODO: consider updating API
    local_tallys = @tallys

    klass.prepend(Module.new do
      define_method(meth) do
        local_tallys[klass][meth] += 1
        super()
      end
    end)
  end

  def self.tally_from(klass)
    @tallys[klass]
  end
end
