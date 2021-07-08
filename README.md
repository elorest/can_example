# can_example

Example code to deal with Can Messages in Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     can_example:
       github: elorest/can_example
   ```

2. Run `shards install`

## Usage

```crystal
require "can_example"
```

## Example Usage

```cr
require "can_example"

class FakeMsg0 < Can::Message(UInt64)
  can_field name: "fake_s0_1", start: 0, size: 8, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 255, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_2", start: 8, size: 8, multiplex: nil, multiplier: 1, offset: -40, endian: 1, signed: "+", min: -40, max: 210, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_3", start: 16, size: 10, multiplex: nil, multiplier: 2, offset: 0, endian: 1, signed: "+", min: 0, max: 2036, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_4", start: 26, size: 4, multiplex: nil, multiplier: 10, offset: 0, endian: 1, signed: "+", min: 0, max: 100, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_5", start: 30, size: 2, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 3, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_6", start: 32, size: 10, multiplex: nil, multiplier: 2, offset: 0, endian: 1, signed: "+", min: 0, max: 2036, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_7", start: 42, size: 4, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 15, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_8", start: 46, size: 2, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 3, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_9", start: 48, size: 2, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 3, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_10", start: 50, size: 2, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 3, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_11", start: 52, size: 4, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 15, unit: "units", receiver: "FCU"
  can_field name: "fake_s0_12", start: 56, size: 2, multiplex: nil, multiplier: 1, offset: 0, endian: 1, signed: "+", min: 0, max: 3, unit: "units", receiver: "FCU"
end

fm = FakeMsg0.new(0b1010100111001010101010101011001010111100001010101010100010100011_u64)

fm.pp_bytes

puts fm.fake_s0_1
puts fm.fake_s0_5
fm.fake_s0_5 = 3
puts fm.fake_s0_6
fm.fake_s0_6 = 500
puts fm.fake_s0_5
puts fm.fake_s0_6

fm.pp_bytes
```

## Contributors

- [Isaac Sloan](https://github.com/elorest) - creator and maintainer
