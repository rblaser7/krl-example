ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
Lab 6 Part 3
>>
    author "Ryan Blaser"
    logging on
    provides trips, long_trips, short_trips
    share trips, long_trips, short_trips
  }

  global {
      trip_id = 0

      clear_trips = { "0": { "mileage": "", "timestamp": ""}}

      trips = function() {
          ent:all_trips
      }

      long_trips = function() {
          ent:long_trips
      }

      short_trips = function() {
        short_trips = {};
        short_trips_helper = function(id, short_trips) {
            (id < trip_id) => check_long(id, short_trips)
                            | short_trips
        };
        check_long = function(id, short_trips) {
            (ent:long_trips[id] == null) => add_trip(id, short_trips)
                                        | short_trips_helper(id + 1, short_trips)
        };
        add_trip = function(id, short_trips) {
            short_trips = short_trips.put([id], ent:all_trips[id]);
            short_trips_helper(id + 1, short_trips)
        };
        short_trips_helper(0, short_trips)
      }

      
  }
  
  rule collect_trips {
    select when explicit trip_processed
    pre {
        mileage = event:attr("mileage").klog("our passed in mileage for regular trip: ")
        timestamp = time:now()
    }
    always {
        ent:all_trips := ent:all_trips.defaultsTo(clear_trips, "initialized");
        ent:all_trips := ent:all_trips.put([trip_id, "mileage"], mileage)
                                        .put([trip_id, "timestamp"], timestamp);
        trip_id = trip_id + 1
    }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
        mileage = event:attr("mileage").klog("our passed in mileage for long trip: ")
        timestamp = time:now()
    }
    always {
        ent:long_trips := ent:long_trips.defaultsTo(clear_trips, "initialized");
        ent:long_trips := ent:long_trips.put([trip_id - 1, "mileage"], mileage)
                                        .put([trip_id - 1, "timestamp"], timestamp)
    }
  }

  rule clear_trips {
      select when car trip_reset
      always {
          ent:long_trips := clear_trips;
          ent:all_trips := clear_trips
      }
  }
  
}