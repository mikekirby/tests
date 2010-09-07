
require "rubygems"
require "savon"

Savon::Request.log = false

class MotionDetection1Service
  attr_reader :client
  attr_reader :namespace

  def initialize (client = nil, options = {})
    if !client
      options[:host] ||= "localhost"
      options[:port] ||= "8080"
      options[:path] ||= "/control/MotionDetection-1"
    end

    @client = client || (Savon::Client.new "http://#{options[:host]}:#{options[:port]}#{options[:path]}")
    @namespace = options[:namespace] || "urn:schemas-pelco-com:service:MotionDetection:1"
  end

  # if h and :region are _not_ nil,
  # push region (which could be one hash or an array of hash) into array,
  # then flatten,
  # else return empty array
  #
  # h && h[:region] ? [h[:region]].flatten : Array.new
  # if h && h[:region] then [h[:region]].flatten else Array.new end
  def get_md_regions
    response = @client.get_md_regions! do |soap|
      soap.input = soap.action = "GetMDRegions"
      soap.namespace = @namespace
    end

    h = response.to_hash[:get_md_regions_response][:region_list] #this can throw

    [h[:region]].compact.flatten rescue Array.new #this should not throw
  end

  def set_md_regions(options= {})
    response = @client.set_md_regions! do |soap|
      soap.input = soap.action = "SetMDRegions"
      soap.namespace = @namespace
      soap.body = {
        :regionList => {
          :region => options[:region] || {
            :name         => "Region1",
            :mask         => "region1",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 1, :column => 1},{:row => 40, :column => 40}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}},
          }
         }
        }
    end
  end

  def clear_md_regions
    response = @client.clear_md_regions! do |soap|
      soap.input = soap.action = "ClearMDRegions"
      soap.namespace = @namespace
    end
  end

  def get_md_configuration
    response = @client.GetMDConfiguration! do |soap|
      soap.input = soap.action = "GetMDConfiguration"
      soap.namespace = @namespace
    end
    response.to_hash[:get_md_configuration_response][:md_config]
  end
  
  def set_md_configuration(options = {})
    response = @client.SetMDConfiguration! do |soap|
      soap.input = soap.action = "SetMDConfiguration"
      soap.namespace = @namespace
      soap.body = {:MDConfig=>{
          :rows => options[:rows] ||= 64,
          :columns => options[:columns] ||= 80,
          :maxSensitivity => options[:maxSensitivity] ||= 100,
          :maxRegions => options[:maxRegions] ||= 3,
          :alarmEnabled => options[:alarmEnabled] ||= 0,
        }}
    end
    response.to_hash[:get_md_configuration_response][:md_config]
  end

  def reset_md_configuration
    response = @client.ResetMDConfiguration! do |soap|
      soap.input = soap.action = "ResetMDConfiguration"
      soap.namespace = @namespace
    end
  end

  def set_enabled

  end

  def get_alarm_state
    response = @client.get_alarm_state! do |soap|
      soap.input = soap.action = "GetAlarmState"
      soap.namespace = @namespace
    end
    response.to_hash[:get_alarm_state_response][:alarm_state]
  end

  def get_enabled
    response = @client.get_enabled! do |soap|
      soap.input = soap.action = "GetEnabled"
      soap.namespace = @namespace
    end
    response.to_hash[:get_enabled_response][:enabled]
  end

  def get_max_regions
    response = @client.get_max_regions! do |soap|
      soap.input = soap.action = "GetMaxRegions"
      soap.namespace = @namespace
    end
    response.to_hash[:get_max_regions_response][:max_regions]
  end

  def get_max_sensitivity
    response = @client.get_max_sensitivity! do |soap|
      soap.input = soap.action = "GetMaxSensitivity"
      soap.namespace = @namespace
    end
    response.to_hash[:get_max_sensitivity_response][:max_sensitivity]
  end

  def get_grid_size
    response = @client.get_grid_size! do |soap|
      soap.input = soap.action = "GetGridSize"
      soap.namespace = @namespace
    end
    response.to_hash[:get_grid_size_response]
  end
end
