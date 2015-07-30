module TextSequencer
  # Parse the text music notation to a sequence of notes.
  class Parser
    DEFAULT_BASE = 48
    DEFAULT_ROW = 4
    DEFAULT_VELOCITY = 100
    NOTE_REGEXP = /^([a-gz])([#\+\-])?([0-9])?$/

    def initialize(sequencer)
      @stack = []
      @stack.push(sequencer.sequence)
      @sequence = @stack.last
      @base = DEFAULT_BASE
      @row = DEFAULT_ROW
      @velocity = DEFAULT_VELOCITY
      @line_num = 0
      @macros = {}
    end

    def parse(text)
      text.split("\n").each do |s|
        parse_one(s.chomp)
      end
      self
    end

    private

    def parse_one(line)
      line.downcase!
      @line_num += 1
      s = line.gsub(/;.*$/, '').strip.split(/,? +|,/)
      return self if s.empty?
      case s.first
      when NOTE_REGEXP
        note(s)
      when /^-?\d{1,3}$/
        note_digit(s)
      when /^([a-z0-9_]+)?\(\)$/
        call_macro(s)
      when /^([a-z0-9_]+)?\($/
        stack_start(s)
      when ')'
        stack_end(s)
      else
        command(s)
      end
    end

    def note(record)
      (1..3).each { |i| record[i] = int_value(record[i]) }
      matched = record.first.match(NOTE_REGEXP)
      adjust = matched[2] || ''
      row = (matched[3] || @row).to_i
      note = note_to_number(matched[1], adjust, row)
      st, gt = calc_note_timing(record)
      velocity = record[3] || @velocity
      @sequence.push([:note, note, gt, st, velocity])
    end

    def note_digit(record)
      (1..3).each { |i| record[i] = int_value(record[i]) }
      note = record.first.to_i
      gt, st = calc_note_timing(record)
      velocity = record[3] || @velocity
      @sequence.push([:note, note, gt, st, velocity])
    end

    def stack_start(record)
      fail ParseError.new(@line_num, record.join(' ')) if record.length > 1
      @sequence = []
      match = /^(?<name>[a-z0-9_]+)\($/.match(record.first)
      @stack.push(match[:name].to_sym) if match # has macro name
      @stack.push(@sequence)
    end

    def stack_end(record)
      fail ParseError.new(@line_num, record.join(' ')) if @stack.length == 1
      seq = @stack.pop
      seq *= record[1].to_i if /^\d+$/ =~ record[1]
      if @stack.last.is_a? Symbol
        @macros[@stack.pop] = seq
        @sequence = @stack.last
      else
        @sequence = @stack.last
        @sequence.concat(seq)
      end
    end

    def command(record)
      case record[0]
      when 'base'
        fail ParseError.new(@line_num, record.join(' ')) if record.length != 2
        @base = record[1].to_i
      when 'row'
        fail ParseError.new(@line_num, record.join(' ')) if record.length != 2
        @row = record[1].to_i
      when 'vel', 'velocity'
        fail ParseError.new(@line_num, record.join(' ')) if record.length != 2
        @velocity = record[1].to_i
      else
        fail ParseError.new(@line_num, record.join(' '))
      end
    end

    def call_macro(record)
      match = /^(?<name>[a-z0-9_]+)\(/.match(record.first)
      fail ParseError.new(@line_num, record.join(' ')) unless match
      name = match[:name].to_sym
      fail ParseError.new(@line_num, record.join(' ')) unless @macros[name]
      @sequence.concat(@macros[name])
    end

    def note_to_number(note, adjust, row)
      return nil if note == 'z'
      off = [0, 2, 4, 5, 7, 9, 11]['cdefgab'.index(note)]
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
      12 + row * 12 + off + a
    end

    def calc_note_timing(record)
      st, gt = record[1..2]
      if st && gt
        return st.quo(@base), gt.quo(@base)
      elsif st
        return st.quo(@base), (st == 0 ? 1 : st.quo(@base))
      else
        return 1.0, 1.0
      end
    end

    def int_value(str)
      return nil unless str && str.length > 0
      str.to_i
    end
  end

  # Indicate parser error
  class ParseError < ArgumentError
    attr_reader :line

    def initialize(line, message)
      super(message)
      @line = line
    end
  end
end
