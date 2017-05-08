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

      def find_importer_for(csv_content)
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
