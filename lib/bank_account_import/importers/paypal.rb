# -*- coding: utf-8 -*-
module BankAccountImport
  module Importer
    class Paypal < BaseImporter
      def self.supported?(content)
        lne1 = content[0]||[]
        lne1[0..5] ==
          ["Datum", " Zeit", " Zeitzone", " Name", " Typ", " Status"] &&
          lne1.size == 43
      end

      def _to_f(str)
        str.gsub(/[.]/,'').gsub(/[,]/,'.').to_f
      end

      def _date(str)
        Date.strptime(str,'%d.%m.%Y')
      end

      def parse_data
        details = AccountDetails.new

        transactions = csv_content[1..-1].map do |csv_line|
          Transaction.new(csv_line).tap do |t|
            t.booking_date = _date(csv_line[0])
            t.entry_date   = _date(csv_line[0])
            t.currency     = csv_line[6]
            t.amount       = _to_f(csv_line[9])
            t.sender       = csv_line[10].try(:force_encoding,"UTF-8")
            t.recipient    = csv_line[3].try(:force_encoding,"UTF-8")
            t.description  = csv_line[15].try(:force_encoding,"UTF-8")
            t.type         = csv_line[5].try(:force_encoding,"UTF-8")

            details.opening_amount = _to_f(csv_line[34])
            unless details.closing_amount
              details.closing_amount = _to_f(csv_line[34])
            end
            details.currency = t.currency
            details.set_closing_and_opening_dates(t.booking_date,t.entry_date)
          end
        end

        [details, transactions]
      end
    end
  end
end
