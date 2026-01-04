# Company API Documentation

This document provides comprehensive documentation for the Company API endpoints in the Smart Placement System.

## Base URL
```
https://smart-placement-backend.onrender.com/api/companies
```

## Authentication
All protected endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <company_jwt_token>
```

---

## 1. Company Registration

### POST /api/companies/register

Register a new company account.

**Request Body:**
```json
{
  "name": "Tech Labs",
  "email": "hr@techlabs.com",
  "password": "SecurePass123",
  "description": "Leading technology company specializing in AI and ML solutions",
  "website": "https://techlabs.com",
  "industry": "Information Technology"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "company": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b3",
      "name": "Tech Labs",
      "email": "hr@techlabs.com",
      "description": "Leading technology company specializing in AI and ML solutions",
      "website": "https://techlabs.com",
      "industry": "Information Technology",
      "isVerified": false,
      "isActive": true,
      "totalJobsPosted": 0,
      "activeJobs": 0,
      "createdAt": "2024-12-11T10:30:00.000Z",
      "updatedAt": "2024-12-11T10:30:00.000Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "tokenType": "Bearer",
      "expiresIn": "7d"
    }
  },
  "message": "Company registered successfully"
}
```

**cURL Example:**
```bash
curl -X POST "https://smart-placement-backend.onrender.com/api/companies/register" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Tech Labs",
    "email": "hr@techlabs.com",
    "password": "SecurePass123",
    "description": "Leading technology company specializing in AI and ML solutions",
    "website": "https://techlabs.com",
    "industry": "Information Technology"
  }'
```

---

## 2. Company Login

### POST /api/companies/login

Login to company account.

**Request Body:**
```json
{
  "email": "hr@techlabs.com",
  "password": "SecurePass123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "company": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b3",
      "name": "Tech Labs",
      "email": "hr@techlabs.com",
      "description": "Leading technology company specializing in AI and ML solutions",
      "website": "https://techlabs.com",
      "industry": "Information Technology",
      "isVerified": false,
      "isActive": true,
      "totalJobsPosted": 5,
      "activeJobs": 3,
      "lastLogin": "2024-12-11T10:30:00.000Z",
      "createdAt": "2024-12-11T10:30:00.000Z",
      "updatedAt": "2024-12-11T10:30:00.000Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "tokenType": "Bearer",
      "expiresIn": "7d"
    }
  },
  "message": "Login successful"
}
```

**cURL Example:**
```bash
curl -X POST "https://smart-placement-backend.onrender.com/api/companies/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "hr@techlabs.com",
    "password": "SecurePass123"
  }'
```

---

## 3. Get Company Profile

### GET /api/companies/me

Get current company information (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "company": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b3",
      "name": "Tech Labs",
      "email": "hr@techlabs.com",
      "description": "Leading technology company specializing in AI and ML solutions",
      "website": "https://techlabs.com",
      "industry": "Information Technology",
      "size": "51-200",
      "founded": 2015,
      "logo": "https://example.com/logo.png",
      "contactInfo": {
        "phone": "+91-9876543210",
        "address": {
          "street": "123 Tech Street",
          "city": "Bangalore",
          "state": "Karnataka",
          "country": "India",
          "pincode": "560001"
        }
      },
      "hrContact": {
        "name": "John Doe",
        "email": "john@techlabs.com",
        "phone": "+91-9876543211",
        "designation": "HR Manager"
      },
      "isVerified": false,
      "isActive": true,
      "totalJobsPosted": 5,
      "activeJobs": 3,
      "lastLogin": "2024-12-11T10:30:00.000Z",
      "createdAt": "2024-12-11T10:30:00.000Z",
      "updatedAt": "2024-12-11T10:30:00.000Z"
    }
  }
}
```

**cURL Example:**
```bash
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/me" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 4. Update Company Profile

### PUT /api/companies/profile

Update company profile information (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Tech Labs Updated",
  "description": "Leading technology company specializing in AI, ML, and cloud solutions",
  "website": "https://techlabs.com",
  "logo": "https://example.com/new-logo.png",
  "industry": "Information Technology",
  "size": "201-500",
  "founded": 2015,
  "contactInfo": {
    "phone": "+91-9876543210",
    "address": {
      "street": "123 Tech Street",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India",
      "pincode": "560001"
    }
  },
  "hrContact": {
    "name": "John Doe",
    "email": "john@techlabs.com",
    "phone": "+91-9876543211",
    "designation": "HR Manager"
  }
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "company": {
      // Updated company object
    }
  },
  "message": "Company profile updated successfully"
}
```

