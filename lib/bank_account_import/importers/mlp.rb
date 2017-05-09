# -*- coding: utf-8 -*-
module BankAccountImport
  module Importer
    class Mlp < BaseImporter
      def self.supported?(content)
        lne1, lne3, lne13 = content[0]||[], content[2]||[], content[12]||[]
        lne1.first == "MLP Finanzdienstleistungen AG" &&
          lne3.first == "Umsatzanzeige" &&
          lne13.first == "Buchungstag" &&
          lne13.last == " " && lne13[5] == "IBAN" && lne13[7] == "BIC" &&
          lne13.size == 13
      end

      def _p_or_n(amount, str)
        _to_f(amount) * (str == "H" ? 1.0 : -1.0)
      end

      def _to_f(amount)
        amount.gsub(/[.]/,"").gsub(/,/,".").to_f
      end

      def _date(str)
        Date.strptime(str,'%d.%m.%Y')
      end

      def parse_data
        details = AccountDetails.new
        details.account_number = csv_content[5][1]
        details.blz            = csv_content[4][1]
        details.owner          = csv_content[6][4]

        transactions = csv_content[13..-4].map do |csv_line|
          Transaction.new(csv_line).tap do |t|
            t.booking_date = _date(csv_line[0])
            t.entry_date   = _date(csv_line[1])
            t.currency     = csv_line[-3]
            t.amount       = _p_or_n(csv_line[-2], csv_line.last)
            t.sender       = csv_line[2]
            t.recipient    = csv_line[3]
            t.sender_iban  = csv_line[5]
            t.description  = csv_line[8]
            details.iban = t.sender_iban
          end
        end

        lne2,lne1 = csv_content[-2], csv_content[-1]
        if lne2[9] != "Anfangssaldo"
          _raise_error("Expecting opening amount: #{lne2}")
        end
        if lne1[9] != "Endsaldo"
          _raise_error("Expecting closing amount: #{lne1}")
        end

        details.currency       = lne2[10]
        details.opening_amount = _p_or_n(lne2[11], lne2[12])
        details.closing_amount = _p_or_n(lne1[11], lne1[12])
        details.opening_date   = _date(lne2.first)
        details.closing_date   = _date(lne1.first)

        [details, transactions]
      end
    end
  end
end
