# ddlist
test/benchmark list implementation for the experimental tce branch

Some results follow (obviously using Franco's https://github.com/fponticelli/thx.benchmark library)

```
################################## 
JS 
##################################

 ------- map --------- 

┃ description ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map    ┃   1,424 ┃ ±1.33% ┃      45 ┃     fastest ┃
┃ rlist map   ┃   1,110 ┃ ±3.62% ┃      45 ┃  22% slower ┃

 ------- map_reverse --------- 

┃ description       ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map_reverse  ┃   2,568 ┃ ±7.74% ┃      43 ┃     fastest ┃
┃ rlist map_reverse ┃   2,460 ┃ ±1.50% ┃      45 ┃   4% slower ┃

 ------- flatten to array --------- 

┃ description             ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_to_array   ┃  14,868 ┃ ±3.46% ┃      44 ┃     fastest ┃
┃ rlist flatten_to_array  ┃  12,172 ┃ ±1.00% ┃      49 ┃  18% slower ┃
┃ list flatten_to_array2  ┃   2,947 ┃ ±1.05% ┃      47 ┃  80% slower ┃
┃ rlist flatten_to_array2 ┃   1,853 ┃ ±0.83% ┃      49 ┃  88% slower ┃

 ------- flatten --------- 

┃ description         ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_arr    ┃   4,470 ┃ ±0.75% ┃      49 ┃     fastest ┃
┃ rlist flatten_arr   ┃   4,119 ┃ ±0.86% ┃      45 ┃   8% slower ┃
┃ list flatten local  ┃   2,624 ┃ ±0.48% ┃      46 ┃  41% slower ┃
┃ rlist flatten local ┃   2,126 ┃ ±0.68% ┃      50 ┃  52% slower ┃
┃ list flatten sep    ┃   3,060 ┃ ±0.70% ┃      45 ┃  32% slower ┃
┃ rlist flatten sep   ┃   2,608 ┃ ±0.60% ┃      46 ┃  42% slower ┃
--------- reverse ----------

┃ description   ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list reverse  ┃   3,076 ┃ ±0.95% ┃      54 ┃     fastest ┃
┃ rlist reverse ┃   2,643 ┃ ±1.86% ┃      46 ┃  14% slower ┃

################################## 
Java 
##################################

------- map --------- 

┃ description ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map    ┃   2,931 ┃ ±7.07% ┃      60 ┃   5% slower ┃
┃ rlist map   ┃   3,072 ┃ ±3.90% ┃      42 ┃     fastest ┃

------- map_reverse --------- 

┃ description       ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map_reverse  ┃   6,024 ┃ ±2.44% ┃      48 ┃     fastest ┃
┃ rlist map_reverse ┃   5,336 ┃ ±3.60% ┃      43 ┃  11% slower ┃

------- flatten to array --------- 

┃ description             ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_to_array   ┃  27,182 ┃ ±1.62% ┃      46 ┃     fastest ┃
┃ rlist flatten_to_array  ┃  24,413 ┃ ±1.37% ┃      47 ┃  10% slower ┃
┃ list flatten_to_array2  ┃  26,511 ┃ ±1.57% ┃      47 ┃   2% slower ┃
┃ rlist flatten_to_array2 ┃  13,186 ┃ ±0.96% ┃      49 ┃  51% slower ┃

------- flatten --------- 

┃ description         ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_arr    ┃  11,502 ┃ ±1.12% ┃      46 ┃     fastest ┃
┃ rlist flatten_arr   ┃  10,920 ┃ ±2.03% ┃      51 ┃   5% slower ┃
┃ list flatten local  ┃   9,242 ┃ ±2.53% ┃      43 ┃  20% slower ┃
┃ rlist flatten local ┃   7,989 ┃ ±3.56% ┃      45 ┃  31% slower ┃
┃ list flatten sep    ┃   9,674 ┃ ±0.91% ┃      50 ┃  16% slower ┃
┃ rlist flatten sep   ┃   8,603 ┃ ±2.97% ┃      46 ┃  25% slower ┃

--------- reverse ----------

┃ description   ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list reverse  ┃   9,201 ┃ ±1.61% ┃      51 ┃     fastest ┃
┃ rlist reverse ┃   8,468 ┃ ±1.24% ┃      44 ┃   8% slower ┃

################################## 
CS/Mono
##################################

------- map --------- 

┃ description ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map    ┃     714 ┃ ±3.26% ┃      41 ┃     fastest ┃
┃ rlist map   ┃     434 ┃ ±5.06% ┃      36 ┃  39% slower ┃

------- map_reverse --------- 

┃ description       ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list map_reverse  ┃   1,179 ┃ ±3.31% ┃      62 ┃     fastest ┃
┃ rlist map_reverse ┃     885 ┃ ±2.89% ┃      41 ┃  25% slower ┃

------- flatten to array --------- 

┃ description             ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_to_array   ┃  11,219 ┃ ±1.81% ┃      49 ┃     fastest ┃
┃ rlist flatten_to_array  ┃   8,707 ┃ ±1.98% ┃      38 ┃  22% slower ┃
┃ list flatten_to_array2  ┃  10,453 ┃ ±1.45% ┃      46 ┃   7% slower ┃
┃ rlist flatten_to_array2 ┃   4,526 ┃ ±1.75% ┃      53 ┃  60% slower ┃

------- flatten --------- 

┃ description         ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list flatten_arr    ┃   2,895 ┃ ±2.42% ┃      42 ┃     fastest ┃
┃ rlist flatten_arr   ┃   2,496 ┃ ±2.52% ┃      44 ┃  14% slower ┃
┃ list flatten local  ┃   1,686 ┃ ±3.48% ┃      44 ┃  42% slower ┃
┃ rlist flatten local ┃   1,366 ┃ ±2.85% ┃      48 ┃  53% slower ┃
┃ list flatten sep    ┃   2,022 ┃ ±2.64% ┃      42 ┃  30% slower ┃
┃ rlist flatten sep   ┃   1,836 ┃ ±2.15% ┃      54 ┃  37% slower ┃

--------- reverse ----------

┃ description   ┃ ops/sec ┃  error ┃ samples ┃ performance ┃
┃━━━━━━━━━━━━━━━┃━━━━━━━━━┃━━━━━━━━┃━━━━━━━━━┃━━━━━━━━━━━━━┃
┃ list reverse  ┃   1,759 ┃ ±3.37% ┃      42 ┃     fastest ┃
┃ rlist reverse ┃     910 ┃ ±3.84% ┃      43 ┃  48% slower ┃
```

