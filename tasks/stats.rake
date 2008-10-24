STATS_DIRECTORIES = [ 'Test', 'Lib' ].collect do |name|
  [ name, File.join(PROJECT_DIR, name.downcase) ]
end

class CodeStatistics #:nodoc: (totally stolen from Rails' railties)

  TEST_TYPES = [ 'Test' ]
  SPLITTER   = '+-------+-------+-------+'

  def initialize(*pairs)
    @pairs      = pairs
    @statistics = calculate_statistics
    @total      = calculate_total if pairs.length > 1
  end

  def to_s
    print_header
    @pairs.each { |pair| print_line(pair.first, @statistics[pair.first]) }
    puts SPLITTER

    if @total
      print_line 'Total', @total
      puts SPLITTER
    end

    print_code_test_stats
  end

  private

  def calculate_statistics
    @pairs.inject({}) do |stats, pair|
      stats[pair.first] = calculate_directory_statistics(pair.last)
      stats
    end
  end

  def calculate_directory_statistics(directory, pattern = /.*\.rb$/)
    stats = { 'lines' => 0, 'codelines' => 0 }

    return stats if directory.match('vendor')

    Dir.foreach(directory) do |file_name|
      if File.stat(directory + '/' + file_name).directory? &&
         (/^\./ !~ file_name)

        newstats = calculate_directory_statistics(
          directory + '/' + file_name, pattern)

        stats.each { |k, v| stats[k] += newstats[k] }
      end

      next unless file_name =~ pattern

      f = File.open(directory + '/' + file_name)

      while line = f.gets
        stats['lines']     += 1
        stats['codelines'] += 1 unless line =~ /^\s*$/ || line =~ /^\s*#/
      end
    end

    stats
  end

  def calculate_total
    total = { 'lines' => 0, 'codelines' => 0 }
    @statistics.each_value { |pair| pair.each { |k, v| total[k] += v } }
    total
  end

  def calculate_code
    code_loc = 0
    @statistics.each do |k, v|
      code_loc += v['codelines'] unless TEST_TYPES.include? k
    end
    code_loc
  end

  def calculate_tests
    test_loc = 0
    @statistics.each do |k, v|
      test_loc += v['codelines'] if TEST_TYPES.include? k
    end
    test_loc
  end

  def print_header
    puts SPLITTER
    puts "| Name  | Lines |   LOC |"
    puts SPLITTER
  end

  def print_line(name, statistics)
    start = if TEST_TYPES.include? name
      "| #{name.ljust(5)} "
    else
      "| #{name.ljust(5)} "
    end

    puts start +
         "| #{statistics['lines'].to_s.rjust(5)} " +
         "| #{statistics['codelines'].to_s.rjust(5)} |"
  end

  def print_code_test_stats
    code  = calculate_code
    tests = calculate_tests

    puts "Code/Test ratio: 1:#{sprintf("%.1f", tests.to_f/code)}"
  end
end

desc 'Reports code/test ratio'
task :stats do
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end
