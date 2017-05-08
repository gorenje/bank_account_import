require 'digest/sha2'
require 'csv'

module BankAccountImport
end

Dir.glob(File.dirname(__FILE__)+"/bank_account_import/*.rb").each do |filename|
  require filename
end

Dir.glob(File.dirname(__FILE__)+"/bank_account_import/**/*.rb").each do |fname|
  require fname
end
