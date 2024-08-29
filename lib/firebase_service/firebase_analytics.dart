import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsScreen extends StatefulWidget {
  const FirebaseAnalyticsScreen({super.key});

  @override
  State<FirebaseAnalyticsScreen> createState() => _FirebaseAnalyticsScreenState();
}

class _FirebaseAnalyticsScreenState extends State<FirebaseAnalyticsScreen> {
  late FirebaseAnalytics analytics;

  @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance;
    print("Anylitics:${analytics.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Analytics'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAnalytics.instance
                .logBeginCheckout(
                value: 10.0,
                currency: 'USD',
                items: [
                  AnalyticsEventItem(
                      itemName: 'Socks',
                      itemId: 'xjw73ndnw',
                      price: 10.0
                  ),
                ],
                coupon: '10PERCENTOFF'
            );
            print(analytics);
          },
          child: const Text('Log Test Event'),
        ),
      ),
    );
  }
}
