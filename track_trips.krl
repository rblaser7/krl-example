ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
Lab 6 Track Trips Part 2
>>
    author "Ryan Blaser"
    logging on
  }
  
  rule process_trip {
    select when car new_trip
    pre {
        mileage = event:attr("mileage")
    }
    send_directive("trip", {"length": mileage})
  }
  
}
