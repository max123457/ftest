Test url: [http://max123457.github.io/ftest/](http://max123457.github.io/ftest/)
---

Benchmarks:
---

**TLDR**:

| Requests Country | Concurency Level| AVG response time(ms) | Full Time(s)  |
|:----------------:|:---------------:|:---------------------:|:-------------:|
|      10          | 1               | 1349.841              | 13.498        |
|      10          | 100             | 1449.496              | 14.495        |
|      50          | 1000            | 2526.009              | 50.520        |

**Full logs**:

```
ab -c1 -n10 "http://0.0.0.0:9000/offers.json?uid=1&pub0=1&page=1"

Server Software:        Goliath
Server Hostname:        0.0.0.0
Server Port:            9000

Document Path:          /offers.json?uid=1&pub0=1&page=1
Document Length:        29223 bytes

Concurrency Level:      1
Time taken for tests:   13.498 seconds
Complete requests:      10
Failed requests:        5
   (Connect: 0, Receive: 0, Length: 5, Exceptions: 0)
Write errors:           0
Total transferred:      268447 bytes
HTML transferred:       265417 bytes
Requests per second:    0.74 [#/sec] (mean)
Time per request:       1349.841 [ms] (mean)
Time per request:       1349.841 [ms] (mean, across all concurrent requests)
Transfer rate:          19.42 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.4      0       1
Processing:  1204 1350 147.0   1373    1609
Waiting:     1204 1349 147.1   1372    1608
Total:       1204 1350 146.9   1373    1609

Percentage of the requests served within a certain time (ms)
  50%   1373
  66%   1435
  75%   1438
  80%   1523
  90%   1609
  95%   1609
  98%   1609
  99%   1609
 100%   1609 (longest request)

```

```
ab -c10 -n100 "http://0.0.0.0:9000/offers.json?uid=1&pub0=1&page=1"

Server Software:        Goliath
Server Hostname:        0.0.0.0
Server Port:            9000

Document Path:          /offers.json?uid=1&pub0=1&page=1
Document Length:        29247 bytes

Concurrency Level:      10
Time taken for tests:   14.495 seconds
Complete requests:      100
Failed requests:        71
   (Connect: 0, Receive: 0, Length: 71, Exceptions: 0)
Write errors:           0
Non-2xx responses:      1
Total transferred:      2269893 bytes
HTML transferred:       2239581 bytes
Requests per second:    6.90 [#/sec] (mean)
Time per request:       1449.496 [ms] (mean)
Time per request:       144.950 [ms] (mean, across all concurrent requests)
Transfer rate:          152.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   1.2      0       6
Processing:  1080 1399 218.1   1359    2394
Waiting:     1080 1399 218.2   1358    2394
Total:       1080 1400 218.0   1359    2394

Percentage of the requests served within a certain time (ms)
  50%   1359
  66%   1419
  75%   1454
  80%   1487
  90%   1619
  95%   1900
  98%   2125
  99%   2394
 100%   2394 (longest request)
```

```
ab -c50 -n1000 "http://0.0.0.0:9000/offers.json?uid=1&pub0=1&page=1"

erver Software:        Goliath
Server Hostname:        0.0.0.0
Server Port:            9000

Document Path:          /offers.json?uid=1&pub0=1&page=1
Document Length:        23 bytes

Concurrency Level:      50
Time taken for tests:   50.520 seconds
Complete requests:      1000
Failed requests:        974
   (Connect: 0, Receive: 0, Length: 974, Exceptions: 0)
Write errors:           0
Non-2xx responses:      4
Total transferred:      24133728 bytes
HTML transferred:       23830786 bytes
Requests per second:    19.79 [#/sec] (mean)
Time per request:       2526.009 [ms] (mean)
Time per request:       50.520 [ms] (mean, across all concurrent requests)
Transfer rate:          466.51 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   1.5      0       9
Processing:  1070 2434 2101.0   1419   11695
Waiting:     1069 2433 2099.3   1419   11695
Total:       1070 2434 2100.9   1420   11695

Percentage of the requests served within a certain time (ms)
  50%   1420
  66%   1492
  75%   1653
  80%   5600
  90%   6256
  95%   6461
  98%   6810
  99%   7876
 100%  11695 (longest request)
 ```
 
 Monit Config:
 ---
 
 ```
 check process fyber pidfile /home/user/projects/ftest/server.pid
    start program = "/bin/bash -l -c 'cd /home/user/projects/ftest/ftest && source ../profile && api_key=xxxxxxxxxx ruby server.rb -e production -d -l /home/user/projects/ftest/server.log -P /home/user/projects/ftest/server.pid -v'"
       as uid user and gid user
    stop program = "/bin/bash -c '/bin/kill `cat /home/user/projects/ftest/server.pid`'"
    if totalmemory is greater than 64 MB for 5 cycles then restart
    if totalcpu is greater than 60% for 5 cycles then restart
    if children is greater than 64 for 5 cycles then restart

check file fyber_restart path /home/user/projects/ftest/restart.txt
    if changed timestamp then exec "/bin/bash -c '/bin/kill `cat /home/user/projects/ftest/server.pid`'
    
 ```
 
 Deploy Command:
 ---
 
 ```
 HOST="user@example.com" rake deploy
 ```
 
 Test Command:
 ---
 ```
 rake
 ```
