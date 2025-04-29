import 'package:butterfly/core/mqtt/bloc/mqtt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MqttConnectionIndicator extends StatelessWidget {
  const MqttConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttBloc, MqttState>(
      builder: (context, state) {
        String statusText = 'Disconnected';
        Color backgroundColor = Colors.red.withAlpha((0.8 * 255).toInt());
        TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 8);

        if (state is MqttConnecting) {
          statusText = 'Connecting...';
          backgroundColor = Colors.yellow.withAlpha((0.8 * 255).toInt());
          textStyle = const TextStyle(color: Colors.black87, fontSize: 12);
        } else if (state is MqttConnected) {
          statusText = 'Connected';
          backgroundColor = Colors.green.withAlpha((0.8 * 255).toInt());
        } else if (state is MqttDisconnected) {
          statusText = 'Disconnected';
          backgroundColor = Colors.red.withAlpha((0.8 * 255).toInt());
        } else if (state is MqttConnectionFailed) {
          statusText = 'Connection Failed';
          backgroundColor = Colors.orange.withAlpha((0.8 * 255).toInt());
        }

        return Container(
          height: 12.0,
          color: backgroundColor,
          child: Center(
            child: Text(statusText, style: textStyle),
          ),
        );
      },
    );
  }
}
