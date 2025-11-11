class CompaniesController < ApplicationController
  def index
    # initial page only
  end

  def search
    @query = params[:q].to_s
    @companies = Company.search_sql(@query).limit(50) # sane cap

    respond_to do |format|
      format.turbo_stream { render partial: "companies/results", locals: { companies: @companies } }
      format.html { render :index } # fallback
    end
  end
end