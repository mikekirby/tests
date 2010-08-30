#!/usr/bin/ruby

require "rubygems"
require "savon"

client = Savon::Client.new "http://localhost:8082/onvif/services"

client.get_alarm_inputs! do |soap|
# soap.action = "GetAlarmInputs"
  soap.input = "GetAlarmInputs"
  soap.namespace = "urn:pelco:services:extension:onvif:deviceIO:1"
end

client.set_alarm_inputs! do |soap|
  soap.input = "SetAlarmInputSettings"
  soap.namespace = "urn:pelco:services:extension:onvif:deviceIO:1"
  soap.body = {:AlarmInputToken=>"bank-no1", :Properties=>{:polarity=>0, :supervised=>0, :dwellTime=>0}}
end

=begin
<urn:SetAlarmInputSettings>
   <AlarmInputToken>?</AlarmInputToken>
   <Properties>
      <polarity>?</polarity>
      <supervised>?</supervised>
      <dwellTime>?</dwellTime>
   </Properties>
</urn:SetAlarmInputSettings>
=end
