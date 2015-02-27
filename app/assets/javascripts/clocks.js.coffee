# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


document.addEventListener("deviceready", onDeviceReady, false)

onDeviceReady() ->
  console.log 'Device Name: ' + device.name
  console.log 'Device Platform: ' + device.platform
  console.log 'Device UUID: ' + device.uuid
  console.log 'Device Version: ' + device.version