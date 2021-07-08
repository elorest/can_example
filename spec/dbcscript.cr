string = <<-STRING
BO_ 158 vehExamplestatus: 8 BCU
  SG_ vehExampleMsg1  : 0|4@1+   (1,0)    [0|8]    "tup"   UCU
  SG_ vehExampleMsg2  : 4|4@1+   (1,0)    [0|8]    "ml"    UCU
  SG_ vehExampleMsg3  : 8|1@1+   (1,0)    [0|1]    "bool"  UCU
  SG_ vehExampleMsg4  : 9|1@1+   (1,1.32) [0|1]    "bool"  UCU
  SG_ vehExampleMsg5  : 10|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg6  : 11|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg7  : 12|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg8  : 13|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg9  : 23|10@0+ (1,0)    [0|1023] "K"     UCU
  SG_ vehExampleMsg10 : 24|7@1+  (1,0)    [0|100]  "C"     UCU
  SG_ vehExampleMsg11 : 31|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg12 : 32|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg13 : 33|8@1+  (0.02,0) [0|5]    "Bar"   UCU
  SG_ vehExampleMsg14 : 41|8@1+  (0.02,0) [0|5]    "%"     UCU
  SG_ vehExampleMsg15 : 49|3@1+  (1,0)    [0|4]    "Q"     UCU
  SG_ vehExampleMsg16 : 52|3@1+  (1,0)    [0|4]    ""      UCU
  SG_ vehExampleMsg17 : 55|3@1+  (1,0)    [0|5]    ""      UCU
  SG_ vehExampleMsg18 : 58|3@1+  (1,0)    [0|4]    ""      UCU
  SG_ vehExampleMsg19 : 61|1@1+  (1,0)    [0|1]    ""      UCU
  SG_ vehExampleMsg20 : 62|1@1+  (1,0)    [0|1]    ""      UCU
STRING

msg = /BO_\s+(?<id>\S+)\s+(?<name>[^\:]+)\:\s(?<size>\d+)\s(?<sender>\w+)/i
sig = /SG_\s+(?<name>\S+)\s+(?<multi>[Mm]\d*)?[^:]*:\s+(?<start>\d+)\|(?<size>\d+)\@(?<endian>\d)(?<signed>[+-])\s+\((?<multiplier>[\d\.]+),(?<offset>[\d\.]+)\)\s+\[(?<low>[\d\.]+)\|(?<high>[\d\.]+)\]/i

if match = msg.match(string.split("\n").first)
  pp match
end

string.split("\n").each do |line|
  if match = sig.match(line)
    pp match
    puts match["multi"]?
    puts match["name"]
    puts match["high"]
  end
end