**cURL Example:**
```bash
curl -X PUT "https://smart-placement-backend.onrender.com/api/companies/profile" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Tech Labs Updated",
    "description": "Leading technology company specializing in AI, ML, and cloud solutions",
    "size": "201-500"
  }'
```

---

## 5. Create Job Posting

### POST /api/companies/jobs

Create a new job posting (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "Junior ML Engineer",
  "location": "Bangalore",
  "domain": "AI / ML",
  "salary": "₹6-8 LPA",
  "description": "Join Tech Labs as a Junior ML Engineer and work on cutting-edge machine learning projects. You'll be responsible for developing and implementing ML models, working with large datasets, and collaborating with cross-functional teams to deliver innovative AI solutions.",
  "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills.",
  "educationLevel": "Graduate",
  "course": "B.Tech / B.E",
  "specialization": "CSE",
  "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
  "applyLink": "https://techlabs.com/careers/ml-engineer"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "job": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
      "title": "Junior ML Engineer",
      "company": "Tech Labs",
      "location": "Bangalore",
      "domain": "AI / ML",
      "salary": "₹6-8 LPA",
      "description": "Join Tech Labs as a Junior ML Engineer and work on cutting-edge machine learning projects...",
      "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills.",
      "educationLevel": "Graduate",
      "course": "B.Tech / B.E",
      "specialization": "CSE",
      "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
      "applyLink": "https://techlabs.com/careers/ml-engineer",
      "companyId": "64f7b3b3b3b3b3b3b3b3b3b3",
      "isActive": true,
      "totalApplications": 0,
      "postedBy": "company",
      "expiresAt": "2025-01-10T10:30:00.000Z",
      "createdAt": "2024-12-11T10:30:00.000Z",
      "updatedAt": "2024-12-11T10:30:00.000Z"
    }
  },
  "message": "Job posted successfully"
}
```

**cURL Example:**
```bash
curl -X POST "https://smart-placement-backend.onrender.com/api/companies/jobs" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Junior ML Engineer",
    "location": "Bangalore",
    "domain": "AI / ML",
    "salary": "₹6-8 LPA",
    "description": "Join Tech Labs as a Junior ML Engineer and work on cutting-edge machine learning projects. You will be responsible for developing and implementing ML models, working with large datasets, and collaborating with cross-functional teams to deliver innovative AI solutions.",
    "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills.",
    "educationLevel": "Graduate",
    "course": "B.Tech / B.E",
    "specialization": "CSE",
    "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
    "applyLink": "https://techlabs.com/careers/ml-engineer"
  }'
```

---

## 6. Get Company Job Postings

### GET /api/companies/jobs

Get all job postings created by the company (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Number of jobs per page (default: 20)
- `status` (optional): Filter by status - 'all', 'active', 'inactive' (default: 'all')

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "jobs": [
      {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
        "title": "Junior ML Engineer",
        "company": "Tech Labs",
        "location": "Bangalore",
        "domain": "AI / ML",
        "salary": "₹6-8 LPA",
        "description": "Join Tech Labs as a Junior ML Engineer...",
        "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills.",
        "educationLevel": "Graduate",
        "course": "B.Tech / B.E",
        "specialization": "CSE",
        "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
        "applyLink": "https://techlabs.com/careers/ml-engineer",
        "companyId": "64f7b3b3b3b3b3b3b3b3b3b3",
        "isActive": true,
        "totalApplications": 15,
        "postedBy": "company",
        "expiresAt": "2025-01-10T10:30:00.000Z",
        "createdAt": "2024-12-11T10:30:00.000Z",
        "updatedAt": "2024-12-11T10:30:00.000Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 1,
      "total_jobs": 5,
      "has_next": false,
      "has_prev": false,
      "per_page": 20
    }
  }
}
```

