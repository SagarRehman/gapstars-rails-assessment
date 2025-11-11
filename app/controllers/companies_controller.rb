class CompaniesController < ApplicationController
  def index; end

  def search
    @query = params[:q].to_s
    @companies = Company.search_sql(@query).limit(50)

    respond_to do |format|
      format.turbo_stream { render partial: "companies/results", locals: { companies: @companies } }
      format.html { render :index }
    end
  end
end
