import 'package:ivrata_mobile/logic/api/videos_api.dart';
import 'package:flutter/material.dart';

class LivestreamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: VideosAPI.getLivestreams(),
        builder: (context, livestreams) =>
            livestreams.connectionState != ConnectionState.done ||
                    livestreams.hasError ||
                    livestreams.hasData && livestreams.data['error'] != false ||
                    livestreams.hasData &&
                        livestreams.data['1'] == null &&
                        livestreams.data['0']['msg'] == 'OFFLINE'
                ? Center(
                    child: livestreams.connectionState != ConnectionState.done
                        ? CircularProgressIndicator()
                        : Text(
                            livestreams.hasError
                                ? livestreams.error.toString()
                                : livestreams.data['error'] != false
                                    ? livestreams.data['error']
                                    : 'No livestreams active at this time!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                  )
                : const SizedBox(),
      ),
    );
  }
}