**cURL Examples:**
```bash
# Get all jobs
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"

# Get active jobs only
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs?status=active" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"

# Get jobs with pagination
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 7. Get Specific Job

### GET /api/companies/jobs/:id

Get details of a specific job posting (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "job": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
      "title": "Junior ML Engineer",
      "company": "Tech Labs",
      "location": "Bangalore",
      "domain": "AI / ML",
      "salary": "₹6-8 LPA",
      "description": "Join Tech Labs as a Junior ML Engineer...",
      "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills.",
      "educationLevel": "Graduate",
      "course": "B.Tech / B.E",
      "specialization": "CSE",
      "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
      "applyLink": "https://techlabs.com/careers/ml-engineer",
      "companyId": "64f7b3b3b3b3b3b3b3b3b3b3",
      "isActive": true,
      "totalApplications": 15,
      "postedBy": "company",
      "expiresAt": "2025-01-10T10:30:00.000Z",
      "createdAt": "2024-12-11T10:30:00.000Z",
      "updatedAt": "2024-12-11T10:30:00.000Z"
    }
  }
}
```

**cURL Example:**
```bash
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 8. Update Job Posting

### PUT /api/companies/jobs/:id

Update an existing job posting (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "Senior ML Engineer",
  "location": "Bangalore",
  "domain": "AI / ML",
  "salary": "₹8-12 LPA",
  "description": "Join Tech Labs as a Senior ML Engineer and lead cutting-edge machine learning projects. You'll be responsible for architecting ML solutions, mentoring junior engineers, and driving innovation in AI technologies.",
  "eligibility": "B.Tech/M.Tech CSE or related with 3+ years experience, strong Python/ML skills.",
  "educationLevel": "Graduate",
  "course": "B.Tech / B.E",
  "specialization": "CSE",
  "skills": ["Python", "Machine Learning", "TensorFlow", "PyTorch", "MLOps", "AWS"],
  "applyLink": "https://techlabs.com/careers/senior-ml-engineer"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "job": {
      // Updated job object
    }
  },
  "message": "Job updated successfully"
}
```

**cURL Example:**
```bash
curl -X PUT "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Senior ML Engineer",
    "salary": "₹8-12 LPA",
    "description": "Join Tech Labs as a Senior ML Engineer and lead cutting-edge machine learning projects..."
  }'
```

---

## 9. Delete Job Posting

### DELETE /api/companies/jobs/:id

Delete a job posting (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Job deleted successfully"
}
```

**cURL Example:**
```bash
curl -X DELETE "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 10. Toggle Job Status

### PATCH /api/companies/jobs/:id/toggle-status

Toggle job active/inactive status (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "job": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
      "title": "Junior ML Engineer",
      "isActive": false,
      // ... other job fields
    }
  },
  "message": "Job deactivated successfully"
}
```

**cURL Example:**
```bash
curl -X PATCH "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4/toggle-status" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 11. Company Dashboard

### GET /api/companies/dashboard

Get company dashboard statistics (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "statistics": {
      "totalJobs": 15,
      "activeJobs": 12,
      "inactiveJobs": 3,
      "recentJobs": 5,
      "totalApplications": 150,
      "pendingApplications": 45,
      "shortlistedApplications": 25,
      "hiredApplications": 8,
      "recentApplications": 12
    },
    "charts": {
      "jobsByDomain": [
        { "_id": "AI / ML", "count": 5 },
        { "_id": "Web Development", "count": 4 },
        { "_id": "Data Science", "count": 3 },
        { "_id": "Software Development", "count": 3 }
      ],
      "jobsByEducation": [
        { "_id": "Graduate", "count": 10 },
        { "_id": "Post Graduate", "count": 5 }
      ],
      "applicationsByStatus": [
        { "_id": "pending", "count": 45 },
        { "_id": "reviewed", "count": 35 },
        { "_id": "shortlisted", "count": 25 },
        { "_id": "rejected", "count": 37 },
        { "_id": "hired", "count": 8 }
      ]
    }
  }
}
```

**cURL Example:**
```bash
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/dashboard" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 12. Application Management

### GET /api/companies/applications

