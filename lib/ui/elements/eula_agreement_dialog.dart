import 'package:ivrata_mobile/data/global/eula_agreement.dart';
import 'package:ivrata_mobile/logic/cache/prefs.dart';
import 'package:flutter/material.dart';

class AgreementDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Material(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Text(EulaAgreement.text),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: GestureDetector(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                30,
                                12,
                                30,
                                12,
                              ),
                              child: Text(
                                'I AGREE',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            await Prefs.instance.setBool('eulaAccepted', true);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
