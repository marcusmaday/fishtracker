class FishingController < ApplicationController
  include ApplicationHelper

  # GET /fishing
  # GET /fishing.json
  def index
    @user_catches = getUserCatches()
    @keepers = getKeepers()
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
    user_catches = getUserCatches()
    #Create the new catch and save it to get the id
    cat = Catch.new({ user_id: params[:user_id], fish_type_id: params[:fish_type_id], lat: gps_info['latitude'], lon: gps_info['longitude'], date: Time.now })
    cat.save

    if user_catches[cat.user_id].nil?
      user_catches[cat.user_id] = {}
      user_catches[cat.user_id][cat.fish_type_id] = 0
    elsif user_catches[cat.user_id][cat.fish_type_id].nil?
      user_catches[cat.user_id][cat.fish_type_id] = 0
    end
    user_catches[cat.user_id][cat.fish_type_id] += 1
    user_catches[cat.user_id][:points] += FishType.find(cat.fish_type_id).point_value
    notice_string = User.find(params[:user_id]).nickname + " caught a " + FishType.find(params[:fish_type_id]).name + " <button type='button' class='btn btn-success' onClick=\"window.location.href = '/fishing/keep?catch_id=" + cat.id.to_s + "'\">Mark as Keeper</button> <button class='btn btn-warning' onClick=\"window.location.href = '/fishing/undo?catch_id=" + cat.id.to_s + "'\">Undo Catch</button>"

    Rails.cache.write(:user_catches, user_catches, expires_in: getExpiration())

    redirect_to({action: "index"}, alert: notice_string.html_safe)
  end

  def keep
    keepers = getKeepers()

    cat = Catch.find(params[:catch_id])
    cat.kept = true
    cat.save
    keepers[cat.fish_type_id] += 1

    notice_string = "Marked as a keeper"

    Rails.cache.write(:keepers, keepers, expires_in: getExpiration())

    redirect_to({action: "index"}, alert: notice_string.html_safe)

  end

  def undo
    user_catches = getUserCatches()
    cat = Catch.find(params[:catch_id])
    user_catches[cat.user_id][cat.fish_type_id] -= 1
    user_catches[cat.user_id][:points] -= FishType.find(cat.fish_type_id).point_value
    cat.destroy

    notice_string = "Catch undone"

    Rails.cache.write(:user_catches, user_catches, expires_in: getExpiration())


    redirect_to({action: "index"}, alert: notice_string.html_safe)
  end

  def getUserCatches
    Rails.cache.fetch(:user_catches, expires_in: getExpiration()) do
      user_catches = {}
      keepers = getKeepers()
      point_values = getPointValues()
      users = User.all
      users.each do |user|
        user_catches[user.id] = {}
        user_catches[user.id][:points] = 0
      end
      catches = Catch.where('date BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).all
      catches.each do |cat|
        logger.debug "cat=" + cat.to_s
        if !(user_catches[cat.user_id].has_key?(cat.fish_type_id))
          user_catches[cat.user_id][cat.fish_type_id] = 0
        end
        user_catches[cat.user_id][cat.fish_type_id] += 1
        user_catches[cat.user_id][:points] += point_values[cat.fish_type_id]
        if cat.kept == true
          keepers[cat.fish_type_id] += 1
        end
      end
      Rails.cache.write(:keepers, keepers, expires_in: getExpiration())
      user_catches
    end
  end
  def getKeepers
    Rails.cache.fetch(:keepers, expires_in: getExpiration()) do
      keepers = {}
      fish_types = FishType.all
      fish_types.each do |fish_type|
        keepers[fish_type.id] = 0
      end
      keepers
    end
  end
  def getPointValues
    Rails.cache.fetch(:point_values, expires_in: getExpiration()) do
      point_values = {}
      fish_types = FishType.all
      fish_types.each do |fish_type|
        point_values[fish_type.id] = fish_type.point_value
      end
      point_values
    end
  end
  def getExpiration
    return 1.minutes
  end
end
