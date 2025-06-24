import 'package:flutter/material.dart';
import '../../models/invoice_model.dart';
import '../ui/krpg_badge.dart';
import 'krpg_card.dart';
import '../../design_system/krpg_design_system.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onTap;
  final bool isSelected;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return KRPGCard.list(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          KRPGSpacing.verticalSM,
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          KRPGIcons.invoice, // Assuming you add an 'invoice' icon
          color: KRPGTheme.primaryColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invoice.category.displayName,
                style: KRPGTextStyles.cardTitle,
              ),
              Text(
                'ID: ${invoice.id}',
                style: KRPGTextStyles.bodySmallSecondary,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return KRPGBadge(
      text: invoice.status.displayName,
      backgroundColor: invoice.status.displayColor.withOpacity(0.1),
      textColor: invoice.status.displayColor,
      fontSize: KRPGTheme.fontSizeXs,
    );
  }

  Widget _buildDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailItem(
          label: 'Amount',
          value: 'Rp ${invoice.amount.toStringAsFixed(0)}',
        ),
        _buildDetailItem(
          label: 'Payer',
          value: invoice.payerName ?? '-',
          alignment: CrossAxisAlignment.center,
        ),
        _buildDetailItem(
          label: 'Date',
          value:
              '${invoice.createdDate.day}/${invoice.createdDate.month}/${invoice.createdDate.year}',
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    CrossAxisAlignment? alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: KRPGTextStyles.caption,
        ),
        Text(
          value,
          style: KRPGTextStyles.bodyMedium,
        ),
      ],
    );
  }
} 