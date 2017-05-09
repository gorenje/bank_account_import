module BankAccountImport
  class BaseImporter

    class FormatException < Exception
    end

    attr_reader :csv_content

    class << self
      attr_reader :subclasses

      def inherited(sub)
        (@subclasses ||= []) << sub
      end

      def supported?(csv_content)
        false
      end

      def to_csv_content(file_content)
        csv_content = [].tap do |content|
          CSV.new(file_content.force_encoding('ISO-8859-1'),
                  :col_sep => ";", :quote_char => '"').
            each_with_index do |a, idx|
            content[idx] = a
          end
        end
      end

      def find_importer_for(file_content)
        csv_content = to_csv_content(file_content)
        @subclasses.select { |klazz| klazz.supported?(csv_content) }.first
      end

      def import_data(file_content)
        self.new(to_csv_content(file_content)).parse_data
      end

      def bank_name
        self.name.split(/::/).last
      end
    end

    def initialize(csv_content)
      @csv_content = csv_content
    end

    def _raise_error(msg)
      raise FormatException.new(msg)
    end
  end
end
