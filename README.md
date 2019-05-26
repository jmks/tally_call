# TallyCall

A gem to provide a simple API to track method calls.

Attempting to experiment with different implementations.

### Available

* `TallyCall::Trace` using Ruby's `TracePoint`.

### Experiments

* Use `Method#prepend` to wrap any method call (e.g. instance, singleton, any parameters)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "tally_call", git: "https://www.github.com/jmks/tally_call"
```

And then execute:

    $ bundle

## Usage

The best place for examples should be the specs.

### TallyCall::Trace

```
class Target
  def target_method
    # ...
  end
end

trace = TallyCall::Trace.new

trace.tally(Target, :target_method)
trace.start

# let some app code run
t = Target.new
t.target_method
t.target_method

# access your results
puts trace.report
# { "Target" => { "target_method" => 2 } }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmks/tally_call.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
