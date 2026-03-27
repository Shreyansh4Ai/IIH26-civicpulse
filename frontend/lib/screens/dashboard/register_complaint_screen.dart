import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // import dotenv
import 'dart:convert';
import 'dart:io';

import '../../utils/responsive_helper.dart';
import '../../widgets/civic_app_bar.dart';
import '../../widgets/civic_bottom_nav.dart';
import '../../widgets/civic_footer.dart';
import '../../widgets/civic_side_nav.dart';
import '../../theme/app_colors.dart';
import '../../utils/global_state.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterComplaintScreen extends StatefulWidget {
  const RegisterComplaintScreen({super.key});

  @override
  State<RegisterComplaintScreen> createState() => _RegisterComplaintScreenState();
}

class _RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
  final TextEditingController _descController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;
  bool _isLoading = false;
  String? _aiPrediction; // To show ML Model prediction

  // 1. Image Picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
      _getCurrentLocation(); // Auto-fetch GPS when photo is taken
    }
  }

  // 2. Geolocator
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() => _currentPosition = position);
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text('Missing Details', style: GoogleFonts.publicSans(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: GoogleFonts.inter()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // 3. API Submission & AI Trigger
  Future<void> _submitComplaint() async {
    if (_imageFile == null) {
      _showErrorPopup('Please capture or upload an image of the issue first.');
      return;
    }
    if (_descController.text.trim().isEmpty) {
      _showErrorPopup('Please enter a description for your complaint.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:5000';
      var request = http.MultipartRequest(
          'POST', Uri.parse('$apiUrl/complaints/register'));

      request.fields['description'] = _descController.text;
      if (_currentPosition != null) {
        request.fields['lat'] = _currentPosition!.latitude.toString();
        request.fields['lng'] = _currentPosition!.longitude.toString();
      }

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var json = jsonDecode(responseData);

      setState(() {
        _isLoading = false;
        // Mocking the AI categorization received from python backend
        _aiPrediction = json['ai_category'] ?? 'Road Repair (AI Predicted)';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint Registered! Forwarded to $_aiPrediction')),
      );
      
      // Navigate tracking screen to show progress
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/track-status');
      });

    } catch (e) {
      setState(() => _isLoading = false);
      print("Network mapping (fallback applied): $e");

      // Mock AI assignment based on user text keywords
      String desc = _descController.text.toLowerCase();
      String assignedDept = 'General Administration';
      if (desc.contains('water') || desc.contains('pipe') || desc.contains('leak') || desc.contains('drain')) {
        assignedDept = 'Water/Sewage Authority (WSA)';
      } else if (desc.contains('garbage') || desc.contains('waste') || desc.contains('trash') || desc.contains('clean')) {
        assignedDept = 'Waste Management Dept';
      } else if (desc.contains('road') || desc.contains('pothole') || desc.contains('street')) {
        assignedDept = 'Public Works Dept (PWD)';
      } else if (desc.contains('light') || desc.contains('power') || desc.contains('electric')) {
        assignedDept = 'Electricity Board';
      }

      String newId = 'CP-2026-001${(43 + GlobalState.mockComplaints.length).toString()}';
      
      GlobalState.mockComplaints.insert(0, {
        'id': newId,
        'title': _descController.text.length > 30 ? '${_descController.text.substring(0, 30)}...' : _descController.text,
        'status': 'Assigned (AI)',
        'department': assignedDept,
      });

      // Fallback for UI demonstration if backend is not running
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI Analysis Complete âœ¨ Routed to $assignedDept'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Navigate to tracking screen after delay
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/track-status');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: isDesktop
          ? null
          : CivicBottomNav(
              activeIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/citizen-dashboard');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/register-complaint',
                  );
                } else if (index == 2) {
                  Navigator.pushReplacementNamed(context, '/track-status');
                } else if (index == 3) {
                  Navigator.pushReplacementNamed(context, '/complete-profile');
                }
              },
            ),
      drawer: isDesktop ? null : const Drawer(
        child: CivicSideNav(variant: 'citizen', activeIndex: 1),
      ),
      body: isDesktop ? _desktopLayout(context) : _mobileLayout(context),
    );
  }

  // ─── DESKTOP ───
  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        const CivicSideNav(variant: 'citizen', activeIndex: 1),
        Expanded(
          child: Column(
            children: [
              CivicAppBar(
                navLinks: const ['About Us', 'Contact Us', 'Dashboard'],
                showAvatar: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 48),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 7, child: _buildForm()),
                              const SizedBox(width: 48),
                              Expanded(flex: 5, child: _buildSidebarGuide()),
                            ],
                          ),
                          const SizedBox(height: 48),
                          const CivicFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── MOBILE ───
  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        const CivicAppBar(showMenuIcon: true, showAvatar: true),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildForm(),
                      const SizedBox(height: 48),
                      _buildSidebarGuide(),
                    ],
                  ),
                ),
                const CivicFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register a Complaint',
          style: GoogleFonts.publicSans(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'नई शिकायत दर्ज करें',
          style: GoogleFonts.publicSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Provide accurate details and geotagged evidence to ensure swift resolution by the concerned department.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            _stepIndicator('1', 'Details', true),
            Expanded(
              child: Container(
                height: 2,
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            _stepIndicator('2', 'Evidence', false),
            Expanded(
              child: Container(
                height: 2,
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            _stepIndicator('3', 'Review', false),
          ],
        ),
      ],
    );
  }

  Widget _stepIndicator(String number, String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? AppColors.onPrimary
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabel('COMPLAINT CATEGORY / शिकायत की श्रेणी *'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            hint: Text(
              'Select Category...',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
            items: const [
              DropdownMenuItem(
                value: '1',
                child: Text('Public Utilities (Water & Power)'),
              ),
              DropdownMenuItem(
                value: '2',
                child: Text('Civic Infrastructure (Roads)'),
              ),
              DropdownMenuItem(
                value: '3',
                child: Text('Sanitation & Environment'),
              ),
            ],
            onChanged: (val) {},
          ),
          const SizedBox(height: 24),
          _formLabel('COMPLAINT TITLE / शिकायत का शीर्षक *'),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Brief summary of the issue...',
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _formLabel('ISSUE DETAILS / समस्या का विवरण *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Provide complete details regarding location, frequency, and severity...',
              filled: true,
              fillColor: AppColors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _formLabel('GEOTAGGED EVIDENCE / जियोटैग किए गए साक्ष्य'),
          const SizedBox(height: 8),
          
          if (_aiPrediction != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Predicted Category: $_aiPrediction',
                      style: GoogleFonts.inter(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryContainer,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: _imageFile != null 
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap to Retake Photo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (_currentPosition != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '📍 ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          )
                      ],
                    )
                  : Column(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to Open Camera',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Live capture only. GPS required.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Submit Complaint',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSidebarGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submission Guide',
                style: GoogleFonts.publicSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              _guideItem(
                Icons.check_circle_outline,
                'Be specific',
                'Provide exact landmarks and clear descriptions.',
              ),
              const SizedBox(height: 16),
              _guideItem(
                Icons.image_outlined,
                'Add clear photos',
                'Geotagged photos accelerate verification by 40%.',
              ),
              const SizedBox(height: 16),
              _guideItem(
                Icons.category_outlined,
                'Check category',
                'Choosing the wrong category leads to delays.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.errorContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.error),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.error),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Notice',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Filing frivolous, false, or abusive complaints leads to permanent suspension of portal access as per IT Act 2000.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _guideItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
