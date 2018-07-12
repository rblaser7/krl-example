ruleset echo {
  meta {
    name "Echo"
    description <<
Lab 6 Starting Ruleset
>>
    author "Ryan Blaser"
    logging on
  }
  
  rule hello {
    select when echo hello
    send_directive("say", {"something": "Hello World"})
  }

  rule message {
    select when echo message
    pre {
        input = event:attr("input")
    }
    send_directive("say", {"something":input})
  }
  
}
