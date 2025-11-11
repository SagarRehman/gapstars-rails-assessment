require "csv"
class CompanyImporter
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
    csv = CSV.new(@io, headers: true, col_sep: sniff_col_sep)
    csv.each do |row|
      name = (row["name"] || row["company_name"]).to_s.strip
      city = row["city"].to_s.strip
      coc  = (row["coc_number"] || row["registry_number"]).to_s.strip
      next if name.empty? || city.empty? || coc.empty?
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
    return 0 if rows.empty?
    Company.upsert_all(
      rows,
      unique_by: :index_companies_on_coc_number
    ).rows.count
  ensure
    @io.close if @io.respond_to?(:close)
  end
  private
  def sniff_col_sep
    @io.rewind
    sample = @io.read(2048).to_s
    @io.rewind
    sample.count(";") > sample.count(",") ? ";" : ","
  end
end
