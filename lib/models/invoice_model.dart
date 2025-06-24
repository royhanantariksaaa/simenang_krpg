import 'package:flutter/material.dart';
import '../../design_system/krpg_theme.dart';

class Invoice {
  final String id;
  final String payerId;
  final String? validatorId;
  final double amount;
  final InvoiceStatus status;
  final InvoiceCategory category;
  final PaymentMethod? paymentMethod;
  final String? note;
  final String? paymentProofUrl;
  final DateTime createdDate;
  final DateTime? updatedDate;

  // Optional hydrated fields
  final String? payerName;
  final String? validatorName;
  final String? classroomName;

  Invoice({
    required this.id,
    required this.payerId,
    this.validatorId,
    required this.amount,
    required this.status,
    required this.category,
    this.paymentMethod,
    this.note,
    this.paymentProofUrl,
    required this.createdDate,
    this.updatedDate,
    this.payerName,
    this.validatorName,
    this.classroomName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id_invoice']?.toString() ?? '',
      payerId: json['id_payer']?.toString() ?? '',
      validatorId: json['id_validator']?.toString(),
      amount: double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0,
      status: InvoiceStatus.fromString(json['payment_status']?.toString() ?? '1'),
      category: InvoiceCategory.fromString(json['payment_category']?.toString() ?? '0'),
      paymentMethod: json['payment_method'] != null 
          ? PaymentMethod.fromString(json['payment_method']) 
          : null,
      note: json['note'],
      paymentProofUrl: json['payment_proof'],
      createdDate: DateTime.parse(json['create_date'] ?? DateTime.now().toIso8601String()),
      updatedDate: json['update_date'] != null ? DateTime.parse(json['update_date']) : null,
      
      // Hydrated fields
      payerName: json['payer_name'],
      validatorName: json['validator_name'],
      classroomName: json['classroom_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_invoice': id,
      'id_payer': payerId,
      'id_validator': validatorId,
      'amount': amount.toString(),
      'payment_status': status.apiValue,
      'payment_category': category.apiValue,
      'payment_method': paymentMethod?.apiValue,
      'note': note,
      'payment_proof': paymentProofUrl,
      'create_date': createdDate.toIso8601String(),
      'update_date': updatedDate?.toIso8601String(),
    };
  }
}

enum InvoiceStatus {
  pending,
  approved,
  rejected;

  static InvoiceStatus fromString(String value) {
    switch (value) {
      case '1': return InvoiceStatus.pending;
      case '2': return InvoiceStatus.approved;
      case '3': return InvoiceStatus.rejected;
      default: return InvoiceStatus.pending;
    }
  }

  String get apiValue {
    switch (this) {
      case InvoiceStatus.pending: return '1';
      case InvoiceStatus.approved: return '2';
      case InvoiceStatus.rejected: return '3';
    }
  }

  String get displayName {
    switch (this) {
      case InvoiceStatus.pending: return 'Pending';
      case InvoiceStatus.approved: return 'Approved';
      case InvoiceStatus.rejected: return 'Rejected';
    }
  }

  Color get displayColor {
    switch (this) {
      case InvoiceStatus.pending: return KRPGTheme.warningColor;
      case InvoiceStatus.approved: return KRPGTheme.successColor;
      case InvoiceStatus.rejected: return KRPGTheme.dangerColor;
    }
  }

  IconData get displayIcon {
    switch (this) {
      case InvoiceStatus.pending: return Icons.hourglass_empty_rounded;
      case InvoiceStatus.approved: return Icons.check_circle_rounded;
      case InvoiceStatus.rejected: return Icons.cancel_rounded;
    }
  }
}

enum InvoiceCategory {
  monthlyFee,
  registrationFee,
  competitionFee,
  other;

  static InvoiceCategory fromString(String value) {
    switch (value) {
      case '1': return InvoiceCategory.monthlyFee;
      case '2': return InvoiceCategory.registrationFee;
      case '3': return InvoiceCategory.competitionFee;
      default: return InvoiceCategory.other;
    }
  }

  String get apiValue {
    switch (this) {
      case InvoiceCategory.monthlyFee: return '1';
      case InvoiceCategory.registrationFee: return '2';
      case InvoiceCategory.competitionFee: return '3';
      case InvoiceCategory.other: return '0';
    }
  }

  String get displayName {
    switch (this) {
      case InvoiceCategory.monthlyFee: return 'Monthly Fee';
      case InvoiceCategory.registrationFee: return 'Registration Fee';
      case InvoiceCategory.competitionFee: return 'Competition Fee';
      case InvoiceCategory.other: return 'Other';
    }
  }
}

enum PaymentMethod {
  transfer,
  cash;

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'transfer': return PaymentMethod.transfer;
      case 'cash': return PaymentMethod.cash;
      default: return PaymentMethod.transfer;
    }
  }

  String get apiValue {
    return toString().split('.').last;
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.transfer: return 'Bank Transfer';
      case PaymentMethod.cash: return 'Cash';
    }
  }
} 