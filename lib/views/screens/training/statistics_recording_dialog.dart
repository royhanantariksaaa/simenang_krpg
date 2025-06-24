import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_dropdown.dart';
import '../../../components/forms/krpg_form_field.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';

class StatisticsRecordingDialog extends StatefulWidget {
  final String sessionId;
  final List<Map<String, dynamic>> athletes;
  final Function()? onStatisticsRecorded;
  final TrainingController trainingController;

  const StatisticsRecordingDialog({
    Key? key,
    required this.sessionId,
    required this.athletes,
    this.onStatisticsRecorded,
    required this.trainingController,
  }) : super(key: key);

  @override
  State<StatisticsRecordingDialog> createState() => _StatisticsRecordingDialogState();
}

class _StatisticsRecordingDialogState extends State<StatisticsRecordingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  final _noteController = TextEditingController();
  
  String? _selectedAthleteId;
  String? _selectedStroke;
  String? _selectedEnergySystem;
  bool _isRecording = false;

  // Stroke options
  final List<Map<String, String>> _strokeOptions = [
    {'value': 'freestyle', 'label': 'Freestyle'},
    {'value': 'backstroke', 'label': 'Backstroke'},
    {'value': 'breaststroke', 'label': 'Breaststroke'},
    {'value': 'butterfly', 'label': 'Butterfly'},
    {'value': 'individual_medley', 'label': 'Individual Medley'},
    {'value': 'mixed', 'label': 'Mixed'},
  ];

  // Energy system options
  final List<Map<String, String>> _energySystemOptions = [
    {'value': 'aerobic', 'label': 'Aerobic'},
    {'value': 'anaerobic_lactic', 'label': 'Anaerobic Lactic'},
    {'value': 'anaerobic_alactic', 'label': 'Anaerobic Alactic'},
    {'value': 'mixed', 'label': 'Mixed'},
  ];

  @override
  void dispose() {
    _distanceController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: KRPGSpacing.paddingMD,
              decoration: BoxDecoration(
                color: KRPGTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Record Statistics',
                      style: KRPGTextStyles.heading5.copyWith(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: KRPGSpacing.paddingMD,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Athlete Selection
                      KRPGDropdown(
                        label: 'Athlete',
                        value: _selectedAthleteId,
                        items: widget.athletes.map((athlete) {
                          return DropdownMenuItem(
                            value: athlete['id_profile'] as String?,
                            child: Text(athlete['name'] as String? ?? 'Unknown Athlete'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAthleteId = value;
                          });
                        },
                        hint: 'Select Athlete',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an athlete';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Stroke Selection
                      KRPGDropdown(
                        label: 'Stroke',
                        value: _selectedStroke,
                        items: _strokeOptions.map((stroke) {
                          return DropdownMenuItem(
                            value: stroke['value'],
                            child: Text(stroke['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStroke = value;
                          });
                        },
                        hint: 'Select Stroke',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a stroke';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Distance and Duration Row
                      Row(
                        children: [
                          Expanded(
                            child: KRPGFormField(
                              label: 'Distance (meters)',
                              controller: _distanceController,
                              keyboardType: TextInputType.number,
                              hint: 'e.g., 100',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Distance is required';
                                }
                                final distance = int.tryParse(value);
                                if (distance == null || distance <= 0) {
                                  return 'Please enter a valid distance';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: KRPGFormField(
                              label: 'Duration (mm:ss)',
                              controller: _durationController,
                              hint: 'e.g., 01:30',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Duration is required';
                                }
                                // Validate mm:ss format
                                if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(value)) {
                                  return 'Use mm:ss format';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Energy System
                      KRPGDropdown(
                        label: 'Energy System',
                        value: _selectedEnergySystem,
                        items: _energySystemOptions.map((system) {
                          return DropdownMenuItem(
                            value: system['value'],
                            child: Text(system['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEnergySystem = value;
                          });
                        },
                        hint: 'Select Energy System',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an energy system';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Notes
                      KRPGFormField(
                        label: 'Notes (Optional)',
                        controller: _noteController,
                        maxLines: 3,
                        hint: 'Additional notes about the performance...',
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: KRPGButton(
                              text: 'Cancel',
                              onPressed: () => Navigator.pop(context),
                              type: KRPGButtonType.outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: KRPGButton(
                              text: _isRecording ? 'Recording...' : 'Record Statistics',
                              onPressed: _isRecording ? null : _recordStatistics,
                              icon: _isRecording ? null : Icons.save,
                              isLoading: _isRecording,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordStatistics() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRecording = true;
      });

      try {
        final success = await widget.trainingController.recordStatistics(
          sessionId: widget.sessionId,
          profileId: _selectedAthleteId!,
          stroke: _selectedStroke!,
          duration: _durationController.text.isNotEmpty ? _durationController.text : null,
          distance: _distanceController.text.isNotEmpty ? int.tryParse(_distanceController.text) : null,
          energySystem: _selectedEnergySystem!,
          note: _noteController.text.isNotEmpty ? _noteController.text : null,
        );

        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Statistics recorded successfully')),
            );
            Navigator.of(context).pop(true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.trainingController.error ?? 'Failed to record statistics')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error recording statistics: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isRecording = false;
          });
        }
      }
    }
  }
} 