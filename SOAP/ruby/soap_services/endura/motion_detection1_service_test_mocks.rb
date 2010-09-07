class MockClientGetMDRegionsReturnInjector
  def initialize(payload)
    @payload = payload
  end

  def get_md_regions!
    return @payload
  end
end
