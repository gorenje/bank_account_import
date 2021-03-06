# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: bank_account_import 0.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "bank_account_import"
  s.version = "0.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gerrit Riessen"]
  s.date = "2017-05-10"
  s.description = "Support Bank export files that are in CSV format."
  s.email = "gerrit.riessen@gmail.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "bank_account_import.gemspec",
    "lib/bank_account_import.rb",
    "lib/bank_account_import/account_details.rb",
    "lib/bank_account_import/base_importer.rb",
    "lib/bank_account_import/importers/deutsche_bank.rb",
    "lib/bank_account_import/importers/mlp.rb",
    "lib/bank_account_import/importers/paypal.rb",
    "lib/bank_account_import/importers/postbank.rb",
    "lib/bank_account_import/importers/sparkasse.rb",
    "lib/bank_account_import/transaction.rb",
    "lib/tasks/csv.rake"
  ]
  s.homepage = "https://github.com/gorenje"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Support various CSV files"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<iconv>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<term-ansicolor>, [">= 0"])
    else
      s.add_dependency(%q<iconv>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<term-ansicolor>, [">= 0"])
    end
  else
    s.add_dependency(%q<iconv>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<term-ansicolor>, [">= 0"])
  end
end

