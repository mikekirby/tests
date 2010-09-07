Feature: Control the field of view
  In order to zoom in and zoom out
  The user should be able to control the lens magnification

  Scenario: Restrict the level of zoom
    Given the camera provides the LensControl service
    When I query the MaxDigitalMag
    And when I query the MaxOpticalMag
    Then the MaxDigitalMag should greater than or equal to MaxOpticalMag
  
  Scenario:  
