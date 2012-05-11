require 'benchmark'

n = 500000

Benchmark.bm do |x|
  x.report do
    something = {}
    n.times do
      something[:else] = 2
    end
  end
  x.report do
    n.times do 
      something ||= {}
      something[:else] = 2
    end
  end  
end