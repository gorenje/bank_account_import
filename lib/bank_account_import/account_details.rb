require 'ostruct'

module BankAccountImport
  class AccountDetails < OpenStruct

    def set_closing_and_opening_dates(booking_date, entry_date)
      if self.closing_date
        if self.closing_date < entry_date
          self.closing_date = entry_date
        end
      else
        self.closing_date = entry_date
      end

      if self.opening_date
        if self.opening_date > booking_date
          self.opening_date = booking_date
        end
      else
        self.opening_date = booking_date
      end
    end
  end
end
