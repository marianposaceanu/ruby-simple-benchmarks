require 'benchmark'

n = 500000

Benchmark.bm do |x|
  x.report do
    foo = nil
    bar = [1,2,3,4,5]
    n.times do
      for i in bar do
        foo = i
      end      
    end
  end
  x.report do
    foo = nil
    bar = [1,2,3,4,5]
    n.times do
      bar.each do |i|
        foo = i
      end
    end
  end  
end