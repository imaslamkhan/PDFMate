import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/conversion_type.dart';

class ConversionCard extends StatelessWidget {
  final ConversionType conversionType;
  final VoidCallback onTap;

  const ConversionCard({
    super.key,
    required this.conversionType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: conversionType.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  conversionType.icon,
                  size: 32,
                  color: conversionType.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                conversionType.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${conversionType.supportedFormats.length} formats',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 300.ms,
      curve: Curves.easeOutBack,
    );
  }
}