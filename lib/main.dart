import 'package:flutter/material.dart';
import 'package:smart_home/curtains_page.dart';
import 'package:smart_home/ir_Page.dart';
import 'package:smart_home/person.dart';
import 'package:smart_home/door_page.dart';
import 'package:smart_home/my_reused_widgets.dart';
import 'package:smart_home/remote_page.dart';
import 'package:smart_home/webpage.dart';
import 'constats.dart';
import 'dynamic_alarm_page.dart';
import 'init_IR_page.dart';
import 'home_page.dart';

import 'package:ez_mqtt_client/ez_mqtt_client.dart';

EzMqttClient mqttClient;

void initMQTT() async {
  try {
    mqttClient = EzMqttClient.secure(
        url: brokerIP,
        clientId: Utils.uuid,
        enableLogs: false,
        port: brokerPORT,
        secureCertificate:
            await Utils.getFileFromAssets("assets/trustid-x3-root.pem"));

    await mqttClient.connect(
        username: brokerUsername, password: brokerPassword);

    subscribe('Gas');
    subscribe('Pose');
  } catch (e) {
    print(e);
    toast("Couldn't connect to Server");
  }
}

Future<void> subscribe(String topic) async {
  await mqttClient.subscribeToTopic(
      topic: topic,
      onMessage: (topic, message) {
        if (topic == topic) {
          if(topic == "Gas"){
            toast("GAS DETECTED In " + message);
            pushAlarm(DateTime.now(), true, "Gas Detected");
          }
          else{
            toast("Time to stand!");
            pushAlarm(DateTime.now(), true, "Stand up and move a little for one minute");
          }
        }
      });
}

void main() {
  runApp(MyApp());
  initMQTT();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive Smart Home',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'OpenSans'),
      initialRoute: 'Language Page',
      routes: {
        'Home Page': (context) => SafeArea(child: HomePage()),
        'Dynamic Alarm Page': (context) => SafeArea(child: DynamicAlarmPage()),
        'Init IR Page': (context) => SafeArea(child: InfraredPage()),
        'Webpage': (context) => SafeArea(child: WebPage()),
        'Send IR Page': (context) => SafeArea(child: RemotePage()),
        'Door Page': (context) => SafeArea(child: DoorPage()),
        'Curtains Page': (context) => SafeArea(child: CurtainsPage()),
        'Person Page': (context) => SafeArea(child: PersonPage()),
        'IR Page': (context) => SafeArea(child: IrPage()),
      },
      home: HomePage(),
    );
  }
}
