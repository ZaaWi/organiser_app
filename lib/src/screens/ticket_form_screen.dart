import 'package:flutter/material.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/services/createTicket.dart';

class TicketFormScreen extends StatefulWidget {

  final int eventID;


  TicketFormScreen({this.eventID});

  @override
  _TicketFormScreenState createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Widget createTicket;
  String ticketName;
  int ticketQuantity;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              (
              createTicket == null ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ticket name'),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter ticket name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // _title = value;
                      ticketName = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Quantity'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    // controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (isNumeric(value)) {
                          return 'value has to be number';
                        }
                        return 'please enter quantity';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // _description = value;
                      ticketQuantity = int.parse(value);
                    },
                  ),
                ],
              ) :
                  createTicket
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if(_formKey.currentState.validate()) {
            setState(() {
              createTicket = CreateTicket(
                ticket: Ticket(
                    ticketName: ticketName,
                    quantity: ticketQuantity,
                    event: Event(
                        id: widget.eventID
                    )
                ),
              );
            });
          }
          //TODO: add ticket
        },
      ),
    );
  }
}
