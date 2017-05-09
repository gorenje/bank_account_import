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
        details.opening_date    = _date(csv_content[1].first.split(/ - /).first)
        details.closing_date    = _date(csv_content[1].first.split(/ - /).last)

        if csv_content.first.first =~ /Kontokorrentkonto \((.+)\)/
          ac = $1
          details.account_number = csv_content.first.last.split(/ /).last + ac
        end

        details.opening_amount  = _to_f(csv_content[2][-2])
        details.closing_amount  = _to_f(csv_content.last[-2])
        details.currency        = csv_content[2].last

        transactions = csv_content[5..-2].map do |csv_line|
          Transaction.new(csv_line).tap do |t|
            t.booking_date   = _date(csv_line.first)
            t.entry_date     = _date(csv_line[1])
            t.currency       = csv_line.last
            t.amount         = _to_f(csv_line[-3])
            t.description    = csv_line[4]
            t.recipient      = csv_line[3]
            t.type           = csv_line[2]
            t.recipient_iban = csv_line[5]

            details.set_closing_and_opening_dates(t.booking_date,t.entry_date)
          end
        end

        [details,transactions]
      end
    end
  end
end
