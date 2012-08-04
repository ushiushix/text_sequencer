module TextSequencer
  class Parser
    DEFAULT_BASE = 48
    DEFAULT_ROW = 4
    DEFAULT_VELOCITY = 100
    NOTE_REGEXP = /^([a-gz])([#\+\-])?([0-9])?$/

    def initialize
      @stack = []
      @sequence = []
      @stack.push(@sequence)
      @base = DEFAULT_BASE
      @subbase = @base / 4
      @row = DEFAULT_ROW
      @velocity = DEFAULT_VELOCITY
      @line_num = 0
    end

    def parse(text)
      text.split("\n").each do |s|
        parse_one(s.chomp)
      end
      self
    end

    private
    def parse_one(line)
      @line_num += 1
      s = line.gsub(/;.*$/, "").strip.split(/,? +|,/)
      return self if s.empty?
      case s.first
      when NOTE_REGEXP
        note(s)
      when "("
        stack_start(s)
      when ")"
        stack_end(s)
      else
        command(s)
      end
    end

    def note(record)
      (1..3).each {|i| record[i] = int_value(record[i]) }
      matched = record.first.match(NOTE_REGEXP)
      adjust = matched[2] || ''
      row = (matched[3] || @row).to_i
      note = note_to_number(matched[1], adjust, row)
      length, delay = calc_note_timing(record)
      velocity = record[3] || @velocity
      @sequence.push([:note, note, length, delay, velocity])
    end

    def stack_start(record)
      raise ParseError, "#{@line_num}: #{record.join(' ')}" if record.length > 1
      @sequence = []
      @stack.push(@sequence)
    end

    def stack_end(record)
      if record.length < 2 || @stack.length == 1
        raise ParseError, "#{@line_num}: #{record.join(' ')}"
      end
      if record[1] =~ /\d+/
        seq = @stack.pop
        @sequence = @stack.last
        record[1].to_i.times {|i| @sequence += seq }
      end
    end

    def command(record)
      p record
    end

    def note_to_number(note, adjust, row)
      return nil if note == 'z'
      off = 'cdefgab'.index(note)
      a = case adjust
          when '#'
            1
          when '+'
            1
          when '-'
            -1
          else
            0
          end
      16 + row * 12 + off + a
    end

    def calc_note_timing(record)
      length, delay = record[1..2]
      if length && delay
        return length, delay
      elsif length
        return length, (length / @subbase + @subbase)
      else
        return @base, @base
      end
    end

    def int_value(str)
      return nil unless str && str.length > 0
      str.to_i
    end
  end

  class ParseError < ArgumentError; end
end
