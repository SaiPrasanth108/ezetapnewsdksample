import 'dart:convert';

import 'package:ezetapnewsdksample/bill_widet.dart';
import 'package:flutter/material.dart';
import 'package:ezetap_sdk/ezetap_sdk.dart';
import 'package:screenshot/screenshot.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  String _result = 'Unknown';

  Future<void> initSdk() async {
    var json = {
      "prodAppKey": "2b393c4f-42ff-48f6-8529-9f648e81c5bc",
      "merchantName": "merchantName",
      "userName": "2812202300 ",
      "currencyCode": 'INR',
      "appMode": "Your environment",
      "captureSignature": 'true',
      "prepareDevice": 'false',
      "captureReceipt": 'false'
    };

    String? result = await EzetapSdk.initialize(jsonEncode(json));
    if (!mounted) return;
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ezetap Sample Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              initSdk();
            },
            child: const Text("SDK Init"),
          ),
          ElevatedButton(
            onPressed: () {
              onPreparePressed();
            },
            child: const Text("Prepare Device"),
          ),
          ElevatedButton(
            onPressed: () {
              onPressed();
            },
            child: const Text("Print Bitmap"),
          ),
          ElevatedButton(
            onPressed: () {
              checkPrinterStatus();
            },
            child: const Text("Printer Status"),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(_result),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onPreparePressed() async {
    String? result = await EzetapSdk.prepareDevice();
    if (!mounted) return;
    setState(() {
      _result = result;
    });
  }

  Future<void> onPressed() async {
    final controller = ScreenshotController();

    ///BillWidget is a dummy receipt widget to create base64
    final bytes =
        await controller.captureFromWidget(const BillWidget(), pixelRatio: 2.0);
    var base64Image = base64Encode(bytes);
    await EzetapSdk.printBitmap(base64Image);
  }

  Future<void> checkPrinterStatus() async {
    String? result = await EzetapSdk.checkPrinterStatus();
    if (!mounted) return;
    setState(() {
      _result = result;
    });
  }
}
