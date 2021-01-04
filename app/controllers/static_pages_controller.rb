class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @time = 0
      unless params[:commit].nil?
        @time = DateTime.current
        unless params[:year].empty?
          @time = @time.change(year: params[:year].to_i)
        end
        unless params[:month].empty?
          @time = @time.change(month: params[:month].to_i)
        end
        unless params[:day].empty?
          @time = @time.change(day: params[:day].to_i)
        end
        unless params[:hour].empty?
          @time = @time.change(hour: params[:hour].to_i)
        end
        unless params[:minute].empty?
          @time = @time.change(min: params[:minute].to_i)
        end
      end
      @feed_items = current_user.feed(params[:commit], @time).paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
