import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:organiser_app/src/models/event_model.dart';
import 'package:organiser_app/src/services/attend_ticket.dart';
import 'package:organiser_app/src/services/attended_tickets.dart';
import 'package:organiser_app/src/services/booked_tickets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AttendanceDetailsScreen extends StatefulWidget {

  final Event event;

  AttendanceDetailsScreen({this.event});

  @override
  _AttendanceDetailsScreenState createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {

  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('take attendance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text('${widget.event.title}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.event.visitors}'),
                    Text('${widget.event.limit}'),
                  ],
                ),
              ),
            ),
            BookedTickets(
              event: Event(
                id: widget.event.id,
              ),
            ),
            AttendedTickets(
              event: Event(
                id: widget.event.id,
              ),
            ),
            //TODO: remove this ......
            Center(
              child: Text(_scanBarcode,
              style: TextStyle(fontSize: 20),),
            ),
            _scanBarcode == 'Unknown' ?
                Text('') :
            AttendTicket(
              event: Event(
                id: widget.event.id,
              ),
              bookingID: int.parse(_scanBarcode),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanQR(),
        child: Icon(Icons.qr_code),
      ),
    );
  }
}
