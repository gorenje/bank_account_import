module BankAccountImport
  module Importer
    class Postbank < BaseImporter
      def self.supported?(content)
        lne1, lne2, lne3 = content[0]||[], content[1]||[], content[2]||[]
        lne4, lne5, lne6 = content[3]||[], content[4]||[], content[5]||[]
        lne7, lne8, lne9 = content[6]||[], content[7]||[], content[8]||[]

        lne1.first =~ /Umsatzauskunft/ &&
          lne2.first == "Name" &&
          lne3.first == "BLZ" &&
          lne4.first == "Kontonummer" &&
          lne5.first == "IBAN" &&
          lne6.first == "Aktueller Kontostand" &&
          lne9.size == 8
      end

      def _date(str)
        Date.strptime(str,'%d.%m.%Y')
      end

      def _to_f(str)
        str.split(/ /).first.gsub(/[.]/,'').to_f
      end

      def parse_data
        details = AccountDetails.new
        details.iban           = csv_content[4].last
        details.closing_amount = _to_f(csv_content[5].last)
        details.owner          = csv_content[1].last
        details.account_number = csv_content[3].last
        details.blz            = csv_content[2].last

        transactions = csv_content[9..-1].map do |csv_line|
          Transaction.new(csv_line).tap do |t|
            t.booking_date = _date(csv_line.first)
            t.entry_date   = _date(csv_line[1])
            t.amount       = _to_f(csv_line[-2])
            t.recipient    = csv_line[-3]
            t.sender       = csv_line[-4]
            t.description  = csv_line[3]
          end
        end

        [details, transactions]
      end
    end
  end
end