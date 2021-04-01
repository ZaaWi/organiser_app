//create event
const String createEventMutation = r"""
mutation createEvent ($title: String!, $description: String!, $category: ID!, $city: ID!,
 $image: [ID], $organiser: ID!, $date: DateTime!, $limit: Int!, $location: String!) {
  createEvent 
  (
    input: {
      data: {
        title: $title,
        description: $description,
        category: $category,
        city: $city,
        image: $image,
        organiser: $organiser,
        date: $date,
        limit: $limit,
        location: $location,
      }
    }
  ) {
    event {
      title
      id
    }
  }
  
}
                  """;
//create ticket
const String createTicketMutation = r"""
mutation createTicket ($name: String!, $event_ID: ID!, $quantity: Int!) {
  createTickt 
  (
    input: {
      data: {
        name: $name,
        quantity: $quantity,
        event: $event_ID,
      }
    }
  ) {
    tickt {
      name
      id
    }
  }
  
}
                  """;
//edit event
const String editEventMutation = r"""
   mutation EditEvent ($image_ID: [ID], $title: String!, $description: String!, $location: String!, 
$limit: Int! $date: DateTime! $category: ID!, $city: ID!, $event_ID: ID!) {
  updateEvent (
    input: {
      where: {
        id: $event_ID
      }
      data: {
        title: $title,
        description: $description,
        location: $location,
        limit: $limit,
        category: $category,
        city: $city,
        image: $image_ID,
        date: $date,
      }
    }
  )  {
    event {
      id
      title
    }
  }
}
                  """;
//edit ticket
const String editTicketMutation = r"""
  mutation editTicket ($ticket_ID: ID!, $name: String!, $quantity: Int!) {
  updateTickt 
  (
    input: {
      where: {
        id: $ticket_ID
      }
      data: {
        name: $name,
        quantity: $quantity
      }
    }
  )
  {
    tickt {
      id
    }
  }
}
""";
//image upload
const String uploadImageMutation = r"""
mutation uploadImage ($file: Upload!) {
  upload
  (
    file: $file
  )
  {
    name
    id
  }
}
                  """;
//login
const String loginMutation = r"""
                  mutation {
  login(input: { identifier: "zawi", password: "Zawi123" }) {
    jwt
    user {
      username
      id
      email
      role {
        id
      }
    }
  }
}
                  """;

//missing

final String createAttendMutation = r"""
  
  
mutation createAttende ($booking_ID: ID!, $user_ID: ID!) {
  createAttend (
    input: {
      data: {
        booking: $booking_ID,
        attend_user: $user_ID
      }
    }
  ) {
    attend {
      id
    }
  }
}



                  """;
final String decreaseValidityMutation = r"""
  
  
mutation decreaseValidity ($booking_ID: ID!, $validity: Int!) {
  updateBookz(
    input: {
      where: {
        id: $booking_ID
      }
      data: {
        validity: $validity
      }
    }
  ) {
    bookz {
      id
    }
  }
}



                  """;