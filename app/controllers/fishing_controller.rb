class FishingController < ApplicationController
  include ApplicationHelper

  # GET /fishing
  # GET /fishing.json
  def index
    @user_catches = getUserCatches()
    logger.debug "user_catches=" + @user_catches.to_s

    @fish_types = FishType.all if @fish_type.nil?
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @user_catches }
    end
  end

  def catch
    gps_info = getGPSInfo()
    @user_catches = getUserCatches()
    #Create the new catch and save it to get the id
    @catch = Catch.new({ user_id: params[:user_id], fish_type_id: params[:fish_type_id], lat: gps_info[:lat], lon: gps_info[:lon], date: Time.now })
    @catch.save

    if @user_catches[@catch.user_id].nil?
      @user_catches[@catch.user_id] = {}
      @user_catches[@catch.user_id][@catch.fish_type_id] = 0
    elsif @user_catches[@catch.user_id][@catch.fish_type_id].nil?
      @user_catches[@catch.user_id][@catch.fish_type_id] = 0
    end
    @user_catches[@catch.user_id][@catch.fish_type_id] += 1
    @notice_string = User.find(params[:user_id]).nickname + " caught a " + FishType.find(params[:fish_type_id]).name + " <a href='/fishing/keep?catch_id=" + @catch.id.to_s + "'>Mark as Keeper</a>|<a href='/fishing/undo?catch_id=" + @catch.id.to_s + "'>Undo Catch</a>"

    Rails.cache.write(:user_catches, @user_catches, expires_in: 1.minutes)

    redirect_to({action: "index"}, alert: @notice_string.html_safe)
  end

  def keep
    @user_catches = getUserCatches()

    cat = Catch.find(params[:catch_id])
    cat.kept = true
    cat.save
    logger.debug "WHATEVER1=" + @user_catches.to_s
    @user_catches[:keepers][cat.fish_type_id] = @user_catches[:keepers][cat.fish_type_id] + 1
    logger.debug "WHATEVER2=" + @user_catches.to_s

    @notice_string = "Marked as a keeper"

    Rails.cache.write(:user_catches, @user_catches, expires_in: 1.minutes)

    redirect_to({action: "index"}, alert: @notice_string.html_safe)

  end

  def getUserCatches
    Rails.cache.fetch(:user_catches, expires_in: 1.minutes) do
      user_catches = {}
      user_catches[:keepers] = {}
      @fish_types = FishType.all if @fish_type.nil?
      @fish_types.each do |fish_type|
        user_catches[:keepers][fish_type.id] = 0
      end
      catches = Catch.where('date BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).all
      catches.each do |cat|
        logger.debug "cat=" + cat.to_s
        if !(user_catches.has_key?(cat.user_id))
          user_catches[cat.user_id] = {}
          user_catches[cat.user_id][cat.fish_type_id] = 0
        end
        user_catches[cat.user_id][cat.fish_type_id] += 1
        if cat.kept == true
          user_catches[:keepers][cat.fish_type_id] += 1
        end
      end
      user_catches
    end
 end
end
