import 'package:flutter/material.dart';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/models/ticket_model.dart';
import 'package:organiser_app/src/services/createTicket.dart';
import 'package:organiser_app/src/services/edit_ticket.dart';

class TicketFormScreen extends StatefulWidget {
  final Event event;
  final String formType;
  final Ticket ticket;

  TicketFormScreen({
    this.event,
    this.formType,
    this.ticket,
  });

  @override
  _TicketFormScreenState createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Widget ticketService;
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
        title: Text('Ticket ${widget.formType} Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              (ticketService == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ticket name'),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: widget.formType == 'EDIT'
                              ? widget.ticket.ticketName
                              : null,
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
                          initialValue: widget.formType == 'EDIT' ?
                          widget.ticket.quantity.toString() :
                          null,
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
                    )
                  : ticketService),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: widget.formType == 'ADD'
            ? Icon(Icons.add)
            : Icon(Icons.playlist_add_check_outlined),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              if (widget.formType == 'ADD') {
                ticketService = CreateTicket(
                  ticket: Ticket(
                    ticketName: ticketName,
                    quantity: ticketQuantity,
                    event: widget.event,
                  ),
                );
              } else {
                //TODO: Edit ticket
                ticketService = EditTicket(
                  ticket: Ticket(
                    id: widget.ticket.id,
                    ticketName: ticketName == null ? widget.ticket.ticketName : ticketName,
                    quantity: ticketQuantity == null ? widget.ticket.quantity : ticketQuantity,
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }
}
