import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;

class PDFService {
  Future<String> convertImagesToPDF(List<PlatformFile> imageFiles) async {
    final pdf = pw.Document();
    
    for (final file in imageFiles) {
      if (file.bytes != null) {
        final image = img.decodeImage(file.bytes!);
        if (image != null) {
          final pdfImage = pw.MemoryImage(file.bytes!);
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
                );
              },
            ),
          );
        }
      }
    }
//}}}
    final output = await getApplicationDocumentsDirectory();
    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }

  Future<String> convertPDFToWord(PlatformFile pdfFile) async {
    // This is a simplified implementation
    // In a real app, you would use a more sophisticated PDF parsing library
    if (pdfFile.bytes == null) {
      throw Exception('File bytes are null');
    }

    final document = sf_pdf.PdfDocument(inputBytes: pdfFile.bytes!);
    final textExtractor = sf_pdf.PdfTextExtractor(document);
    final extractedText = textExtractor.extractText();
    
    document.dispose();

    final output = await getApplicationDocumentsDirectory();
    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.txt';
    final file = File('${output.path}/$fileName');
    await file.writeAsString(extractedText);
    
    return file.path;
  }

  Future<String> convertWordToPDF(PlatformFile wordFile) async {
    // This is a placeholder implementation
    // In a real app, you would need a library to parse Word documents
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Word to PDF conversion\nOriginal file: ${wordFile.name}',
              style: const pw.TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final fileName = 'converted_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }

  Future<String> mergePDFs(List<PlatformFile> pdfFiles) async {
    final mergedDocument = sf_pdf.PdfDocument();
    
    for (final file in pdfFiles) {
      if (file.bytes != null) {
        final sourceDoc = sf_pdf.PdfDocument(inputBytes: file.bytes!);
        mergedDocument.importPages(sourceDoc, 0, sourceDoc.pages.count - 1);
        sourceDoc.dispose();
      }
    }

    final bytes = await mergedDocument.save();
    mergedDocument.dispose();

    final output = await getApplicationDocumentsDirectory();
    final fileName = 'merged_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(bytes);
    
    return file.path;
  }

  Future<String> splitPDF(PlatformFile pdfFile) async {
    if (pdfFile.bytes == null) {
      throw Exception('File bytes are null');
    }

    final sourceDoc = sf_pdf.PdfDocument(inputBytes: pdfFile.bytes!);
    final output = await getApplicationDocumentsDirectory();
    final folderName = 'split_${DateTime.now().millisecondsSinceEpoch}';
    final folder = Directory('${output.path}/$folderName');
    await folder.create();

    for (int i = 0; i < sourceDoc.pages.count; i++) {
      final newDoc = sf_pdf.PdfDocument();
      newDoc.importPages(sourceDoc, i, i);
      
      final bytes = await newDoc.save();
      newDoc.dispose();
      
      final fileName = 'page_${i + 1}.pdf';
      final file = File('${folder.path}/$fileName');
      await file.writeAsBytes(bytes);
    }

    sourceDoc.dispose();
    return folder.path;
  }

  Future<List<String>> convertPDFToImages(PlatformFile pdfFile) async {
    // This would require a more advanced PDF rendering library
    // For now, we'll create placeholder images
    final output = await getApplicationDocumentsDirectory();
    final folderName = 'pdf_images_${DateTime.now().millisecondsSinceEpoch}';
    final folder = Directory('${output.path}/$folderName');
    await folder.create();

    final imagePaths = <String>[];
    
    // Placeholder implementation - would need proper PDF to image conversion
    for (int i = 0; i < 3; i++) {
      final fileName = 'page_${i + 1}.png';
      final file = File('${folder.path}/$fileName');
      
      // Create a simple placeholder image
      final image = img.Image(width: 595, height: 842);
      img.fill(image, color: img.ColorRgb8(255, 255, 255));
      img.drawString(image, 'Page ${i + 1}', 
          font: img.arial48, x: 100, y: 100, color: img.ColorRgb8(0, 0, 0));
      
      await file.writeAsBytes(img.encodePng(image));
      imagePaths.add(file.path);
    }

    return imagePaths;
  }
}
