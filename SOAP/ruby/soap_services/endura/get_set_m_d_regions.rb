require 'test/unit'
require 'motion_detection1_service'

Savon::Request.log = false

class GetSetMDRegions < Test::Unit::TestCase
  @camera = nil
  @mock_camera = nil

  def setup
    @camera = MotionDetection1Service.new nil, :host=>"192.168.0.2", :port=>"80"
    @mock_camera = MotionDetection1Service.new nil
  end

  def dont_test_camera_reset_md_configuration
    assert_raise(Savon::SOAPFault) { @camera.reset_md_configuration }
  end

  def dont_test_camera_set_md_configuration
    assert_raise(Savon::SOAPFault) { @camera.set_md_configuration }
  end

  def dont_test_camera_get_md_configuration
    md_config = @camera.get_md_configuration

    assert_equal( "80", md_config[:columns], "columns")
    assert_equal( "64", md_config[:rows], "rows")
    assert_equal("100", md_config[:max_sensitivity], "max_sensitivity")
    assert_equal(  "3", md_config[:max_regions], "max_regions")
    assert_equal(  "1", md_config[:alarm_enabled], "alarm_enabled")
  end

  def test_camera_clear_md_regions
    @camera.set_md_regions
    if @camera.get_md_regions.size == 0 then raise Exception.new("must have at least 1 md region") end
    
    @camera.clear_md_regions.inspect
    assert_equal 0, @camera.get_md_regions.size, "number of md regions"
  end

  def test_camera_set_md_regions_should_allow_one_region
    @camera.clear_md_regions
    assert_equal 0, @camera.get_md_regions.size, "precondition, number of md regions"

    @camera.set_md_regions(:region => {
            :name         => "Region1",
            :mask         => "region1",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 1, :column => 1},{:row => 20, :column => 20}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}}
          }
        )
        
    regions = @camera.get_md_regions

    assert_equal(1, regions.size, "number of regions")
    assert_equal("1", regions[0][:sensitivity], ":sensitivity")
    assert_equal("1", regions[0][:alarm_enabled], ":alarm_enabled")
    assert_equal("1", regions[0][:threshold], ":threshold")
    assert_equal("Region1", regions[0][:name], ":name")
    #assert_equal("region1", regions[0][:mask], ":mask")
    #assert_equal(2, regions[0][:coordinate].size, "number of coordinates")
    #assert_equal("upperLeft", regions[0][:coordinate][0][:position], "coordinate0 position")
    #assert_equal("lowerRight", regions[0][:coordinate][1][:position], "coordinate1 position")
    #assert_equal("1", regions[0][:coordinate][0][:row], "coordinate0 row")
    #assert_equal("1", regions[0][:coordinate][0][:column], "coordinate0 column")
    #assert_equal("20", regions[0][:coordinate][1][:row], "coordinate1 row")
    #assert_equal("20", regions[0][:coordinate][1][:column], "coordinate1 column")
  end

  def test_camera_set_md_regions_should_allow_one_region_as_array
    @camera.clear_md_regions
    assert_equal 0, @camera.get_md_regions.size, "precondition, number of md regions"

    @camera.set_md_regions(:region => [{
            :name         => "Region1",
            :mask         => "region1",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 1, :column => 1},{:row => 40, :column => 40}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}}
          }]
        )
        
    regions = @camera.get_md_regions

    assert_equal(1, regions.size, "number of regions")
    assert_equal("1", regions[0][:sensitivity], ":sensitivity")
    assert_equal("1", regions[0][:alarm_enabled], ":alarm_enabled")
    assert_equal("1", regions[0][:threshold], ":threshold")
    assert_equal("Region1", regions[0][:name], ":name")
  end

  def test_camera_set_md_regions_should_allow_three_regions
    @camera.clear_md_regions
    assert_equal 0, @camera.get_md_regions.size, "precondition, number of md regions"

    @camera.set_md_regions(:regions => [{
            :name         => "Region1",
            :mask         => "region1",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 0, :column => 0},{:row => 20, :column => 20}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}}
          }, {
            :name         => "Region2",
            :mask         => "region2",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 0, :column => 21},{:row => 20, :column => 40}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}}
          }, {
            :name         => "Region3",
            :mask         => "region3",
            :alarmEnabled => 1,
            :sensitivity  => 1,
            :threshold    => 1,
            :coordinate   => [{:row => 0, :column => 41},{:row => 20, :column => 61}],
            :attributes!  => {:coordinate => {:position => ["upperLeft", "lowerRight"]}}
          }]
        )

    regions = @camera.get_md_regions

    assert_equal(3, regions.size, "number of regions")
    assert_equal("1", regions[0][:sensitivity], ":sensitivity")
    assert_equal("1", regions[0][:alarm_enabled], ":alarm_enabled")
    assert_equal("1", regions[0][:threshold], ":threshold")
    assert_equal("Region1", regions[0][:name], ":name")
  end



  def dont_test_camera_get_alarm_state
    puts @camera.get_alarm_state.inspect
  end

  def dont_test_camera_get_max_sensitivity
    puts @camera.get_max_sensitivity.inspect
  end

  def dont_test_camera_get_max_regions
    puts @camera.get_max_regions.inspect
  end

  def dont_test_camera_get_md_regions
    puts @camera.get_md_regions.inspect
  end

  def dont_test_camara_get_enabled
    puts @camera.get_enabled.inspect
  end

  def dont_test_camara_get_grid_size
    puts @camera.get_grid_size.inspect
  end
end
