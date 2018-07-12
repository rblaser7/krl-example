ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
Lab 6 Track Trips
>>
    author "Ryan Blaser"
    logging on
  }
  
  rule process_trip {
    select when echo message
    pre {
        mileage = event:attr("mileage")
    }
    send_directive("trip", {"length": mileage})
  }
  
}
