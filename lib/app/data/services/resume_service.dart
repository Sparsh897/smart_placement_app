import 'dart:io';
import 'dart:developer' as developer;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/api_response.dart';
import '../../config/imagekit_config.dart';
import 'api_config.dart';
import 'http_service.dart';

class ResumeService {

  /// Pick a resume file from device
  static Future<File?> pickResumeFile() async {
    try {
      developer.log('Opening file picker for resume', name: 'ResumeService');
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ImageKitConfig.allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;
        
        developer.log('File selected: $fileName (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)', name: 'ResumeService');
        
        // Check file size
        if (fileSize > ImageKitConfig.maxFileSizeBytes) {
          throw Exception('File size must be less than ${ImageKitConfig.maxFileSizeBytes ~/ (1024 * 1024)}MB');
        }
        
        return file;
      } else {
        developer.log('File selection cancelled', name: 'ResumeService');
        return null;
      }
    } catch (e) {
      developer.log('Error picking file: $e', name: 'ResumeService', level: 1000);
      throw Exception('Failed to pick file: $e');
    }
  }

  /// Upload resume to ImageKit
  static Future<String> uploadToImageKit(File file, String fileName) async {
    try {
      developer.log('Uploading to ImageKit: $fileName', name: 'ResumeService');
      developer.log('Using endpoint: https://upload.imagekit.io/api/v1/files/upload', name: 'ResumeService');
      developer.log('Private key configured: ${ImageKitConfig.privateKey.isNotEmpty}', name: 'ResumeService');
      
      // Create multipart request - ImageKit upload endpoint
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
      );

      // Add authentication - ImageKit uses private key as username with empty password
      String basicAuth = 'Basic ${base64Encode(utf8.encode('${ImageKitConfig.privateKey}:'))}';
      request.headers['Authorization'] = basicAuth;
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: fileName,
        ),
      );

      // Add required fields
      request.fields['fileName'] = fileName;
      request.fields['folder'] = ImageKitConfig.resumeFolder;
      request.fields['useUniqueFileName'] = 'true';

      // Send request
      developer.log('Sending request to ImageKit...', name: 'ResumeService');
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      developer.log('Response status: ${response.statusCode}', name: 'ResumeService');
      developer.log('Response headers: ${response.headers}', name: 'ResumeService');
      developer.log('Response body: $responseBody', name: 'ResumeService', level: response.statusCode == 200 ? 800 : 1000);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        String fileUrl = jsonResponse['url'];
        developer.log('Upload successful: $fileUrl', name: 'ResumeService');
        return fileUrl;
      } else {
        developer.log('Upload failed: ${response.statusCode} - $responseBody', name: 'ResumeService', level: 1000);
        
        // Try to parse error message from ImageKit response
        try {
          var errorResponse = json.decode(responseBody);
          String errorMessage = errorResponse['message'] ?? 'Unknown error';
          throw Exception('ImageKit upload failed: $errorMessage');
        } catch (e) {
          throw Exception('Failed to upload to ImageKit: ${response.statusCode} - $responseBody');
        }
      }
    } catch (e) {
      developer.log('Upload error: $e', name: 'ResumeService', level: 1000);
      throw Exception('Failed to upload resume: $e');
    }
  }

  /// Save resume URL to database
  static Future<ApiResponse<Map<String, dynamic>>> saveResumeUrl(String resumeUrl) async {
    try {
      developer.log('Saving resume URL to database: $resumeUrl', name: 'ResumeService');
      
      final response = await HttpService.put<Map<String, dynamic>>(
        '${ApiConfig.users}/profile',
        body: {
          'profile': {
            'resumeUrl': resumeUrl,
          },
        },
        fromJson: (json) => json as Map<String, dynamic>,
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Resume URL saved successfully', name: 'ResumeService');
      } else {
        developer.log('Failed to save resume URL: ${response.error?.message}', name: 'ResumeService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Error saving resume URL: $e', name: 'ResumeService', level: 1000);
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: ApiError(
          code: 'SAVE_ERROR',
          message: 'Failed to save resume URL: $e',
        ),
      );
    }
  }

  /// Complete resume upload process (pick file, upload to ImageKit, save URL)
  static Future<String?> uploadResume() async {
    try {
      // Step 1: Pick file
      File? file = await pickResumeFile();
      if (file == null) {
        return null; // User cancelled
      }

      // Step 2: Upload to ImageKit
      String fileName = file.path.split('/').last;
      String resumeUrl = await uploadToImageKit(file, fileName);

      // Step 3: Save URL to database
      final response = await saveResumeUrl(resumeUrl);
      if (!response.success) {
        throw Exception('Failed to save resume URL to database');
      }

      developer.log('Complete upload process successful: $resumeUrl', name: 'ResumeService');
      return resumeUrl;
    } catch (e) {
      developer.log('Complete upload process failed: $e', name: 'ResumeService', level: 1000);
      rethrow;
    }
  }

  /// Get current resume URL from user profile
  static Future<String?> getCurrentResumeUrl() async {
    try {
      developer.log('Fetching current resume URL', name: 'ResumeService');
      
      final response = await HttpService.get<Map<String, dynamic>>(
        '${ApiConfig.users}/profile',
        fromJson: (json) => json as Map<String, dynamic>,
        requiresAuth: true,
      );

      if (response.success && response.data != null) {
        // Extract resumeUrl from nested user.profile structure
        String? resumeUrl = response.data!['user']?['profile']?['resumeUrl'];
        developer.log('Current resume URL: $resumeUrl', name: 'ResumeService');
        return resumeUrl;
      } else {
        developer.log('Failed to fetch resume URL: ${response.error?.message}', name: 'ResumeService', level: 1000);
        return null;
      }
    } catch (e) {
      developer.log('Error fetching resume URL: $e', name: 'ResumeService', level: 1000);
      return null;
    }
  }

  /// Delete resume (remove URL from database)
  static Future<ApiResponse<Map<String, dynamic>>> deleteResume() async {
    try {
      developer.log('Deleting resume URL from database', name: 'ResumeService');
      
      final response = await HttpService.put<Map<String, dynamic>>(
        '${ApiConfig.users}/profile',
        body: {
          'profile': {
            'resumeUrl': null, // Set to null to remove
          },
        },
        fromJson: (json) => json as Map<String, dynamic>,
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Resume URL deleted successfully', name: 'ResumeService');
      } else {
        developer.log('Failed to delete resume URL: ${response.error?.message}', name: 'ResumeService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Error deleting resume URL: $e', name: 'ResumeService', level: 1000);
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        error: ApiError(
          code: 'DELETE_ERROR',
          message: 'Failed to delete resume URL: $e',
        ),
      );
    }
  }
}