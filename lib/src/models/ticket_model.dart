import 'package:organiser_app/src/models/event_model.dart';

class Ticket {
  int id;
  String ticketName;
  bool expired;
  Event event;
  int quantity;

  Ticket({this.id, this.ticketName, this.expired, this.event, this.quantity});
}

class BookedTicket extends Ticket {
  int bookingID;
  int validity;
  int bookedUserID;

  BookedTicket(
      {this.validity,
      this.bookingID,
      this.bookedUserID,
      int id,
      Event event,
      int quantity,
      String ticketName}) {
    super.id = id;
    // only event title
    super.event = event;
    super.quantity = quantity;
    super.ticketName = ticketName;
  }
}

class AttendedTicket {
  int attendID;
  BookedTicket bookedTicket;

  AttendedTicket({this.attendID, this.bookedTicket});
}
