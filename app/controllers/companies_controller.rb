class CompaniesController < ApplicationController
  def index; end

  def search
    @query = params[:q].to_s
    @companies = Company.search_sql(@query).limit(50)

    render partial: "companies/results", locals: { companies: @companies }
  end
end