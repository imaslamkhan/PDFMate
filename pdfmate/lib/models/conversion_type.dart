import 'package:flutter/material.dart';

class ConversionType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> supportedFormats;
  final Color color;

  const ConversionType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.supportedFormats,
    required this.color,
  });

  static const List<ConversionType> allTypes = [
    ConversionType(
      id: 'image-to-pdf',
      title: 'Image to PDF',
      description: 'Convert images (JPG, PNG, GIF) to PDF documents',
      icon: Icons.image_outlined,
      supportedFormats: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
      color: Color(0xFF4CAF50),
    ),
    ConversionType(
      id: 'pdf-to-word',
      title: 'PDF to Word',
      description: 'Convert PDF documents to editable Word files',
      icon: Icons.description_outlined,
      supportedFormats: ['pdf'],
      color: Color(0xFF2196F3),
    ),
    ConversionType(
      id: 'word-to-pdf',
      title: 'Word to PDF',
      description: 'Convert Word documents to PDF format',
      icon: Icons.picture_as_pdf_outlined,
      supportedFormats: ['doc', 'docx'],
      color: Color(0xFFFF5722),
    ),
    ConversionType(
      id: 'merge-pdf',
      title: 'Merge PDFs',
      description: 'Combine multiple PDF files into one document',
      icon: Icons.merge_outlined,
      supportedFormats: ['pdf'],
      color: Color(0xFF9C27B0),
    ),
    ConversionType(
      id: 'split-pdf',
      title: 'Split PDF',
      description: 'Split a PDF document into separate pages',
      icon: Icons.call_split_outlined,
      supportedFormats: ['pdf'],
      color: Color(0xFFFF9800),
    ),
    ConversionType(
      id: 'pdf-to-images',
      title: 'PDF to Images',
      description: 'Extract pages from PDF as image files',
      icon: Icons.collections_outlined,
      supportedFormats: ['pdf'],
      color: Color(0xFF00BCD4),
    ),
  ];
}