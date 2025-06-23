import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/conversion_type.dart';

class FileDropZone extends StatefulWidget {
  final ConversionType conversionType;
  final Function(List<PlatformFile>) onFilesSelected;

  const FileDropZone({
    super.key,
    required this.conversionType,
    required this.onFilesSelected,
  });

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDragOver
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
        color: _isDragOver
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: InkWell(
        onTap: _pickFiles,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Drop files here or click to select',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: ${widget.conversionType.supportedFormats.map((f) => f.toUpperCase()).join(', ')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.folder_open),
              label: const Text('Select Files'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.conversionType.supportedFormats,
        allowMultiple: widget.conversionType.id == 'merge-pdf' || 
                      widget.conversionType.id == 'image-to-pdf',
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        widget.onFilesSelected(result.files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting files: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}