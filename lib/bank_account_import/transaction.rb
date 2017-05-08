require 'ostruct'

module BankAccountImport
  class Transaction < OpenStruct
    def initialize(csv_line)
      super()
      self.sha = Digest::SHA2.hexdigest(csv_line.join)
    end
  end
end
