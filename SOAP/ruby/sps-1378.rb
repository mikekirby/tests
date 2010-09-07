require 'rubygems'
require 'savon'

#### Debug ###########
Savon::Request.log_level = :info
Savon::Request.log = false if not $DEBUG

class Velocity
	####### Variable Defs ##############
		# rotation is of type tns:Xyz 
		# translation is of type tns:Xyz 
	attr_accessor :rotation, :translation 
	def initialize(rotation, translation) 
		@rotation = rotation
		@translation = translation
	end
	def to_s
		return "{:rotation=>#{rotation.to_s}, :translation=>#{translation.to_s}}"
	end
	def to_hash
		return {:rotation=>rotation.to_hash, :translation=>translation.to_hash}
	end
end

class Xyz
	####### Variable Defs ##############
		# x is of type xsd:int 
		# y is of type xsd:int 
		# z is of type xsd:int 
	attr_accessor :x, :y, :z 
	def initialize(x, y, z) 
		@x = x
		@y = y
		@z = z
	end
	def to_s
		return "{:x=>#{x.to_s}, :y=>#{y.to_s}, :z=>#{z.to_s}}"
	end
	def to_hash
		return {:x=>x, :y=>y, :z=>z}
	end
end

####### Zoom Type Def: ######
# <xsd:element name="Zoom">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element name="inOut" type="xsd:unsignedInt"/>
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
def zoom(lensClient, params)
	response = lensClient.zoom do |soap|
    soap.body = {:inOut=>params}
	end
	response = response.to_hash
end

####### GetVelocity Type Def: ######
# <xsd:element name="GetVelocity">
#         <xsd:complexType/>
#       </xsd:element>
def get_velocity(client)
	response = client.get_velocity do |soap|
	end
	response = response.to_hash
end

####### GetVelocityLimits Type Def: ######
# <xsd:element name="GetVelocityLimits">
#         <xsd:complexType/>
#       </xsd:element>
def get_velocity_limits(client)
	response = client.get_velocity_limits do |soap|
	end
	response = response.to_hash
end

####### SetVelocity Type Def: ######
# <xsd:element name="SetVelocity">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element name="velocity" type="tns:Velocity"/>
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
def set_velocity(client, setVelocityParam={})
	response = client.set_velocity do |soap|
		soap.body = {:velocity=>setVelocityParam}
	end
	response = response.to_hash
end

####### GetPosition Type Def: ######
# <xsd:element name="GetPosition">
#         <xsd:complexType/>
#       </xsd:element>
def get_position(client)
	response = client.get_position do |soap|
	end
	response = response.to_hash
end
####### SetPosition Type Def: ######
# <xsd:element name="SetPosition">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element name="position" type="tns:Velocity"/>
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
def set_position(client, setPositionParam={})
	response = client.set_position do |soap|
		soap.body = {:position=>setPositionParam}
	end
	response = response.to_hash
end

####### GetMag Type Def: ######
# <xsd:element name="GetMag">
#         <xsd:complexType/>
#       </xsd:element>
def get_mag(lensClient)
	response = lensClient.get_mag do |soap|
	end
	response = response.to_hash
end

if ARGV.size() < 1
  puts "Usage: sps-1378.rb hostname"
  exit
end

hostname = ARGV.shift

##### WSDL Part ########
client = Savon::Client.new "http://#{hostname}:80/services/PositioningControl/V1/PositioningControlV1.wsdl", :proxy => "http://#{hostname}:80/"
lensClient = Savon::Client.new "http://#{hostname}:80/services/LensControl/V1/LensControlV1.wsdl", :proxy => "http://#{hostname}:80"


Signal.trap("INT") do
  puts "\n Interupted! Stopping Camera"
	setVZero = Velocity.new(Xyz.new(0,0,0), Xyz.new(0,0,0)).to_hash
	set_velocity(client, setVZero)
  zoom(lensClient, 0)
  exit
end

begin
	maxV = get_velocity_limits(client)[:get_velocity_limits_response][:velocity_limits][:rotation]
	x_speed = (maxV[:x_max].to_i*0.75).to_i
	y_speed = (maxV[:y_max].to_i*0.75).to_i

  ["x", "y", "z", "xy", "xz", "yz", "xyz", "zx", "zy", "zyx"].each do |axis| 
	  
    rotation = Xyz.new(0,0,0)
    z_in_out = 0
	  
    puts "\nMoving in the #{axis} direction(s)"

    axis.each_char() do |char|
		  case char
			  when "x"
		      rotation.x = x_speed
			  when "y"
		      rotation.y = 0-(y_speed.to_i)
			  when "z"
		      z_in_out = 2
			end
	  end
	  
	  setVParam = Velocity.new(rotation, Xyz.new(0,0,0)).to_hash
    if axis =~ /^z/
      puts "Running zoom first"
      zoom(lensClient, z_in_out)
		  set_velocity(client, setVParam)
    else
      puts "Running zoom last"
		  set_velocity(client, setVParam)
      zoom(lensClient, z_in_out)
    end

	  runtime = 3*axis.size()
	  puts "Running for #{runtime} seconds"
		sleep runtime
    
    print "Final zoom level was ", get_mag(lensClient)[:get_mag_response][:magnification], "\n"	
	  

    puts "Stopping Camera and resetting zoom"
	  
    setVZero = Velocity.new(Xyz.new(0,0,0), Xyz.new(0,0,0)).to_hash
		set_velocity(client, setVZero)
	  
    while get_mag(lensClient)[:get_mag_response][:magnification] != "100" 
      zoom(lensClient, 1)
      sleep 1
    end
	  puts "Waiting for 2 seconds"
	  sleep 2
	
	end
rescue Exception => e
  puts "\n Exception Caught! Stopping Camera"
  setVZero = Velocity.new(Xyz.new(0,0,0), Xyz.new(0,0,0)).to_hash
  set_velocity(client, setVZero)
  zoom(lensClient, 0)
  puts e.message  
  puts e.backtrace.inspect  
  exit

end
