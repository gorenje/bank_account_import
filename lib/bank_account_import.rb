require 'digest/sha2'
require 'csv'

module BankAccountImport
end

unless Object.respond_to?(:try)
  # Taken from
  # https://github.com/rails/rails/blob/d66e7835bea9505f7003e5038aa19b6ea95ceea1/activesupport/lib/active_support/core_ext/object/try.rb#L103
  require 'delegate'

  module BankAccountImport
    module Tryable #:nodoc:
      def try(*a, &b)
        try!(*a, &b) if a.empty? || respond_to?(a.first)
      end

      def try!(*a, &b)
        if a.empty? && block_given?
          if b.arity == 0
            instance_eval(&b)
          else
            yield self
          end
        else
          public_send(*a, &b)
        end
      end
    end
  end

  class Object
    include BankAccountImport::Tryable
  end

  class Delegator
    include BankAccountImport::Tryable
  end

  class NilClass
    def try(*args)
      nil
    end

    def try!(*args)
      nil
    end
  end
end


Dir.glob(File.dirname(__FILE__)+"/bank_account_import/*.rb").each do |filename|
  require filename
end

Dir.glob(File.dirname(__FILE__)+"/bank_account_import/**/*.rb").each do |fname|
  require fname
end
