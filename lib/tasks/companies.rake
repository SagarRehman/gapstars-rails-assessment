namespace :companies do
  desc "Import companies from config/data/companies.csv"
  task import: :environment do
    path = Rails.root.join("config", "data", "companies.csv")
    abort "CSV not found: #{path}" unless File.exist?(path)

    CompanyImporter.new(path.to_s).call
    puts "Imported companies from #{path}"
    puts "Total rows in DB: #{Company.count}"
  end
end