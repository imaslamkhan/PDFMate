import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../models/conversion_type.dart';
import '../services/pdf_service.dart';
import '../widgets/file_drop_zone.dart';
import '../widgets/conversion_progress.dart';
import '../widgets/result_preview.dart';

class ConverterScreen extends ConsumerStatefulWidget {
  final String converterType;

  const ConverterScreen({
    super.key,
    required this.converterType,
  });

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  ConversionType? conversionType;
  List<PlatformFile> selectedFiles = [];
  bool isConverting = false;
  double conversionProgress = 0.0;
  String? resultFilePath;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    conversionType = ConversionType.allTypes.firstWhere(
      (type) => type.id == widget.converterType,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (conversionType == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid Converter')),
        body: const Center(
          child: Text('Conversion type not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(conversionType!.title),
        actions: [
          if (selectedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFiles,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            if (selectedFiles.isEmpty) ...[
              FileDropZone(
                conversionType: conversionType!,
                onFilesSelected: _handleFilesSelected,
              ),
            ] else ...[
              _buildSelectedFilesCard(),
              const SizedBox(height: 16),
              if (!isConverting) _buildConvertButton(),
            ],
            if (isConverting) ...[
              const SizedBox(height: 24),
              ConversionProgress(progress: conversionProgress),
            ],
            if (resultFilePath != null) ...[
              const SizedBox(height: 24),
              ResultPreview(filePath: resultFilePath!),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  conversionType!.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  conversionType!.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              conversionType!.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: conversionType!.supportedFormats
                  .map((format) => Chip(
                        label: Text(format.toUpperCase()),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFilesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Files (${selectedFiles.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...selectedFiles.map((file) => _buildFileItem(file)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(PlatformFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            _getFileIcon(file.extension ?? ''),
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _formatFileSize(file.size),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _removeFile(file),
          ),
        ],
      ),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton.icon(
      onPressed: _startConversion,
      icon: const Icon(Icons.transform),
      label: const Text('Start Conversion'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFilesSelected(List<PlatformFile> files) {
    setState(() {
      selectedFiles = files;
      errorMessage = null;
      resultFilePath = null;
    });
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      selectedFiles.remove(file);
    });
  }

  void _clearFiles() {
    setState(() {
      selectedFiles.clear();
      errorMessage = null;
      resultFilePath = null;
    });
  }

  Future<void> _startConversion() async {
    if (selectedFiles.isEmpty) return;

    setState(() {
      isConverting = true;
      conversionProgress = 0.0;
      errorMessage = null;
      resultFilePath = null;
    });

    try {
      final pdfService = PDFService();
      String? result;

      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          conversionProgress = i / 100;
        });
      }

      switch (conversionType!.id) {
        case 'image-to-pdf':
          result = await pdfService.convertImagesToPDF(selectedFiles);
          break;
        case 'pdf-to-word':
          result = await pdfService.convertPDFToWord(selectedFiles.first);
          break;
        case 'word-to-pdf':
          result = await pdfService.convertWordToPDF(selectedFiles.first);
          break;
        case 'merge-pdf':
          result = await pdfService.mergePDFs(selectedFiles);
          break;
        case 'split-pdf':
          result = await pdfService.splitPDF(selectedFiles.first);
          break;
        default:
          throw Exception('Unsupported conversion type');
      }

      setState(() {
        isConverting = false;
        resultFilePath = result;
      });
    } catch (e) {
      setState(() {
        isConverting = false;
        errorMessage = 'Conversion failed: ${e.toString()}';
      });
    }
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}