# -*- coding: utf-8 -*-
require 'csv'
require_relative '../bank_account_import.rb'

namespace :csv do
  desc <<-EOF
    Import example files.
  EOF
  task :scan_examples do
    puts "Available Importers: #{BankAccountImport::BaseImporter.subclasses}"
    Dir.glob(File.dirname(__FILE__)+"/../../examples/*.csv").each do |filename|
      puts ("#"*20) + " " + filename

      file_data = File.read(filename)

      imp_klazz = BankAccountImport::BaseImporter.find_importer_for(file_data)

      if imp_klazz.nil?
        puts "NO IMPORTER FOUND for #{filename}"
        BankAccountImport::BaseImporter.to_csv_content(file_data).
          each_with_index do |a,idx|
          puts "%003d: %s" % [idx, a]
        end
      else
        puts "Found importer: #{imp_klazz.name}"
        data = imp_klazz.import_data(file_data)
      end
    end
  end

  desc <<-EOF
    Display the common attributes returned by all importers.
  EOF
  task :commalities do
    require 'term/ansicolor'
    _C = Term::ANSIColor

    all_details = {}
    all_transactions = {}

    Dir.glob(File.dirname(__FILE__)+"/../../examples/*.csv").each do |filename|
      file_data = File.read(filename)

      imp_klazz = BankAccountImport::BaseImporter.find_importer_for(file_data)

      if imp_klazz
        details, transactions = imp_klazz.import_data(file_data)
        all_details[imp_klazz.bank_name] = details

        all_transactions[imp_klazz.bank_name] = transactions.map do |trans|
          trans.to_h.keys
        end.flatten.uniq.sort
      end
    end

    banks = all_details.keys.sort
    max_bank_name_length = banks.map { |a| a.size }.max

    all_attr_names =
      all_details.values.map { |a| a.to_h.keys }.flatten.uniq.sort
    max_attr_name_length = all_attr_names.map { |a| a.size }.max

    puts _C.green("Account".
                  center((max_bank_name_length+4)*banks.count))
    puts
    puts " " * (max_attr_name_length+3) +
      banks.map { |a| _C.blue(a.center(max_bank_name_length+4)) }.join

    all_attr_names.each do |attr_name|
      str,cnt = "",0
      banks.each do |bank_name|
        str += if all_details[bank_name].to_h.keys.include?(attr_name)
                 cnt+=1
                 _C.green("✓".center(max_bank_name_length+4))
               else
                 _C.red("X".center(max_bank_name_length+4))
               end
      end

      clr = banks.count == cnt ? :green : :yellow
      puts _C.send(clr,attr_name.to_s.rjust(max_attr_name_length+2)) + " "+str
    end

    all_attr_names = all_transactions.map { |_,a| a }.flatten.uniq.sort
    max_attr_name_length = all_attr_names.map { |a| a.size }.max

    puts
    puts _C.green("Transaction".
                  center((max_bank_name_length+4)*banks.count))
    puts
    puts " "*(max_attr_name_length+3)+
      banks.map { |a| _C.blue(a.center(max_bank_name_length+4)) }.join

    all_attr_names.each do |attr_name|
      str,cnt = "",0
      banks.each do |bank_name|
        str += if all_transactions[bank_name].include?(attr_name)
                 cnt += 1
                 _C.green("✓".center(max_bank_name_length+4))
               else
                 _C.red("X".center(max_bank_name_length+4))
               end
      end

      clr = banks.count == cnt ? :green : :yellow
      puts _C.send(clr,attr_name.to_s.rjust(max_attr_name_length+2)) +" " + str
    end

    puts
  end
end
