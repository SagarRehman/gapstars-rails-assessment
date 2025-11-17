class Admin::CompaniesController < ApplicationController
  def new; end

  def create
    if params[:file].blank?
      redirect_to new_admin_company_path, alert: "Please choose a CSV file."
      return
    end

    CompanyImporter.new(params[:file].tempfile).call
    redirect_to root_path, notice: "Import completed."
  rescue => e
    redirect_to new_admin_company_path, alert: "Import failed: #{e.class}: #{e.message}"
  end
end