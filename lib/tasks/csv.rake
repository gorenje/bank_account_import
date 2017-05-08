require 'csv'
require_relative '../bank_account_import.rb'

namespace :csv do
  desc <<-EOF
    Import example files.
  EOF
  task :doit do
    Dir.glob(File.dirname(__FILE__)+"/../../examples/*.csv").each do |filename|
      puts ("#"*20) + " " + filename

      csv_content = []
      CSV.new(File.read(filename).force_encoding('ISO-8859-1'),
              :col_sep => ";", :quote_char => '"').
        each_with_index do |a, idx|
        csv_content[idx] = a
      end

      imp_klazz = BankAccountImport::BaseImporter.find_importer_for(csv_content)
      if imp_klazz.nil?
        puts "NO IMPORTER FOUND for #{filename}"
        csv_content.each_with_index do |a,idx|
          puts "%003d: %s" % [idx, a]
        end
      else
        puts "Found importer: #{imp_klazz.name}"
        data = imp_klazz.new(csv_content).parse_data
        puts data
      end
    end
  end
end
