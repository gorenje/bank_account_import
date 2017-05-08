module BankAccountImport
  module Importer
    class DeutscheBank < BaseImporter
      def self.supported?(content)
        lne1, lne3, lne5 = content[0]||[], content[2]||[], content[4]||[]

        lne1.first =~ /Transactions Kontokorrentkonto/ &&
          lne1[3] =~ /Customer number/  &&
          lne3.first == "Old balance:" &&
          lne5.first == 'Booking date' &&
          lne5[1] == "Value date" &&
          lne5.size == 18
      end

      def _to_f(amount)
        amount.gsub(/[,]/,"").to_f
      end

      def _date(str)
        Date.strptime(str,'%m/%d/%Y')
      end

      def parse_data
        if csv_content.last.first != "Account balance"
          _raise_error("Expecting account balance")
        end

        details = AccountDetails.new
        details.start_date      = _date(csv_content[1].first.split(/ - /).first)
        details.end_date        = _date(csv_content[1].first.split(/ - /).last)
        details.customer_number = csv_content.first.last
        details.opening_amount  = _to_f(csv_content[2][-2])
        details.closing_amount  = _to_f(csv_content.last[-2])
        details.currency        = csv_content[2].last

        transactions = csv_content[5..-2].map do |csv_line|
          Transaction.new(csv_line).tap do |t|
            t.date        = _date(csv_line.first)
            t.entry_date  = _date(csv_line[1])
            t.currency    = csv_line.last
            t.amount      = _to_f(csv_line[-3])
            t.description = csv_line[4]
            t.recipient   = csv_line[3]
            t.type        = csv_line[2]
            t.iban        = csv_line[5]
          end
        end

        [details,transactions]
      end
    end
  end
end
