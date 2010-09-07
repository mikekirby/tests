require 'test/unit'
require 'motion_detection1_service'
require 'motion_detection1_service_test_mocks'

class MotionDetection1ServiceFaultTests < Test::Unit::TestCase
  def test_service_should_throw_if_response_is_empty
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new({}))

    assert_raise(NoMethodError) { srv.get_md_regions }
  end
  
  def dont_test_service_should_throw_if_GetMDRegionsResponse_is_empty
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>{}}))

    assert_raise(NameError) { srv.get_md_regions }
  end

  def test_service_should_throw_if_response_is_nil
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new(nil))

    assert_raise(NoMethodError) { srv.get_md_regions }
  end

  def test_service_should_throw_if_GetMDRegionsReponse_is_nil
    srv = MotionDetection1Service.new(
      MockClientGetMDRegionsReturnInjector.new({:get_md_regions_response=>nil}))

    assert_raise(NoMethodError) { srv.get_md_regions }
  end

end