Get all applications for company's job postings (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Number of applications per page (default: 20)
- `status` (optional): Filter by status - 'all', 'pending', 'reviewed', 'shortlisted', 'rejected', 'hired' (default: 'all')
- `jobId` (optional): Filter by specific job ID

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "applications": [
      {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b5",
        "userId": {
          "_id": "64f7b3b3b3b3b3b3b3b3b3b6",
          "name": "John Doe",
          "email": "john@example.com",
          "phone": "9876543210",
          "profilePicture": "https://example.com/profile.jpg",
          "profile": {
            "educationLevel": "Graduate",
            "course": "B.Tech / B.E",
            "specialization": "CSE",
            "summary": "Passionate software developer..."
          },
          "location": {
            "city": "Bangalore",
            "state": "Karnataka",
            "country": "India"
          },
          "skills": [
            { "name": "Python", "proficiency": "Advanced" },
            { "name": "Machine Learning", "proficiency": "Intermediate" }
          ]
        },
        "jobId": {
          "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
          "title": "Junior ML Engineer",
          "company": "Tech Labs",
          "location": "Bangalore",
          "domain": "AI / ML",
          "salary": "₹6-8 LPA"
        },
        "status": "pending",
        "contactInfo": {
          "fullName": "John Doe",
          "email": "john@example.com",
          "phone": "9876543210",
          "location": {
            "city": "Bangalore",
            "state": "Karnataka",
            "country": "India"
          }
        },
        "resume": {
          "fileName": "john_doe_resume.pdf",
          "fileUrl": "https://example.com/resumes/john_doe_resume.pdf",
          "uploadedAt": "2024-12-11T10:30:00.000Z"
        },
        "coverLetter": "I am very interested in this position...",
        "appliedAt": "2024-12-11T10:30:00.000Z",
        "lastUpdated": "2024-12-11T10:30:00.000Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_applications": 95,
      "has_next": true,
      "has_prev": false,
      "per_page": 20
    }
  }
}
```

**cURL Examples:**
```bash
# Get all applications
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/applications" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"

# Get pending applications only
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/applications?status=pending" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"

# Get applications for specific job
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/applications?jobId=64f7b3b3b3b3b3b3b3b3b3b4" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 13. Get Specific Application

### GET /api/companies/applications/:id

Get detailed information about a specific application (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "application": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b5",
      "userId": {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b6",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "9876543210",
        "profilePicture": "https://example.com/profile.jpg",
        "profile": {
          "educationLevel": "Graduate",
          "course": "B.Tech / B.E",
          "specialization": "CSE",
          "summary": "Passionate software developer with 2 years of experience...",
          "currentSalary": 600000
        },
        "workExperience": [
          {
            "jobTitle": "Software Developer",
            "company": "StartupXYZ",
            "duration": "2 years",
            "description": "Developed web applications using React and Node.js"
          }
        ],
        "education": [
          {
            "degree": "Bachelor of Technology",
            "institution": "ABC University",
            "grade": "8.5 CGPA"
          }
        ],
        "skills": [
          { "name": "Python", "proficiency": "Advanced" },
          { "name": "Machine Learning", "proficiency": "Intermediate" },
          { "name": "TensorFlow", "proficiency": "Intermediate" }
        ],
        "certifications": [
          {
            "name": "AWS Certified Developer",
            "issuer": "Amazon Web Services",
            "issueDate": "2024-01-15"
          }
        ]
      },
      "jobId": {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
        "title": "Junior ML Engineer",
        "company": "Tech Labs",
        "location": "Bangalore",
        "domain": "AI / ML",
        "salary": "₹6-8 LPA",
        "skills": ["Python", "Machine Learning", "TensorFlow", "Scikit-learn", "Pandas"],
        "description": "Join Tech Labs as a Junior ML Engineer...",
        "eligibility": "B.Tech/M.Tech CSE or related, strong Python/ML skills."
      },
      "status": "pending",
      "contactInfo": {
        "fullName": "John Doe",
        "email": "john@example.com",
        "phone": "9876543210",
        "location": {
          "city": "Bangalore",
          "state": "Karnataka",
          "country": "India"
        }
      },
      "resume": {
        "fileName": "john_doe_resume.pdf",
        "fileUrl": "https://example.com/resumes/john_doe_resume.pdf",
        "uploadedAt": "2024-12-11T10:30:00.000Z"
      },
      "coverLetter": "I am very interested in this position because...",
      "employerQuestions": [
        {
          "question": "Do you have experience with TensorFlow?",
          "answer": "Yes, I have 1 year of experience with TensorFlow",
          "questionType": "text"
        }
      ],
      "relevantExperience": [
        {
          "jobTitle": "ML Intern",
          "company": "DataCorp",
          "duration": "6 months",
          "description": "Worked on image classification projects using CNN"
        }
      ],
      "supportingDocuments": [
        {
          "fileName": "portfolio.pdf",
          "fileUrl": "https://example.com/docs/portfolio.pdf",
          "documentType": "portfolio"
        }
      ],
      "employerActions": [
        {
          "action": "viewed",
          "actionDate": "2024-12-11T11:00:00.000Z",
          "notes": "Initial review"
        }
      ],
      "appliedAt": "2024-12-11T10:30:00.000Z",
      "lastUpdated": "2024-12-11T11:00:00.000Z"
    }
  }
}
```

**cURL Example:**
```bash
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/applications/64f7b3b3b3b3b3b3b3b3b3b5" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 14. Update Application Status

