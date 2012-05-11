# From : https://github.com/acangiano/ruby-benchmark-suite
require 'benchmark'

Benchmark.bm do |x|
  [500_000, 1_000_000, 3_000_000].each do |n|
    x.report do
      a = []
      n.times { a << []} # use up some RAM
      n.times {[]}
    end
  end
end