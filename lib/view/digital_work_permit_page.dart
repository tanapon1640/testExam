import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectofsgn/view/widgets/custom_app_bar.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class DigitalWorkPermitPage extends StatefulWidget {
  const DigitalWorkPermitPage({super.key});

  @override
  State<DigitalWorkPermitPage> createState() => _DigitalWorkPermitPageState();
}

class _DigitalWorkPermitPageState extends State<DigitalWorkPermitPage> {
  String? localPath;
  bool isLoading = true;

  final String pdfUrl =
      'https://www.aeee.in/wp-content/uploads/2020/08/Sample-pdf.pdf';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded.pdf');

        await file.writeAsBytes(bytes);

        debugPrint('PDF downloaded to: ${file.path}');
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        debugPrint(
          'Failed to download PDF. Status code: ${response.statusCode}',
        );
        showError('Failed to download PDF');
      }
    } catch (e) {
      debugPrint('Download error: $e');
      showError('Error downloading PDF: $e');
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) return true;

      if (await Permission.storage.request().isGranted) return true;

      if (await Permission.manageExternalStorage.status.isDenied) {
        final result = await Permission.manageExternalStorage.request();
        return result.isGranted;
      }

      return await Permission.manageExternalStorage.isGranted;
    }
    return true;
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
      localPath = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool isSaving = false;

  Future<void> _downloadAndOpenPdf() async {
    setState(() {
      isSaving = true;
    });

    try {
      final isGranted = await _requestPermission();

      if (!isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        setState(() => isSaving = false);
        return;
      }

      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }

      final bytes = response.bodyBytes;

      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${downloadsDir.path}/downloaded_sample.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF saved: $filePath')));

      await OpenFile.open(filePath);
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Digital Work Permit', notShowAvatar: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  width: 500,
                  height: 500,
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (localPath != null)
                          ? PDFView(
                            filePath: localPath!,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: true,
                            pageFling: true,
                            onError: (error) {
                              debugPrint('PDFView error: $error');
                              showError('Error open PDF');
                            },
                            onPageError: (page, error) {
                              debugPrint('Page error on $page: $error');
                              showError('Page load error');
                            },
                          )
                          : const Center(child: Text('PDF faile to load')),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.blue.shade800,
                    ),
                  ),
                  onPressed: isSaving ? null : _downloadAndOpenPdf,
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text(
                    isSaving ? 'Process' : 'Download & Open PDF',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