### PATCH /api/companies/applications/:id/status

Update the status of a job application (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "status": "shortlisted",
  "notes": "Candidate has excellent technical skills and relevant experience. Moving to next round."
}
```

**Available Status Values:**
- `pending` - Application received, not yet reviewed
- `reviewed` - Application has been reviewed
- `shortlisted` - Candidate shortlisted for interview
- `rejected` - Application rejected
- `hired` - Candidate hired

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "application": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b5",
      "userId": {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b6",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "9876543210"
      },
      "jobId": {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
        "title": "Junior ML Engineer",
        "company": "Tech Labs"
      },
      "status": "shortlisted",
      "employerActions": [
        {
          "action": "shortlisted",
          "actionDate": "2024-12-11T12:00:00.000Z",
          "notes": "Candidate has excellent technical skills and relevant experience. Moving to next round.",
          "actionBy": "64f7b3b3b3b3b3b3b3b3b3b3"
        }
      ],
      "appliedAt": "2024-12-11T10:30:00.000Z",
      "lastUpdated": "2024-12-11T12:00:00.000Z"
    }
  },
  "message": "Application status updated to shortlisted"
}
```

**cURL Example:**
```bash
curl -X PATCH "https://smart-placement-backend.onrender.com/api/companies/applications/64f7b3b3b3b3b3b3b3b3b3b5/status" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "shortlisted",
    "notes": "Candidate has excellent technical skills and relevant experience. Moving to next round."
  }'
```

---

## 15. Get Applications for Specific Job

### GET /api/companies/jobs/:jobId/applications

Get all applications for a specific job posting (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Number of applications per page (default: 20)
- `status` (optional): Filter by status - 'all', 'pending', 'reviewed', 'shortlisted', 'rejected', 'hired' (default: 'all')

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "job": {
      "_id": "64f7b3b3b3b3b3b3b3b3b3b4",
      "title": "Junior ML Engineer",
      "company": "Tech Labs",
      "location": "Bangalore",
      "domain": "AI / ML"
    },
    "applications": [
      {
        "_id": "64f7b3b3b3b3b3b3b3b3b3b5",
        "userId": {
          "_id": "64f7b3b3b3b3b3b3b3b3b3b6",
          "name": "John Doe",
          "email": "john@example.com",
          "phone": "9876543210",
          "profile": {
            "educationLevel": "Graduate",
            "specialization": "CSE"
          }
        },
        "status": "pending",
        "appliedAt": "2024-12-11T10:30:00.000Z"
      }
    ],
    "statistics": [
      { "_id": "pending", "count": 15 },
      { "_id": "reviewed", "count": 8 },
      { "_id": "shortlisted", "count": 5 },
      { "_id": "rejected", "count": 12 },
      { "_id": "hired", "count": 2 }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_applications": 42,
      "has_next": true,
      "has_prev": false,
      "per_page": 20
    }
  }
}
```

**cURL Examples:**
```bash
# Get all applications for a job
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4/applications" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"

