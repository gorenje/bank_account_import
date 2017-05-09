module BankAccountImport
  module Importer
    module SparkasseSameness
      def _to_f(amount)
        amount.gsub(/[.]/,"").gsub(/[,]/,".").to_f
      end

      def _date(str)
        begin
          Date.strptime(str,'%d.%m.%y')
        rescue ArgumentError
          if str =~ /^30[.]02[.](.+)/
            _date("01.03.#{$1}")
          elsif str =~ /^29[.]02[.](.+)/
            _date("01.03.#{$1}")
          else
            raise
          end
        end
      end
    end

    class SparkasseMt940Csv < BaseImporter
      include SparkasseSameness

      def self.supported?(content)
        lne1 = content[0]||[]
        lne1 == ["Auftragskonto", "Buchungstag", "Valutadatum",
                 "Buchungstext", "Verwendungszweck",
                 "Beguenstigter/Zahlungspflichtiger", "Kontonummer",
                 "BLZ", "Betrag", "Waehrung", "Info"]
      end

      def parse_data
        details = AccountDetails.new

        transactions = csv_content[1..-1].map do |csv_line|
          details.account_number = csv_line.first
          details.currency = csv_line[-2]

          Transaction.new(csv_line).tap do |t|
            t.booking_date   = _date(csv_line[1])
            t.entry_date     = _date(csv_line[2])
            t.currency       = csv_line[-2]
            t.amount         = _to_f(csv_line[-3])
            t.description    = csv_line[4]
            t.type           = csv_line[3]
            t.recipient      = csv_line[5]
            t.recipient_iban = csv_line[6]

            details.set_closing_and_opening_dates(t.booking_date,t.entry_date)
          end
        end

        puts details
        [details,transactions]
      end
    end

    class SparkasseCamtCsv < BaseImporter
      include SparkasseSameness

      def self.supported?(content)
        lne1 = content[0]||[]
        lne1 == ["Auftragskonto", "Buchungstag", "Valutadatum",
                 "Buchungstext", "Verwendungszweck", "Glaeubiger ID",
                 "Mandatsreferenz", "Kundenreferenz (End-to-End)",
                 "Sammlerreferenz", "Lastschrift Ursprungsbetrag",
                 "Auslagenersatz Ruecklastschrift",
                 "Beguenstigter/Zahlungspflichtiger", "Kontonummer/IBAN",
                 "BIC (SWIFT-Code)", "Betrag", "Waehrung", "Info"]
      end

      def parse_data
        details = AccountDetails.new

        transactions = csv_content[1..-1].map do |csv_line|
          details.account_number = csv_line.first
          details.currency = csv_line[-2]

          Transaction.new(csv_line).tap do |t|
            t.booking_date = _date(csv_line[1])
            t.entry_date   = _date(csv_line[2])
            t.currency     = csv_line[-2]
            t.amount       = _to_f(csv_line[-3])
            t.description  = csv_line[4]
            t.type         = csv_line[3]

            t.recipient      = csv_line[-6]
            t.recipient_id   = csv_line[5]
            t.recipient_iban = csv_line[-5]

            details.set_closing_and_opening_dates(t.booking_date,t.entry_date)
          end
        end

        puts details
        [details,transactions]
      end
    end
  end
end
