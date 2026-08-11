import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialService {
  SerialPort? _port;
  SerialPortReader? _reader;
  StreamSubscription<Uint8List>? _subscription;
  final StringBuffer _buffer = StringBuffer();

  final _dataController = StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataController.stream;

  bool get isConnected => _port != null && _port!.isOpen;

  static List<String> getAvailablePorts() {
    try {
      return SerialPort.availablePorts;
    } catch (_) {
      return [];
    }
  }

  bool connect(String portName, {int baudRate = 115200}) {
    disconnect();

    try {
      final port = SerialPort(portName);
      if (!port.openReadWrite()) {
        return false;
      }

      final config = port.config;
      config.baudRate = baudRate;
      config.bits = 8;
      config.stopBits = 1;
      config.parity = SerialPortParity.none;
      config.setFlowControl(SerialPortFlowControl.none);
      port.config = config;

      _port = port;

      _reader = SerialPortReader(_port!);
      _subscription = _reader!.stream.listen(
        (data) {
          final String chunk = utf8.decode(data, allowMalformed: true);
          _buffer.write(chunk);

          String contents = _buffer.toString();
          while (contents.contains('\n')) {
            int index = contents.indexOf('\n');
            String line = contents.substring(0, index).trim();
            contents = contents.substring(index + 1);

            if (line.isNotEmpty) {
              debugPrint('[SERIAL RX] $line');
              _dataController.add(line);
            }
          }
          _buffer.clear();
          _buffer.write(contents);
        },
        onError: (error) {
          disconnect();
        },
        onDone: () {
          disconnect();
        },
      );
      return true;
    } catch (e) {
      disconnect();
      return false;
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _reader = null;

    if (_port != null) {
      if (_port!.isOpen) {
        _port!.close();
      }
      _port!.dispose();
      _port = null;
    }
    _buffer.clear();
  }

  bool sendCommand(String jsonCommand) {
    if (_port == null || !_port!.isOpen) return false;
    try {
      final String payload = jsonCommand.endsWith('\n') ? jsonCommand : '$jsonCommand\n';
      final Uint8List bytes = Uint8List.fromList(utf8.encode(payload));
      int bytesWritten = _port!.write(bytes);
      return bytesWritten > 0;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    disconnect();
    _dataController.close();
  }
}
