# Ruby simple benchmarks

My collection of no-brainer ruby benchmarks.

### GC (bm_gc_string.rb)

Run a block 10 times, where the block creates 5MB of 1K strings and 10 times that much garbage

Results:

#### Ruby 1.8.7

    ----user   --system   ---total   ------real
     5.020000   0.060000   5.080000 (  5.108038)
    10.180000   0.100000  10.280000 ( 10.300125)
    14.740000   0.070000  14.810000 ( 14.876626)

#### Ruby 1.9.3-p194

    ----user   --system   ---total   ------real    
     4.040000   0.020000   4.060000 (  4.067027)
     7.640000   0.040000   7.680000 (  7.715625)
    11.620000   0.050000  11.670000 ( 11.710644)


#### Ruby 1.9.3-perf

    ----user   --system   ---total   ------real 
     3.960000   0.060000   4.020000 (  4.028437)
     7.860000   0.020000   7.880000 (  7.908420)
    12.040000   0.100000  12.140000 ( 12.176960)


### GC (bm_gc_mb.rb)

Results:

#### Ruby 1.8.7

    ----user   --system   ---total   ------real
    0.490000   0.120000   0.610000 (  0.616005)
    1.300000   0.080000   1.380000 (  1.381923)
    4.000000   0.380000   4.380000 (  4.388443)

#### Ruby 1.9.3-p194

    ----user   --system   ---total   ------real    
    0.190000   0.020000   0.210000 (  0.202355)
    0.380000   0.020000   0.400000 (  0.395092)
    1.160000   0.070000   1.230000 (  1.242818)

#### Ruby 1.9.3-perf

    ----user   --system   ---total   ------real 
    0.200000   0.010000   0.210000 (  0.208784)
    0.440000   0.000000   0.440000 (  0.441366)
    1.060000   0.110000   1.170000 (  1.184112)


### For vs. each (for_vs_each.rb)

Results:

    ----user   --system   ---total   ------real
    0.340000   0.000000   0.340000   (0.341422)
    0.310000   0.000000   0.310000   (0.326168)

### Obvious if you think about it but hey it needed to be benched (good_to_know.rb)

Results:

    ----user   --system   ---total   ------real
    0.110000   0.000000   0.110000   (0.105050)
    0.470000   0.020000   0.490000   (0.493622)
