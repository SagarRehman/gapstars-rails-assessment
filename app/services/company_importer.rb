require "csv"

class CompanyImporter
  # path_or_io: File, String (path), or ActionDispatch::Http::UploadedFile
  def initialize(path_or_io)
    @io =
      case path_or_io
      when String then File.open(path_or_io, "rb")
      when File   then path_or_io
      else path_or_io # uploaded file responds to #read
      end
  end

  def call
    rows = []
    CSV.new(@io, headers: true).each do |row|
      name = row["name"]&.strip || row["company_name"]&.strip
      city = row["city"]&.strip
      coc  = row["coc_number"]&.strip || row["registry_number"]&.strip

      next if name.blank? || city.blank? || coc.blank?

      now = Time.current
      rows << {
        name: name,
        city: city,
        coc_number: coc,
        name_lc: name.downcase,
        city_lc: city.downcase,
        created_at: now,
        updated_at: now
      }
    end

    # Upsert by unique index; "keep last result" satisfied by last row wins
    Company.upsert_all(
      rows,
      unique_by: :index_companies_on_coc_number # matches migration index name
    )
  ensure
    @io.close if @io.respond_to?(:close)
  end
end
