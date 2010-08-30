<?php
$location = "http://localhost:8088/onvif/services";
$uri = "urn:pelco:services:extension:onvif:deviceIO:1";

$client = new SoapClient(null, array('location'=>$location, 'uri'=>$uri));

$results = $client->GetAlarmInputs();
var_dump($results);

# new SoapParam('b', 'a')
# $results = $client->SetAlarmInputs();
# var_dump($results);

?>

