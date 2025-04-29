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

        if (state is MqttConnecting) {
          statusText = 'Connecting...';
          backgroundColor = const Color.fromARGB(255, 116, 106, 13)
              .withAlpha((0.8 * 255).toInt());
        } else if (state is MqttConnected) {
          statusText = 'Connected';
          backgroundColor = const Color.fromARGB(255, 81, 92, 218)
              .withAlpha((0.8 * 255).toInt());
        } else if (state is MqttDisconnected) {
          statusText = 'Disconnected';
          backgroundColor = const Color.fromARGB(255, 170, 39, 30)
              .withAlpha((0.8 * 255).toInt());
        } else if (state is MqttConnectionFailed) {
          statusText = 'Connection Failed';
          backgroundColor = const Color.fromARGB(255, 239, 116, 235)
              .withAlpha((0.8 * 255).toInt());
        }

        return Container(
          height: 20.0,
          color: backgroundColor,
          child: Center(
              child: Text(statusText,
                  style: Theme.of(context).textTheme.labelSmall)),
        );
      },
    );
  }
}
