
//dashboard
const String countEventsQuery = r"""
query countEvents ($user_ID: ID!) {
  eventsConnection
  (
    where: {
      organiser: {
        id: $user_ID
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}

                  """;
const String countLikesQuery = r"""
query getLikes ($user_ID: ID!) {
  usersConnection 
  (
    where: {
      wishlist: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count 
    }
  }
}

                  """;
const String countTicketsQuery = r"""
query ticketCount ($user_ID: ID!) {
  ticktsConnection 
  (
    where: {
      event: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}
                  """;
const String countBookedTicketsQuery = r"""
query bookingCount ($user_ID: ID!) {
  bookzsConnection 
  (
    where: {
      event: {
        organiser: {
          id: $user_ID
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}
                  """;
const String countAttendanceQuery = r"""
query attendanceCount ($user_ID: ID!) {
  attendsConnection 
  (
    where: {
      booking: {
        event: {
          organiser: {
            id: $user_ID
          }
        }
      }
    }
  )
  {
    aggregate {
      count
    }
  }
}

                  """;
//attend ticket
const String getBookedTicketsQuery = r""" 
query ($booking_id: ID!, $event_id: ID!) {
  bookzs 
  (where: {
    id: $booking_id,
    ticket: {
      event: {
        id: $event_id
      }
    }
  },)
  {
    id
    booked_user{
      id
    }
    ticket {
      id
      name
      event{
        id
      }
    }
    validity
  }
}
                  """;
const String getAttendedTicketsQuery = r""" 
query ($booking_id: ID!)  {
  attends 
  (where: {
    booking: {
      id: $booking_id
    }
  })
  {
    id
    attend_user {
      id
      username
    }
    booking {
      validity
      id
      event {
        id
        title
      }
      ticket {
        id
        name
        quantity
      }
    }
    
  }
}
                  """;
//attendance event
const String getEventsQuery = r"""  
query getMyEvents ($organiser_id: ID!) {
  events 
  (
    where: {
      organiser: {
        id: $organiser_id
      }
    }
  )
  {
    id
    visitors
    title
    limit
    location
    city {
      name
    }
    tickts {
      id
      quantity
      name
    }
  }
}
                  """;
//attended tickets
const String attendedTicketsQuery = r"""
query ($event_id: ID!)  {
  attends 
  (where: {
    booking: {
      event: {
        id: $event_id
      }
    }
  })
  {
    id
    attend_user {
      id
      username
    }
    booking {
      validity
      id
      event {
        id
        title
      }
      ticket {
        id
        name
        quantity
      }
    }
    
  }
}
                  """;
//booked ticket
const String getBookedTicketsQueryCopy = r""" 
query ($event_id: ID!) {
  bookzs 
  (where: {
    event: {
      id: $event_id
    }
  },)
  {
    id
    event {
      id
      title
    }
    ticket {
      id
      name
      quantity
    }
    validity
  }
}
                  """;
//get categories and cities
const String categoriesQuery = r"""
query getCategories {
  categories {
    id
    name
  }
}
                  """;
const String citiesQuery = r"""
query getCities {
  cities {
    id
    name
  }
}
                  """;
//events list
const String getEventsQueryCopy = r"""  
query getMyEvents ($organiser_id: ID!) {
  events 
  (
    where: {
      organiser: {
        id: $organiser_id
      }
    }
  )
  {
    id
    title
    description
    date
    visitors
    category {
      id
      name
    }
    image {
      formats:url
      id
    }
    limit
    location
    city {
      name
      id
    }
    tickts {
      id
      quantity
      name
    }
  }
}
                  """;
//user avatar
const String getUserImageQuery = r"""
query ($id: ID!) {
  users (where: {
    id: $id
  }) {
    avatar {
      url
    }
  }
}
""";
//tickets list
const String getEventTicketsQuery = r"""
  query getEventTickets ($event_ID: ID!) {
  tickts
  (
    where: {
      event: {
        id: $event_ID
      }
    }
  )
  {
    id
    name
    quantity
    event{
      id
      title
    }
  }
}
""";