# Get only pending applications for a job
curl -X GET "https://smart-placement-backend.onrender.com/api/companies/jobs/64f7b3b3b3b3b3b3b3b3b3b4/applications?status=pending" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN"
```

---

## 16. Bulk Application Actions

### POST /api/companies/applications/bulk-action

Perform bulk actions on multiple applications (requires authentication).

**Headers:**
```
Authorization: Bearer <company_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "applicationIds": [
    "64f7b3b3b3b3b3b3b3b3b3b5",
    "64f7b3b3b3b3b3b3b3b3b3b6",
    "64f7b3b3b3b3b3b3b3b3b3b7"
  ],
  "action": "reviewed",
  "notes": "Initial screening completed for all candidates"
}
```

**Available Bulk Actions:**
- `reviewed` - Mark applications as reviewed
- `shortlisted` - Shortlist multiple candidates
- `rejected` - Reject multiple applications

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "updatedCount": 3,
    "totalRequested": 3
  },
  "message": "3 applications updated to reviewed"
}
```

**cURL Example:**
```bash
curl -X POST "https://smart-placement-backend.onrender.com/api/companies/applications/bulk-action" \
  -H "Authorization: Bearer YOUR_COMPANY_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "applicationIds": [
      "64f7b3b3b3b3b3b3b3b3b3b5",
      "64f7b3b3b3b3b3b3b3b3b3b6"
    ],
    "action": "shortlisted",
    "notes": "Both candidates meet our technical requirements"
  }'
```

---

## Error Responses

### Common Error Codes

**400 Bad Request - Validation Error:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "email": ["Please provide a valid email address"],
      "password": ["Password must be at least 8 characters long"]
    }
  }
}
```

**401 Unauthorized:**
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Access token is required"
  }
}
```

**404 Not Found:**
```json
{
  "success": false,
  "error": {
    "code": "JOB_NOT_FOUND",
    "message": "Job not found"
  }
}
```

**409 Conflict:**
```json
{
  "success": false,
  "error": {
    "code": "COMPANY_EXISTS",
    "message": "Company with this email already exists"
  }
}
```

**500 Internal Server Error:**
```json
{
  "success": false,
  "error": {
    "code": "SERVER_ERROR",
    "message": "Internal server error"
  }
}
```

---

## Integration with User App

When companies create jobs through this API, the jobs automatically appear in the user-facing job listings with the following behavior:

1. **Automatic Visibility**: Jobs created by companies are immediately visible to users
2. **Filtering**: Users can filter jobs by education level, specialization, domain, etc.
3. **Search**: Jobs are included in search results
4. **Company Attribution**: Jobs show the company name and can be traced back to the company
5. **Application Tracking**: When users apply to company jobs, applications can be tracked

### Job Visibility Flow:
```
Company creates job → Job saved to database → Job appears in user app → Users can apply
```

---

## Rate Limiting

API endpoints are rate-limited to prevent abuse:
- **Registration/Login**: 5 requests per minute per IP
- **Job Creation**: 10 jobs per hour per company
- **General API calls**: 100 requests per minute per company

---

## Best Practices

1. **Store JWT Token Securely**: Save the JWT token securely in your application
2. **Handle Token Expiry**: Implement token refresh logic
3. **Validate Input**: Always validate input on the client side before sending requests
4. **Error Handling**: Implement proper error handling for all API calls
5. **Pagination**: Use pagination for job listings to improve performance
6. **Job Descriptions**: Write detailed, engaging job descriptions (50-2000 characters)
7. **Skills Array**: Include relevant skills to improve job matching
8. **Apply Links**: Ensure apply links are valid and lead to your application process

---

## Testing

Use the provided cURL commands to test all endpoints. For automated testing, consider using:
- **Postman**: Import the API collection for easy testing
- **Jest/Mocha**: For automated API testing
- **Newman**: For command-line Postman collection running

---

This completes the comprehensive Company API documentation. Companies can now register, login, manage their profiles, and create job postings that will automatically appear in the user-facing job application.