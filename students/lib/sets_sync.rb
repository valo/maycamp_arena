require 'open-uri'

class SetsSync
  class << self
    def sync_sets(grader_app_url)
      puts "Syncing tests with #{grader_app_url}..."
      URI.join(grader_app_url, 'main/download_tests').open do |remote_zip|
        File.open(File.join($config[:sets_root], "sets.zip"), "w") do |f|
          while (data = remote_zip.read(1024)) do
            f.write(data)
          end
        end
      end
      puts "Downloaded the zipfile"
      
      # Unzip the file
      Dir.chdir $config[:sets_root] do
        puts "Extracing the tests"
        system 'unzip -o sets.zip'
        puts "Done"
      end
    end
  end
end