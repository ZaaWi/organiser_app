import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:intl/intl.dart';


class Event {
  //TODO: Refactor with real data
  int id;
  String title;
  String description;
  String dateTime;
  List<Ticket> tickets;
  String img;
  String location;
  bool isAvailable;
  int visitors;
  int limit;
  String city;

  Event(
      {this.id,
        this.title,
        this.description,
        this.dateTime,
        this.tickets,
        this.img,
        this.location,
        this.isAvailable,
        this.visitors,
        this.limit,
        this.city});

  String getTime(String data) {
    final date = DateTime.parse(data);
    final format = DateFormat('HH:MM a');
    var dateData = format.format(date).toString();
    return dateData;
  }

  String getDay(String data) {
    final date = DateTime.parse(data);
    final format = DateFormat('EEE');
    var dateData = format.format(date).toString();
    return dateData;
  }

  String getDate(String data) {
    final date = DateTime.parse(data);
    final format = DateFormat('MMM d');
    var dateData = format.format(date).toString();
    return dateData;
  }
}