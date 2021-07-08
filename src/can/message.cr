require "colorize"

# "foo".colorize(:green)
# 100.colorize(:red)
# [1, 2, 3].colorize(:blue)
module Can
  abstract class Message(T)
    property can_body : T
    property created_at = Time.utc

    def initialize
      tmp_bytes = Bytes.new(sizeof(T))
      @can_body = IO::ByteFormat::LittleEndian.decode(T, tmp_bytes)
    end

    def initialize(@can_body : T)
    end

    def initialize(bytes : Bytes)
      tmp_bytes = Bytes.new(sizeof(T))
      tmp_bytes.copy_from(bytes)
      @can_body = IO::ByteFormat::LittleEndian.decode(T, tmp_bytes)
    end

    def get_slice_le(start = 0, size = 16, prim = UInt32)
      shift = start
      n = (@can_body >> shift) & ((T.new(1) << size) - 1)
      b = num_to_bytes(n)
      IO::ByteFormat::LittleEndian.decode(prim, b)
    end

    def get_slice_be(start = 0, size = 1, prim = UInt32)
      shift = build_shift(start, size)
      le_bytes = num_to_bytes(@can_body)
      can_body = IO::ByteFormat::BigEndian.decode(T, le_bytes)
      n = (can_body >> shift) & ((T.new(1) << size) - 1)
      b = num_to_bytes(n)
      IO::ByteFormat::LittleEndian.decode(prim, b)
    end

    def set_slice_le(value : T, start = 0, size = 16)
      shift = start
      mask = ((T.new(1) << size) - 1) << shift
      n = (value << shift)
      n &= mask
      @can_body &= ~mask
      @can_body |= n
    end

    def set_slice_be(value : T, start = 0, size = 1)
      shift = build_shift(start, size)
      le_bytes = num_to_bytes(@can_body)
      can_body = IO::ByteFormat::BigEndian.decode(T, le_bytes)
      mask = ((T.new(1) << size) - 1) << shift
      shifted_value = (value << shift) & mask
      can_body &= ~mask
      can_body |= shifted_value 
      be_bytes = num_to_bytes(can_body)
      @can_body = IO::ByteFormat::BigEndian.decode(T, be_bytes)
    end

    def to_bytes
      num_to_bytes(@can_body)[0, frame_size]
    end

    private def build_shift(start, size)
      d, m = start.divmod(8)
      shift = ((((sizeof(T)*8) - (d*8)) - (7 - m))) - size
    end

    private def num_to_bytes(v : T, size = nil)
      b = Bytes.new(size || sizeof(T))
      IO::ByteFormat::LittleEndian.encode(v, b)
      b
    end

    macro inherited
      FIELDS = [] of Nil 

      macro finished
        wrapup
      end
    end

    macro wrapup
      def frame_size : Int32
        sizeof(T) 
      end

      def to_hash
        {
          {% for f in FIELDS %} 
            "{{ f.id }}" => {{f.id}},
          {% end %}
        }
      end

      def self.fields
        {
          {% for f in FIELDS %} 
            {{ f.id }}: {{f.id}}_info,
          {% end %}
        }
      end

      def fields
        self.class.fields
      end
    end

    macro can_field(name, start, size, multiplex = nil, multiplier = 1, offset = 0, endian = 1, signed = "+", min = 0, max = 255, unit = "num", receiver = "VLM")
      {% lc_name = name.downcase.id %}
      def self.{{lc_name}}_info
        {
          name: {{name}},
          start: {{start}},
          size: {{size}},
          multiplier: {{multiplier}},
          offset: {{offset}},
          endian: {{endian}},
          signed: {{signed}},
          min: {{min}},
          max: {{max}},
          unit: {{unit}},
          receiver: {{receiver}},
        }
      end

      {% prim = (signed = 0 ? "UInt64" : "Int64").id %}

      {% if multiplier.kind == :i32 %}
        {% if prim == Int64 || multiplier < 0 || offset < 0 %}
          {% return_type = Int64 %} 
        {% else %}
          {% return_type = UInt64 %} 
        {% end %}
      {% else %}
        {% return_type = Float64 %} 
      {% end %}

      {% multiplex_func = false %}

      {% if multiplex && multiplex =~ /m\d+/ %} 
        {% multiplex_func = true %}
      {% end %}

      def {{lc_name}} : {{return_type}}{{(multiplex_func ? "?" : "").id}}
        {% if multiplex_func %} 
          return nil unless "m#{multiplex_key}" == {{multiplex}}
        {% end %}

        value = {{ ("get_slice_" + (endian == 1 ? "le" : "be")).id }}({{start.id}}, {{size}}, {{prim}})

        {% if return_type == Int64 %}
          ({{multiplier.id}}.to_i64 * value) + {{offset.id}}
        {% elsif return_type == UInt64 %}
          ({{multiplier.id}}.to_u64 * value) + {{offset.id}}
        {% else %}
          ({{multiplier.id}}.to_f * value) + {{offset.id}}
        {% end %}
      end

      {% if multiplex == "M" %} 
        private def multiplex_key
          {{lc_name}}
        end
      {% end %}

      def {{lc_name}}=(value)
        value = T.new((value - {{offset.id}}) / {{multiplier.id}})
        {{ ("set_slice_" + (endian == 1 ? "le" : "be")).id }}(value, {{start.id}}, {{size}})
      end

      {% FIELDS << lc_name %}
    end

    def pp_bytes
      colors = [:red, :green, :yellow, :blue, :magenta, :cyan, :light_blue, :dark_gray]
      c1 = colors.dup
      c2 = colors.dup
      puts "\n\n\n"
      puts to_bytes.reverse!.map{|b| sprintf("%08b", b).colorize(c1.shift)}.join("")
      puts "\n\n\n"
      puts to_bytes.map{|b| sprintf("%08b", b).colorize(c2.shift)}.join("")
      puts "\n\n\n"
    end
  end
end
