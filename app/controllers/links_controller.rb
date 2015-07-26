class LinksController < ApplicationController
  def index
  end

  def redirect
    @link = Link.find_by_slug!(params[:slug])
    @link.increment!(:hits)
    redirect_to @link.url
  end

  def create
    @link = Link.create!(
      url: params[:url],
      client_ip: request.ip,
    )

    if @link.nil?
      flash[:error] = "<span>Aww shit.</span> There was a problem trying to enshorten that shit. Maybe try it again?"
    end

    render :index
  end
end
