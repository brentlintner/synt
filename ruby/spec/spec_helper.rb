if ENV.key? 'TEST_COV'
  require 'simplecov'
  require 'simplecov-lcov'

  SimpleCov::Formatter::LcovFormatter.report_with_single_file = true

  SimpleCov.formatters = [
    SimpleCov::Formatter::LcovFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ]

  SimpleCov.start do
    add_filter "/fixtures/"
  end
end

def file_to_s path
  IO.readlines(path).join
end
