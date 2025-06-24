import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../config/app_config.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  String? _currentTrainingId;
  String? _authToken;

  // Getters
  bool get isConnected => _isConnected;
  Stream<Map<String, dynamic>>? get messageStream => _messageController?.stream;

  /// Initialize the real-time service
  void initialize(String authToken) {
    _authToken = authToken;
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  /// Connect to training channel
  Future<bool> connectToTraining(String trainingId) async {
    try {
      if (_isConnected && _currentTrainingId == trainingId) {
        print('🔗 Realtime Service: Already connected to training $trainingId');
        return true;
      }

      // Disconnect from previous connection
      disconnect();

      final wsUrl = '${AppConfig.baseUrl.replaceFirst('http', 'ws')}/realtime/training/$trainingId';
      print('🔗 Realtime Service: Connecting to $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _currentTrainingId = trainingId;

      // Listen for messages
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('❌ Realtime Service: WebSocket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          print('🔌 Realtime Service: WebSocket connection closed');
          _handleDisconnection();
        },
      );

      // Send authentication
      await _sendAuth();

      _isConnected = true;
      print('✅ Realtime Service: Connected to training $trainingId');
      return true;
    } catch (e) {
      print('❌ Realtime Service: Connection error: $e');
      _handleDisconnection();
      return false;
    }
  }

  /// Send authentication message
  Future<void> _sendAuth() async {
    if (_authToken != null) {
      final authMessage = {
        'type': 'auth',
        'token': _authToken,
      };
      _sendMessage(authMessage);
    }
  }

  /// Handle incoming messages
  void _handleMessage(dynamic message) {
    try {
      Map<String, dynamic> data;
      if (message is String) {
        data = json.decode(message);
      } else if (message is Map<String, dynamic>) {
        data = message;
      } else {
        print('❌ Realtime Service: Invalid message format');
        return;
      }

      print('📨 Realtime Service: Received message: ${data['type']}');
      _messageController?.add(data);
    } catch (e) {
      print('❌ Realtime Service: Message handling error: $e');
    }
  }

  /// Send message to server
  void _sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected) {
      try {
        _channel!.sink.add(json.encode(message));
        print('📤 Realtime Service: Sent message: ${message['type']}');
      } catch (e) {
        print('❌ Realtime Service: Send message error: $e');
      }
    }
  }

  /// Broadcast update to training
  void broadcastUpdate({
    required String type,
    required Map<String, dynamic> data,
  }) {
    final message = {
      'type': 'broadcast',
      'training_id': _currentTrainingId,
      'message_type': type,
      'data': data,
    };
    _sendMessage(message);
  }

  /// Send attendance update
  void sendAttendanceUpdate({
    required String athleteId,
    required String status,
    String? note,
  }) {
    broadcastUpdate(
      type: 'attendance_update',
      data: {
        'athlete_id': athleteId,
        'status': status,
        'note': note,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Send statistics update
  void sendStatisticsUpdate({
    required String athleteId,
    required Map<String, dynamic> statistics,
  }) {
    broadcastUpdate(
      type: 'statistics_update',
      data: {
        'athlete_id': athleteId,
        'statistics': statistics,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Send session status update
  void sendSessionStatusUpdate({
    required String status,
    String? note,
  }) {
    broadcastUpdate(
      type: 'session_status_update',
      data: {
        'status': status,
        'note': note,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Handle disconnection
  void _handleDisconnection() {
    _isConnected = false;
    _currentTrainingId = null;
    
    // Schedule reconnection
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_currentTrainingId != null) {
        print('🔄 Realtime Service: Attempting to reconnect...');
        connectToTraining(_currentTrainingId!);
      }
    });
  }

  /// Disconnect from current channel
  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    
    _isConnected = false;
    _currentTrainingId = null;
    print('🔌 Realtime Service: Disconnected');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController?.close();
    _messageController = null;
  }
} 