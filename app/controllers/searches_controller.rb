class SearchesController < ApplicationController
  before_action :search_params

  authorize_resource class: false

  def questions
    search do
      Question.search @query, common_options
    end
  end

  def answers
    search do
      Answer.search @query, common_options
    end
  end

  def comments
    search do
      Comment.search @query, common_options
    end
  end

  def users
    search do
      User.search @query, common_options
    end
  end

  def everywhere
    search do
      ThinkingSphinx.search @query, common_options
    end
  end

  private

  def common_options
    { per_page: 100 }
  end

  def search_params
    @query = params[:q]
    @query = ThinkingSphinx::Query.escape(@query) if @query
    @search_type = params[:search_type]
  end

  def search
    if @query.present?
      @search_results = yield if block_given?
      respond_with @search_results
    else
      redirect_back fallback_location: root_path, notice: 'No search query was specified'
    end
  end
end
