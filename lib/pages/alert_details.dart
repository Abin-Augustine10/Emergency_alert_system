import 'dart:async';
import 'dart:convert';

import 'package:alert_me/utils/alert_functions.dart';
import 'package:alert_me/utils/alert_receiver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';


class AlertDetails extends StatefulWidget {
  final AlertData alertDetails;

  const AlertDetails({Key? key, required this.alertDetails}) : super(key: key);

  @override
  State<AlertDetails> createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  late Future<ProfileData> profileDataFuture;

  @override
  void initState() {
    super.initState();
    profileDataFuture = AlertReceiver.fetchProfileData(widget.alertDetails.id);
  }

  String timeDiff() {
    String currentTimeString = DateFormat('hh:mm:ss').format(DateTime.now());
    DateTime currentTime = DateTime.parse('2000-01-01 $currentTimeString');
    DateTime alertTime =
        DateTime.parse('2000-01-01 ${widget.alertDetails.time}');

    Duration difference = currentTime.difference(alertTime);

    if (difference.inHours < 1) {
      return "${difference.inMinutes.remainder(60)}m ago";
    } else {
      return "${difference.inHours}h ${difference.inMinutes.remainder(60)}m ago";
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await canLaunchUrlString(url)) {
      throw Exception('Could not launch $url');
    }
    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(


  //   String differenceString;

  // //  String specifiedTimeString = '09:30:00'; // Example: 9:30 AM


  // String currentTimeString = DateFormat('HH:mm:ss').format(DateTime.now());
  // // DateTime alertTime = DateFormat('HH:mm:ss').parse(profileData.time);


  // DateTime alertTime = DateFormat('HH:mm:ss').parse('21:40:44');

  // DateTime currentTime = DateFormat('HH:mm:ss').parse(currentTimeString);

  // Duration difference = currentTime.difference(alertTime);

  // int hours = difference.inHours ;
  // int minutes = difference.inMinutes.remainder(60) ;
  // int seconds = difference.inSeconds.remainder(60) ;

  // if(hours>0){
  //   differenceString = '$hours h $minutes m $seconds s ago';
  // }
  // else{
  //   differenceString='$minutes m $seconds s ago';
  // }

    return 

SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(170, 219, 253, 1),
          title: const Text(
            'Alert Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),

        body: FutureBuilder<ProfileData>(
          future: profileDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading profile data'));
            } else {
              final profileData = snapshot.data!;
              return alertDetailsContent(profileData);
            }
          },
        ),
      ),
    );
  }

  Column alertDetailsContent(ProfileData profileData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0, top: 30, right: 10.0),
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, top: 25.0, right: 10),
            height: 430.0,
            width: 390.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF9D1D1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.alertDetails.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10.0, top: 30, right: 10.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, top: 25.0, right: 10),
                  height: 430.0,
                  width: 390.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9D1D1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    children: [
                       Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  widget.alertDetails.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(profileData.time),
                          )
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Text('Blood Group : ${profileData.bloodGroup}'),
                      const SizedBox(height: 30.0),
                      const Text('Medical Info : '),
                      const SizedBox(height: 10.0),
                      Text(profileData.medicalDetails),
                      const SizedBox(height: 35.0),
                      ElevatedButton(
                        onPressed: () => {debugPrint("[Pressed] view on map")},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          fixedSize: const Size(10, 50),
                          textStyle: const TextStyle(fontSize: 20),

                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(timeDiff()),
                    )
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    const Text(
                      'Blood Group: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(profileData.bloodGroup)
                  ],
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Medical Info: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5.0),
                Text(profileData.medicalDetails),
                const SizedBox(height: 35.0),
                ElevatedButton(
                  onPressed: () async {
                    final List<dynamic> locations =
                        json.decode(widget.alertDetails.location);

                    String encodedLatitude =
                        Uri.encodeComponent(locations[0].toString());
                    String encodedLongitude =
                        Uri.encodeComponent(locations[1].toString());
                    String encodedComma = Uri.encodeComponent(",");
                    String mapUrl =
                        "https://maps.google.com/maps?q=$encodedLatitude$encodedComma$encodedLongitude";
                    await _launchUrl(mapUrl);

                    debugPrint("[Pressed] view on map");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    fixedSize: const Size(10, 50),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('View on map'),
                ),
                const SizedBox(height: 35),
                IconButton(
                    onPressed: () {},
                    icon: const Row(
                      children: [
                        Icon(Icons.fire_extinguisher),
                        Text("fire"),
                      ],
                    )),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "   ${profileData.flagCount} people flagged false",
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye,
                          color: Colors.black54,
                        ),
                        Text(
                          " ${profileData.viewCount}",
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
            width: 390,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    debugPrint(profileData.phone);
                    _launchUrl('tel://${profileData.phone}');
                    debugPrint("[pressed] contact");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  child: const Text(
                    "contact",
                    style: TextStyle(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    profileData.flagCount = profileData.flagCount + 1;
                    final response = await AlertFunctions.updateCount(
                        widget.alertDetails.id);
                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);
                      profileData.flagCount = responseData['flag_count'];
                    } else {
                      SnackBar snackBar = const SnackBar(
                          content: Text("can't update flagcount"));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    setState(() {
                      profileData;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  child: const Text("flag as false"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
