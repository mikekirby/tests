require 'test/unit'
require 'motion_detection1_service'
require 'motion_detection1_service_test_mocks'


class MotionDetection1ServiceTests < Test::Unit::TestCase

  def test_soapresponse_with_one_region_should_return_array
    service = (MotionDetection1Service.new MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>{:region=>{:a=>"a1",:b=>"b2"}}}}))

    regions = service.get_md_regions
    puts regions.inspect

    assert_not_nil regions, "region_list should not be nil"
    assert_kind_of Array, regions, "region_list should be type Array"
    assert_equal(1, regions.size, "regions size should be 1")
  end

  def test_soapresponse_with_two_or_more_regions_should_return_array
    service = (MotionDetection1Service.new MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>{:region=>[{:c=>"c1"},{:d=>"d2"}]}}}))

    regions = service.get_md_regions
    puts regions.inspect

    assert_not_nil regions, "region_list should not be nil"
    assert_kind_of Array, regions, "region_list should be type Array"
    assert_equal(2, regions.size, "regions size should be 2")
  end

  def test_soapresponse_with_zero_regions_should_return_empty_array
    service = (MotionDetection1Service.new MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>{}}}))

    regions = service.get_md_regions
    puts regions.inspect
    
    assert_not_nil regions, "region_list should not be nil"
    assert_kind_of Array, regions, "region_list should be type Array"
    assert_equal(0, regions.size, "regions size should be 0")
  end

  def test_soapresponse_with_nil_region_list_should_return_empty_array
    service = (MotionDetection1Service.new MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>nil}}))

    regions = service.get_md_regions
    puts regions.inspect

    assert_not_nil regions, "regions should not be nil"
    assert_kind_of Array, regions, "regions should be type Array"
    assert(regions.empty?, "regions should be empty")
  end

  def test_service_should_not_throw_if_response_region_list_is_empty
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>{}}}))

    assert_nothing_raised() { srv.get_md_regions }
  end

  def test_service_should_not_throw_if_response_region_list_is_nil
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>nil}}))

    assert_nothing_raised() { srv.get_md_regions }
  end

  def test_soapresponse_without_region_elements_should_return_empty_array
    service = (MotionDetection1Service.new MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{:region_list=>{}}}))

    region_list = service.get_md_regions
    
    assert_not_nil region_list, "region_list should not be nil"
    assert_kind_of Array, region_list, "region_list should be type Array"
    assert(region_list.empty?, "region_list should be empty")
  end

  def test_motiondetection1service_should_construct_with_only_host_option
    host="waffle"
    service = MotionDetection1Service.new nil, :host=>host
    
    assert_equal "http://#{host}:8080/control/MotionDetection-1", service.client.request.endpoint.to_s, "endpoint host name should be #{host}"
  end

  def test_motiondetection1service_should_construct_with_only_port_option
    port="1234"
    service = MotionDetection1Service.new nil, :port=>port

    assert_equal "http://localhost:#{port}/control/MotionDetection-1", service.client.request.endpoint.to_s, "endpoint port should be #{port}"
  end

  def test_motiondetection1service_should_construct_with_only_path_option
    path="/syrup"
    service = MotionDetection1Service.new nil, :path=>path

    assert_equal "http://localhost:8080#{path}", service.client.request.endpoint.to_s, "endpoint path should be #{path}"
  end

  def test_motiondetection1service_should_construct_with_host_port_and_path_options
    host="waffle"
    port="1234"
    path="/syrup"
    service = MotionDetection1Service.new nil, :host=>host, :port=>port, :path=>path

    assert_equal "http://#{host}:#{port}#{path}", service.client.request.endpoint.to_s, "endpoint host, port, and path should be #{host}, #{port}, #{path}"
  end

end
