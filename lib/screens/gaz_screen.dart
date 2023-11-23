import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/ui/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as syncfusion;
import 'package:gauge_indicator/gauge_indicator.dart' as gauge;
import 'package:d_chart/d_chart.dart';
class GazScreen extends StatefulWidget{
  @override
  State<GazScreen> createState() => _GazScreenState();
}

class _GazScreenState extends State<GazScreen> {
  double valueGaz=0.0;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();
  int _currentSliderValue = 1;
  TextEditingController sliderController = TextEditingController();





  List<OrdinalData> ordinalList = [

  ];

  late final ordinalGroup = [
    OrdinalGroup(
      id: '1',
      data: ordinalList,
    ),
  ];

  final CollectionReference _temperatureHumidityCollection =
  FirebaseFirestore.instance.collection('data');



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseReference.child('gaz').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        valueGaz = data;
      });

      // Ensure that 'Temp' node exists in your Firebase Realtime Database
      // Use 'FieldValue.serverTimestamp()' to obtain the server timestamp
      _temperatureHumidityCollection.add({
        'Gaz': data,
        'timestamp': FieldValue.serverTimestamp(),
      });

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Gaz'
        ),
      ) ,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
          Container(

          width: double.infinity,
          padding:  EdgeInsets.all(5),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                      child: Container(

                        height: 250,
                        child: syncfusion.SfRadialGauge(

                          enableLoadingAnimation:true,
                          axes: <syncfusion.RadialAxis>[
                            syncfusion.RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              ranges: <syncfusion.GaugeRange>[
                                syncfusion.GaugeRange(startValue: 0, endValue: 33, color: Colors.green),
                                syncfusion.GaugeRange(startValue: 33, endValue: 66, color: Colors.orange),
                                syncfusion.GaugeRange(startValue: 66, endValue: 100, color: Colors.red),
                              ],
                              pointers: <syncfusion.GaugePointer>[
                                syncfusion.NeedlePointer(value: valueGaz,),
                              ],
                              annotations: <syncfusion.GaugeAnnotation>[
                                syncfusion.GaugeAnnotation(
                                  widget: Container(
                                    child: Text('${valueGaz}%', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                  ),
                                  angle: 85,
                                  positionFactor: 0.5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  Text('Gas Level Realtime', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),),


                ],
              ),
            ),
          ),
        ),
        SizedBox(
              height: 15,
            ),
            Card(
              color: Colors.white,
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('data').snapshots(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text('No data available');
                    }

                    var documents = snapshot.data!.docs;


                    for (var document in documents) {
                      var data = document.data() as Map<String, dynamic>;
                      // print('----------------------${data}');


                      ordinalList.add(OrdinalData(domain: '${data['Gaz']}', measure:data['Gaz']) );




                    }

                    return Container(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: DChartBarO(
                          fillColor: (group, ordinalData, index) {
                            if (ordinalData.measure >= _currentSliderValue) return cutomColor().dangerColorText;
                            return Colors.black54;
                          },

                          groupList: ordinalGroup,
                        ),
                      ),
                    );
                  },
                ),
                Text('Gas Chart', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),),

              ],
            ),
          ),
        ),

            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Slider(
                      value: _currentSliderValue.toDouble(),
                      max: 100,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value.toInt();
                          sliderController.text = _currentSliderValue.toString();
                          print(_currentSliderValue);
                        });
                      },
                    ),
                    Text('Chose chart max value: ${_currentSliderValue}', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),





          ],
        ),
      ),
    );
  }
}