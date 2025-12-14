# GradConnect - Graduate Job Placement Platform

<div align="center">

![GradConnect Logo](assets/logo_concept.svg)

**Connecting Graduates with Career Opportunities**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [API Integration](#api-integration)
- [Database Schema](#database-schema)
- [Testing](#testing)
- [Deployment](#deployment)
- [Future Enhancements](#future-enhancements)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

---

## 🎯 About the Project

**GradConnect** is a comprehensive mobile application designed to bridge the gap between fresh graduates and employment opportunities. The platform streamlines the job search and application process by providing personalized job recommendations based on educational background, enabling seamless application submissions, and offering a modern, intuitive user experience.

### Problem Statement

Fresh graduates face several challenges in their job search:
- Overwhelming number of job postings across multiple platforms
- Difficulty finding jobs relevant to their educational background
- Complex and time-consuming application processes
- Lack of centralized platform for tracking applications
- Limited guidance on resume preparation and job requirements

### Solution

GradConnect addresses these challenges by:
- **Personalized Job Matching**: Filters jobs based on education level, course, and specialization
- **Streamlined Applications**: 4-step application process with resume validation
- **Centralized Dashboard**: Track all applications in one place
- **Modern UX**: Intuitive interface with smooth animations and responsive design
- **Resume Management**: Cloud-based resume storage and management
- **Google Sign-In**: Quick and secure authentication

---

## ✨ Features

### 1. Authentication & User Management
- **Email/Password Authentication**: Secure user registration and login
- **Google Sign-In Integration**: One-tap authentication with Google accounts
- **Profile Management**: Update personal information, contact details, and profile picture
- **Persistent Sessions**: Stay logged in across app restarts
- **Secure Token Management**: JWT-based authentication with automatic token refresh

### 2. Personalized Onboarding
- **Welcome Screens**: Engaging 3-slide introduction (shown once)
- **Educational Preferences**: Select education level, course, and specialization
- **Smart Skip Logic**: Returning users bypass onboarding if preferences exist
- **Progressive Disclosure**: Step-by-step preference selection with validation

### 3. Job Discovery & Search
- **Personalized Feed**: Jobs matched to educational background
- **Domain Filtering**: Filter by technology domains (Web Dev, Mobile, AI/ML, etc.)
- **Search Functionality**: Find jobs by title, company, or keywords
- **Modern Job Cards**: Display salary, location, job type, and applicant count
- **Detailed Job View**: Complete job descriptions, requirements, and company info

### 4. Job Application System
- **4-Step Application Process**:
  1. **Resume Selection**: Validate and select resume
  2. **Employer Questions**: Answer job-specific screening questions
  3. **Contact Information**: Review and edit contact details
  4. **Application Review**: Final review before submission
- **Inline Editing**: Update contact info without leaving application flow
- **Real-time Validation**: Ensure all required fields are completed
- **Application Tracking**: View all submitted applications

### 5. Profile & Resume Management
- **Personal Information**: Name, email, phone, profile picture
- **Educational Preferences**: View and edit education details
- **Resume Upload**: Cloud-based storage with ImageKit integration
- **Resume Management**: View, replace, or delete resume
- **Data Synchronization**: Real-time sync across all app sections

### 6. User Experience
- **Bottom Navigation**: Easy access to Home, Applied Jobs, and Profile
- **Smooth Animations**: Fade-ins, slide transitions, and loading states
- **Modern UI Design**: Gradient backgrounds, shadows, and rounded corners
- **Responsive Layout**: Adapts to different screen sizes
- **Error Handling**: User-friendly error messages and retry mechanisms
- **Loading States**: Clear feedback during API calls and data loading

---

## 🛠 Technology Stack

### Frontend (Mobile App)

#### Framework & Language
- **Flutter 3.16+**: Cross-platform mobile development framework
- **Dart 3.2+**: Programming language optimized for UI development

#### State Management & Navigation
- **GetX 4.6+**: Reactive state management, dependency injection, and routing
  - Reactive programming with Rx
  - Dependency injection for controllers
  - Named route navigation
  - Snackbar and dialog management

#### UI & Design
- **Material Design 3**: Modern design system
- **Google Fonts (Noto Sans)**: Typography inspired by Indeed
- **Custom Animations**: TweenAnimationBuilder, AnimatedContainer
- **Responsive Design**: MediaQuery-based layouts

#### Storage & Persistence
- **SharedPreferences**: Token storage and simple key-value pairs
- **GetStorage**: Fast, lightweight local storage for user preferences
- **Secure Storage**: Encrypted token management

#### Authentication & Backend Integration
- **Firebase Authentication**: Email/Password and Google Sign-In
- **Google Sign-In**: OAuth 2.0 integration
- **JWT Tokens**: Secure API authentication
- **HTTP Client**: RESTful API communication

#### File Management
- **ImageKit**: Cloud-based resume storage and CDN
- **File Picker**: Local file selection for resume upload
- **Image Picker**: Profile picture selection

#### Additional Packages
```yaml
dependencies:
  flutter: sdk: flutter
  get: ^4.6.6                    # State management & routing
  http: ^1.1.0                   # API calls
  shared_preferences: ^2.2.2     # Token storage
  get_storage: ^2.1.1            # Local storage
  google_sign_in: ^6.1.6         # Google authentication
  firebase_core: ^2.24.2         # Firebase initialization
  firebase_auth: ^4.15.3         # Firebase authentication
  google_fonts: ^6.1.0           # Typography
  file_picker: ^6.1.1            # File selection
  image_picker: ^1.0.5           # Image selection
```

### Backend (API Server)

#### Technology Stack
- **Node.js**: JavaScript runtime
- **Express.js**: Web application framework
- **MongoDB**: NoSQL database
- **Mongoose**: MongoDB object modeling
- **JWT**: JSON Web Tokens for authentication
- **Bcrypt**: Password hashing
- **Multer**: File upload handling

#### Hosting & Deployment
- **Render.com**: Backend API hosting (free tier)
- **MongoDB Atlas**: Cloud database hosting
- **ImageKit**: CDN and file storage

#### API Endpoints
```
Authentication:
POST   /api/auth/register          - User registration
POST   /api/auth/login             - User login
POST   /api/auth/google            - Google Sign-In
GET    /api/auth/me                - Get current user

User Profile:
GET    /api/users/profile          - Get user profile
PUT    /api/users/profile          - Update profile
POST   /api/users/resume           - Upload resume
DELETE /api/users/resume           - Delete resume

Jobs:
GET    /api/jobs                   - Get jobs (with filters)
GET    /api/jobs/:id               - Get job details
POST   /api/jobs/:id/apply         - Apply to job
GET    /api/jobs/applied           - Get applied jobs

Education:
GET    /api/education/levels       - Get education levels
GET    /api/education/courses      - Get courses
GET    /api/education/specializations - Get specializations
```

---

## 🏗 Architecture

### Design Pattern: MVC + Repository Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                         Presentation Layer                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Views   │  │  Widgets │  │ Dialogs  │  │  Screens │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │             │              │             │          │
└───────┼─────────────┼──────────────┼─────────────┼──────────┘
        │             │              │             │
┌───────┼─────────────┼──────────────┼─────────────┼──────────┐
│       │             │              │             │          │
│  ┌────▼─────────────▼──────────────▼─────────────▼─────┐   │
│  │              Controllers (GetX)                      │   │
│  │  - AuthController                                    │   │
│  │  - UserController                                    │   │
│  │  - PlacementController                               │   │
│  │  - JobApplicationController                          │   │
│  └────┬─────────────────────────────────────────────────┘   │
│       │                Business Logic Layer                 │
└───────┼─────────────────────────────────────────────────────┘
        │
┌───────┼─────────────────────────────────────────────────────┐
│       │                                                      │
│  ┌────▼─────────────────────────────────────────────────┐   │
│  │              Services (Repository)                   │   │
│  │  - AuthService                                       │   │
│  │  - UserService                                       │   │
│  │  - JobService                                        │   │
│  │  - ResumeService                                     │   │
│  └────┬─────────────────────────────────────────────────┘   │
│       │                Data Layer                            │
└───────┼─────────────────────────────────────────────────────┘
        │
┌───────┼─────────────────────────────────────────────────────┐
│       │                                                      │
│  ┌────▼─────────────────────────────────────────────────┐   │
│  │              Data Sources                            │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐          │   │
│  │  │   API    │  │  Local   │  │ Firebase │          │   │
│  │  │  (HTTP)  │  │ Storage  │  │   Auth   │          │   │
│  │  └──────────┘  └──────────┘  └──────────┘          │   │
│  └──────────────────────────────────────────────────────┘   │
│                    Infrastructure Layer                      │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **GetX for State Management**: Chosen for its simplicity, performance, and built-in routing
2. **Repository Pattern**: Separates data access logic from business logic
3. **Dependency Injection**: Controllers and services are injected via GetX bindings
4. **Reactive Programming**: Rx observables for automatic UI updates
5. **Modular Structure**: Feature-based folder organization

---

## 📱 Screenshots

### Authentication Flow
| Welcome Screen | Login Screen | Google Sign-In |
|:---:|:---:|:---:|
| ![Welcome](docs/screenshots/welcome.png) | ![Login](docs/screenshots/login.png) | ![Google](docs/screenshots/google.png) |

### Onboarding & Home
| Onboarding | Home Screen | Job Details |
|:---:|:---:|:---:|
| ![Onboarding](docs/screenshots/onboarding.png) | ![Home](docs/screenshots/home.png) | ![Details](docs/screenshots/job_details.png) |

### Application & Profile
| Job Application | Applied Jobs | Profile |
|:---:|:---:|:---:|
| ![Application](docs/screenshots/application.png) | ![Applied](docs/screenshots/applied.png) | ![Profile](docs/screenshots/profile.png) |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.16.0 or higher
- **Dart SDK**: 3.2.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development, macOS only)
- **Git**: For version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/gradconnect.git
   cd gradconnect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Set up configuration files**
   ```bash
   # Copy template files
   cp lib/firebase_options.dart.example lib/firebase_options.dart
   cp lib/app/config/imagekit_config.dart.example lib/app/config/imagekit_config.dart
   
   # Edit with your credentials
   # See CONFIGURATION.md for detailed instructions
   ```

5. **Update API endpoint**
   ```dart
   // lib/app/data/services/api_config.dart
   static const String baseUrl = 'YOUR_BACKEND_URL';
   ```

6. **Run the app**
   ```bash
   # Check for issues
   flutter doctor
   
   # Run on connected device/emulator
   flutter run
   
   # Run in release mode
   flutter run --release
   ```

### Configuration

See [CONFIGURATION.md](CONFIGURATION.md) for detailed setup instructions including:
- Firebase setup
- ImageKit configuration
- Google Sign-In setup
- Backend API configuration

---

## 📁 Project Structure

```
gradconnect/
├── android/                    # Android native code
├── ios/                        # iOS native code
├── lib/
│   ├── app/
│   │   ├── core/
│   │   │   └── theme/         # App theme and text styles
│   │   ├── data/
│   │   │   ├── models/        # Data models (User, Job, etc.)
│   │   │   └── services/      # API services and repositories
│   │   ├── modules/           # Feature modules
│   │   │   ├── auth/          # Authentication
│   │   │   │   ├── controllers/
│   │   │   │   ├── bindings/
│   │   │   │   └── views/
│   │   │   ├── home/          # Home screen
│   │   │   ├── onboarding/    # Onboarding flow
│   │   │   ├── placement/     # Job listings
│   │   │   ├── job_application/ # Application flow
│   │   │   ├── applied_jobs/  # Applied jobs tracking
│   │   │   ├── user/          # User profile
│   │   │   └── welcome/       # Welcome screens
│   │   ├── routes/            # App routing
│   │   └── config/            # Configuration files
│   ├── firebase_options.dart  # Firebase configuration
│   └── main.dart              # App entry point
├── assets/                    # Images, fonts, etc.
├── docs/                      # Documentation
│   ├── screenshots/           # App screenshots
│   └── diagrams/              # Architecture diagrams
├── test/                      # Unit and widget tests
├── pubspec.yaml              # Dependencies
└── README.md                 # This file
```

### Module Structure (Example: Auth Module)

```
auth/
├── controllers/
│   └── auth_controller.dart       # Business logic
├── bindings/
│   └── auth_binding.dart          # Dependency injection
└── views/
    ├── auth_view.dart             # Login/Signup screen
    └── profile_view.dart          # Profile screen
```

---

## 🔌 API Integration

### Authentication Flow

```dart
// 1. User logs in
final response = await AuthService.login(
  email: email,
  password: password,
);

// 2. Store tokens
await TokenManager.saveTokens(
  accessToken: response.accessToken,
  refreshToken: response.refreshToken,
);

// 3. Update user state
authController.currentUser.value = response.user;
authController.isLoggedIn.value = true;

// 4. Navigate to home
Get.offAllNamed('/main');
```

### API Request Example

```dart
// Service layer
class JobService {
  static Future<ApiResponse<List<Job>>> getJobs({
    String? educationLevel,
    String? course,
    String? specialization,
  }) async {
    try {
      final response = await HttpService.get(
        '/api/jobs',
        queryParameters: {
          'educationLevel': educationLevel,
          'course': course,
          'specialization': specialization,
        },
      );
      
      final jobs = (response['jobs'] as List)
          .map((json) => Job.fromJson(json))
          .toList();
          
      return ApiResponse.success(jobs);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
```

### Error Handling

```dart
// Centralized error handling
class HttpService {
  static void handleApiError(ApiError error) {
    switch (error.statusCode) {
      case 401:
        // Unauthorized - redirect to login
        Get.offAllNamed('/auth');
        break;
      case 404:
        Get.snackbar('Not Found', error.message);
        break;
      case 500:
        Get.snackbar('Server Error', 'Please try again later');
        break;
      default:
        Get.snackbar('Error', error.message);
    }
  }
}
```

---

## 🗄 Database Schema

### User Collection
```javascript
{
  _id: ObjectId,
  name: String,
  email: String (unique),
  password: String (hashed),
  phone: String,
  photoUrl: String,
  profile: {
    educationLevel: String,
    course: String,
    specialization: String,
    resumeUrl: String,
    visibility: Boolean
  },
  location: {
    city: String,
    state: String,
    country: String
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Job Collection
```javascript
{
  _id: ObjectId,
  title: String,
  company: String,
  description: String,
  requirements: [String],
  salary: {
    min: Number,
    max: Number,
    currency: String
  },
  location: {
    city: String,
    state: String,
    remote: Boolean
  },
  jobType: String,
  domain: String,
  educationLevel: String,
  course: String,
  specialization: String,
  applicantCount: Number,
  postedDate: Date,
  deadline: Date,
  status: String
}
```

### Application Collection
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  jobId: ObjectId (ref: Job),
  resume: {
    fileName: String,
    fileUrl: String
  },
  coverLetter: String,
  answers: {
    question_1: String,
    question_2: Number,
    question_3: Number,
    question_4: String
  },
  status: String,
  appliedAt: Date,
  updatedAt: Date
}
```

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth_controller_test.dart

# Run integration tests
flutter test integration_test/
```

### Test Structure

```
test/
├── unit/
│   ├── controllers/
│   │   ├── auth_controller_test.dart
│   │   └── user_controller_test.dart
│   ├── services/
│   │   ├── auth_service_test.dart
│   │   └── job_service_test.dart
│   └── models/
│       ├── user_model_test.dart
│       └── job_model_test.dart
├── widget/
│   ├── auth_view_test.dart
│   └── home_view_test.dart
└── integration/
    └── app_test.dart
```

### Example Test

```dart
void main() {
  group('AuthController Tests', () {
    late AuthController authController;
    
    setUp(() {
      authController = AuthController();
    });
    
    test('Login with valid credentials', () async {
      final result = await authController.login(
        'test@example.com',
        'password123',
      );
      
      expect(result, true);
      expect(authController.isLoggedIn.value, true);
      expect(authController.currentUser.value, isNotNull);
    });
    
    test('Login with invalid credentials', () async {
      final result = await authController.login(
        'test@example.com',
        'wrongpassword',
      );
      
      expect(result, false);
      expect(authController.isLoggedIn.value, false);
    });
  });
}
```

---

## 🚢 Deployment

### Android APK Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA Build

```bash
# Build iOS app
flutter build ios --release

# Archive in Xcode
# Product > Archive > Distribute App
```

### Backend Deployment

1. **Deploy to Render.com**
   - Connect GitHub repository
   - Set environment variables
   - Deploy automatically on push

2. **MongoDB Atlas**
   - Create cluster
   - Configure network access
   - Get connection string

3. **ImageKit Setup**
   - Create account
   - Get API keys
   - Configure CORS

---

## 🔮 Future Enhancements

### Phase 1: Core Improvements
- [ ] Job bookmarking/favorites
- [ ] Advanced search filters
- [ ] Salary insights and analytics
- [ ] Company reviews and ratings
- [ ] Interview preparation resources

### Phase 2: Communication
- [ ] In-app messaging with employers
- [ ] Push notifications for new jobs
- [ ] Email notifications for application status
- [ ] Interview scheduling
- [ ] Video interview integration

### Phase 3: Advanced Features
- [ ] AI-powered job recommendations
- [ ] Resume builder and analyzer
- [ ] Skill assessment tests
- [ ] Career path suggestions
- [ ] Referral system
- [ ] Job alerts based on preferences

### Phase 4: Platform Expansion
- [ ] Web application
- [ ] Employer portal
- [ ] Admin dashboard
- [ ] Analytics and reporting
- [ ] Multi-language support
- [ ] Dark mode

---

## 👥 Contributors

### Development Team

**[Your Name]**
- Role: Full Stack Developer
- Email: your.email@example.com
- GitHub: [@yourusername](https://github.com/yourusername)

**[Team Member 2]** (if applicable)
- Role: Backend Developer
- Email: email@example.com

**[Team Member 3]** (if applicable)
- Role: UI/UX Designer
- Email: email@example.com

### Project Guide

**[Professor Name]**
- Department: Computer Science
- Institution: [Your College Name]
- Email: professor@college.edu

---

## 🙏 Acknowledgments

### Technologies & Libraries
- [Flutter](https://flutter.dev) - UI framework
- [GetX](https://pub.dev/packages/get) - State management
- [Firebase](https://firebase.google.com) - Authentication
- [ImageKit](https://imagekit.io) - File storage
- [MongoDB](https://www.mongodb.com) - Database
- [Render](https://render.com) - Backend hosting

### Design Inspiration
- [Indeed](https://www.indeed.com) - Job platform UX
- [LinkedIn](https://www.linkedin.com) - Professional networking
- [Material Design 3](https://m3.material.io) - Design system

### Learning Resources
- [Flutter Documentation](https://docs.flutter.dev)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Firebase Documentation](https://firebase.google.com/docs)
- [MongoDB University](https://university.mongodb.com)

### Special Thanks
- Our project guide for valuable feedback and guidance
- College faculty for providing resources and support
- Open source community for amazing tools and libraries
- Beta testers for their feedback and suggestions

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact & Support

### Project Repository
- **GitHub**: [https://github.com/yourusername/gradconnect](https://github.com/yourusername/gradconnect)
- **Issues**: [Report bugs or request features](https://github.com/yourusername/gradconnect/issues)

### Documentation
- **Setup Guide**: [CONFIGURATION.md](CONFIGURATION.md)
- **API Documentation**: [BACKEND_API_SPECIFICATION.md](BACKEND_API_SPECIFICATION.md)
- **Branding Guide**: [GRADCONNECT_BRANDING.md](GRADCONNECT_BRANDING.md)

### Contact
- **Email**: gradconnect.support@example.com
- **Website**: [www.gradconnect.app](https://www.gradconnect.app)

---

## 📊 Project Statistics

- **Lines of Code**: ~10,000+
- **Development Time**: 3 months
- **Screens**: 15+
- **API Endpoints**: 20+
- **Features**: 25+
- **Dependencies**: 15+

---


