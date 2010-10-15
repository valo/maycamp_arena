begin
  HoptoadNotifier.configure do |config|
    config.api_key = '8b635d0b6d32d19dd6640f3f0d0b0ce4'
  end
rescue NameError
  puts "Hoptoad is disabled"
end