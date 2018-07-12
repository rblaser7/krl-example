ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
Lab 6 Track Trips
>>
    author "Ryan Blaser"
    logging on
  }

  global {
      long_trip = 500
  }
  
  rule process_trip {
    select when car new_trip
    pre {
        mileage = event:attr("mileage")
    }
    send_directive("trip", {"length": mileage})
    always {
        raise explicit event "trip_processed"
           attributes event:attrs
    }
  }

  rule find_long_trips {
    select when explicit trip_processed
    pre {
        mileage = event:attr("mileage")
    }
    raise explicit event "found_long_trip"
        attributes event:attrs if (mileage > long_trip);
    }

  rule found_long_trip {
    select when explicit found_long_trip
    pre {
        mileage = event:attr("mileage")
    }
    send_directive("long_trip", {"length": mileage})
  }
  
}
