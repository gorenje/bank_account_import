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

      def find_importer_for(file_content)
        csv_content = []
        CSV.new(file_content.force_encoding('ISO-8859-1'),
                :col_sep => ";", :quote_char => '"').
          each_with_index do |a, idx|
          csv_content[idx] = a
        end

        @subclasses.select { |klazz| klazz.supported?(csv_content) }.first
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
