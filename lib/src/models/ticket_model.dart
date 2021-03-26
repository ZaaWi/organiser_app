import 'package:organiser_app/src/models/event_model.dart';


class Ticket {
  int id;
  String ticketName;
  bool expired;
  Event event;
  int quantity;

  Ticket(
      {this.id,
        this.ticketName,
        this.expired,
        this.event,
        this.quantity});
}
