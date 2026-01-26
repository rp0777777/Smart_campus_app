import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:translator/translator.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  final translator = GoogleTranslator();
  
  String _translatedText = "";
  String _fromLang = "en";
  String _toLang = "hi";
  bool _isLoading = false;

  final Map<String, String> _languages = {
    "en": "English",
    "hi": "Hindi",
    "es": "Spanish",
    "fr": "French",
    "de": "German",
    "ja": "Japanese",
    "ko": "Korean",
    "zh-cn": "Chinese",
  };

  Future<void> _translate() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _translatedText = "";
    });

    try {
      final translation = await translator.translate(
        _controller.text,
        from: _fromLang,
        to: _toLang,
      );
      
      if (mounted) {
        setState(() {
          _translatedText = translation.text;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = "Translation failed. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _fromLang;
      _fromLang = _toLang;
      _toLang = temp;
      _translatedText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Bridge"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildLanguageDropdown(_fromLang, (val) {
                    setState(() {
                      _fromLang = val!;
                      _translatedText = "";
                    });
                  }),
                ),
                IconButton(
                  onPressed: _swapLanguages,
                  icon: const Icon(LucideIcons.arrow_left_right, color: Colors.blueAccent),
                ),
                Expanded(
                  child: _buildLanguageDropdown(_toLang, (val) {
                    setState(() {
                      _toLang = val!;
                      _translatedText = "";
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Input Text
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter text to translate...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (_) => setState(() => _translatedText = ""),
            ),
            const SizedBox(height: 16),
            
            // Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _translate,
                icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(LucideIcons.languages),
                label: Text(_isLoading ? "Translating..." : "Translate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            // Translated Output
            if (_translatedText.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_languages[_toLang]} Translation:",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.copy, size: 20, color: Colors.blueAccent),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _translatedText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied to clipboard!"))
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _translatedText,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: _languages.entries.map((e) {
          return DropdownMenuItem(
            value: e.key,
            child: Text(e.value, style: GoogleFonts.outfit()),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

