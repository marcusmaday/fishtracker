require 'json'

module ApplicationHelper
  def getGPSInfo
    gps_file_name = "#{Rails.root}/tmp/gpsinfo"
    if File.exist?(gps_file_name)
      gpsfile = File.read(gps_file_name)
      location = JSON.parse(gpsfile)
    else
      location = {:latitude => 0.0, :longitude => 0.0}
    end
    return location
  end
end
