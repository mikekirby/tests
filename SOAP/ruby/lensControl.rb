#!/usr/bin/ruby

require "rubygems"
require "savon"

Savon::Request.log = false

# Patch to make Savon compatible with some fragile system code
# Wrap SOAPAction in double quotes
module Savon
  class SOAP
    def action
      '"'+ @action +'"'
    end
  end
end

# API/WSDL location: http://svn.pelco.org/repos/documents/serviceapi/services
#
# <!--GetMaxMag-->
# <xsd:element name="GetMaxMag">
# <xsd:complexType/>
# </xsd:element>
#
# <!--GetMaxMag Response-->
# <xsd:element name="GetMaxMagResponse">
# <xsd:complexType>
# <xsd:sequence>
# <xsd:element name="magnification" type="xsd:unsig vvbnedInt"/>
# </xsd:sequence>
# </xsd:complexType>
# </xsd:element>



class ProxyFactory
  @LENSCONTROL_WSDL_URL = 'http://localhost/services/LensControl/V1/LensControlV1.wsdl'
  def self.build_lenscontrolproxy(device_ip='127.0.0.1', device_port='49152')
    LensControlProxy.new get_lenscontrolclient(device_ip, device_port)
  end

  def self.get_lenscontrolclient(device_ip, device_port)
    endpoint = "http://#{device_ip}:#{device_port}/control/LensControl-1"
    Savon::Client.new @LENSCONTROL_WSDL_URL, :soap_endpoint => endpoint
  end
end

class LensControlProxy
  def initialize(soap_client)
    @soap_client = soap_client
  end

  def get_max_mag
   @soap_client.get_max_mag.to_hash[:get_max_mag_response][:magnification]
  end

  def get_max_digital_mag
   @soap_client.get_max_digital_mag.to_hash[:get_max_digital_mag_response][:magnification]
  end

  def set_max_mag(max_mag=0)
    @soap_client.set_max_mag { |soap| soap.body = {:magnification=>max_mag}}
  end
end

class BasicIpDevice
  attr_reader :ip, :port, :name
  def initialize(name="",ip="127.0.0.1",port="49152")
    @ip=ip
    @port=port
    @name=name
  end
end

def test(devices)
  proxies = Hash.new
  devices.each {|d| proxies[d.name] = ProxyFactory.build_lenscontrolproxy(d.ip, d.port) }

  100.step(3200,100) do |mag|
    proxies.each_key do |k|
      p=proxies[k]
      p.set_max_mag mag
      puts "MaxMag: #{mag} #{k} Get=#{p.get_max_mag} Digital=#{p.get_max_digital_mag}"
    end
  end
end



=begin
Test Devices and Execution Below
=end

devices = Array.new
devices.push BasicIpDevice.new "TXB","10.220.232.39","80"
devices.push BasicIpDevice.new "SPT","10.220.232.6","49152"

test devices
