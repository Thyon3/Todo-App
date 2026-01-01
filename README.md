# 📝 Todo Mobile Application

A full-stack, production-ready mobile todo application with a Flutter frontend and Node.js backend. Features comprehensive task management, offline-first architecture, local notifications, and beautiful Material Design 3 UI.

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb)](https://www.mongodb.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [API Documentation](#-api-documentation)
- [Database Schema](#-database-schema)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

This is a comprehensive todo application that combines a powerful backend API with a feature-rich mobile frontend. The application supports both online and offline modes, with the frontend capable of operating entirely offline using local SQLite storage.

### Key Highlights

- **Frontend**: Flutter-based cross-platform mobile app (Android & iOS)
- **Backend**: RESTful API built with Node.js and Express
- **Database**: MongoDB for backend, SQLite for frontend offline storage
- **Authentication**: JWT-based secure authentication
- **Offline-First**: Full offline functionality with local data persistence
- **Real-time**: Local notifications with exact alarm scheduling
- **Production-Ready**: Clean architecture, error handling, and optimized performance

---

## ✨ Features

### 🎨 Frontend Features

#### Core Task Management
- ✅ Create, Read, Update, Delete (CRUD) operations
- ✅ Task titles, descriptions, and notes
- ✅ Multi-status tracking (Pending, In Progress, Completed)
- ✅ Three priority levels (Low, Medium, High) with color coding
- ✅ Task completion tracking with percentage progress

#### Organization & Categorization
- ✅ Custom categories with colors and icons
- ✅ Category management interface
- ✅ Task tagging system
- ✅ Subtasks/checklist functionality
- ✅ Task grouping by date (Today, Tomorrow, This Week, Later)

#### Date & Time Management
- ✅ Due date and time pickers
- ✅ Overdue task indicators
- ✅ Recurring tasks (Daily, Weekly, Monthly)
- ✅ Smart date grouping

#### Notifications & Reminders
- ✅ Local push notifications
- ✅ Exact alarm scheduling
- ✅ Notification permission handling
- ✅ Snooze functionality (10 minutes)
- ✅ Boot receiver for notification persistence (Android)

#### Search & Filter
- ✅ Real-time search across title, description, and tags
- ✅ Filter by status, priority, and category
- ✅ Multiple simultaneous filters
- ✅ Debounced search for performance

#### Sorting Options
- ✅ Sort by due date
- ✅ Sort by priority
- ✅ Sort by title (alphabetical)
- ✅ Sort by created date
- ✅ Smart sort (overdue + priority + date)

#### User Interface
- ✅ Material Design 3
- ✅ Dark mode & light mode
- ✅ System theme preference support
- ✅ Responsive layouts
- ✅ Beautiful animations and transitions
- ✅ Loading states with shimmer effects
- ✅ Empty states and error handling

#### Gestures & Interactions
- ✅ Swipe left to delete
- ✅ Swipe right to complete
- ✅ Haptic feedback on interactions
- ✅ Pull-to-refresh
- ✅ Long press actions
- ✅ Quick add dialog

#### Data Management
- ✅ SQLite local database with indexing
- ✅ JSON export and backup
- ✅ Share functionality
- ✅ Database migration system
- ✅ Query optimization

#### Analytics & Insights
- ✅ Task statistics and completion rates
- ✅ Tasks breakdown by priority
- ✅ Tasks breakdown by category
- ✅ Productive days tracking
- ✅ Progress visualization

### 🔧 Backend Features

#### Authentication & Security
- ✅ User registration with email validation
- ✅ Secure password hashing (bcrypt)
- ✅ JWT token-based authentication
- ✅ Token expiration handling

#### Todo Management API
- ✅ Create todo items
- ✅ Retrieve user-specific todos
- ✅ User-todo relationship management
- ✅ RESTful API design

#### Database
- ✅ MongoDB Atlas integration
- ✅ Mongoose ODM
- ✅ Schema validation
- ✅ Relationship management

---
## 🏗️ Architecture

### Frontend Architecture

```
Clean Architecture with Provider Pattern

┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │ Screens  │  │ Widgets  │  │Components │ │
│  └──────────┘  └──────────┘  └───────────┘ │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│           State Management Layer             │
│  ┌──────────────────────────────────────┐  │
│  │      Providers (ChangeNotifier)      │  │
│  └──────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│             Business Logic Layer             │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │ Services │  │  Utils   │  │Extensions │ │
│  └──────────┘  └──────────┘  └───────────┘ │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│               Data Layer                     │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │  Models  │  │  SQLite  │  │    API    │ │
│  └──────────┘  └──────────┘  └───────────┘ │
└─────────────────────────────────────────────┘
```

### Backend Architecture

```
MVC Pattern with Service Layer

┌─────────────────────────────────────────────┐
│               Routes Layer                   │
│  ┌──────────────┐  ┌──────────────────┐    │
│  │ User Routes  │  │  Todo Routes     │    │
│  └──────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│            Controllers Layer                 │
│  ┌──────────────┐  ┌──────────────────┐    │
│  │User Controller│ │ Todo Controller  │    │
│  └──────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│             Services Layer                   │
│  ┌──────────────┐  ┌──────────────────┐    │
│  │User Service  │  │  Todo Service    │    │
│  └──────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│             Models & Database                │
│  ┌──────────────┐  ┌──────────────────┐    │
│  │  User Model  │  │  Todo Model      │    │
│  └──────────────┘  └──────────────────┘    │
│              MongoDB (Mongoose)              │
└─────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

### Frontend

| Technology | Purpose |
|------------|---------|
| **Flutter 3.7+** | Cross-platform mobile framework |
| **Dart 3.0+** | Programming language |
| **Provider** | State management |
| **SQLite (sqflite)** | Local database |
| **flutter_local_notifications** | Local notifications |
| **timezone** | Timezone handling |
| **intl** | Internationalization |
| **table_calendar** | Calendar views |
| **fl_chart** | Charts and analytics |
| **flutter_slidable** | Swipe gestures |
| **shimmer** | Loading animations |
| **uuid** | Unique ID generation |
| **shared_preferences** | Local storage |
| **path_provider** | File system access |
| **share_plus** | Share functionality |

### Backend

| Technology | Purpose |
|------------|---------|
| **Node.js** | JavaScript runtime |
| **Express 5.x** | Web framework |
| **MongoDB Atlas** | Cloud database |
| **Mongoose 8.x** | MongoDB ODM |
| **bcrypt 6.x** | Password hashing |
| **jsonwebtoken** | JWT authentication |
| **body-parser** | Request parsing |
| **nodemon** | Development auto-reload |

---

## 📁 Project Structure

### Frontend Structure

```
frontend/
├── lib/
│   ├── main.dart                      # Application entry point
│   │
│   ├── config/                        # Configuration files
│   │   ├── app_theme.dart            # Theme configuration
│   │   └── config.dart               # API endpoints
│   │
│   ├── constants/                     # Application constants
│   │   ├── app_constants.dart        # General constants
│   │   ├── asset_paths.dart          # Asset path constants
│   │   └── route_names.dart          # Route name constants
│   │
│   ├── models/                        # Data models
│   │   ├── task_model.dart           # Task entity
│   │   ├── category_model.dart       # Category entity
│   │   ├── subtask_model.dart        # Subtask entity
│   │   ├── reminder_model.dart       # Reminder entity
│   │   ├── comment_model.dart        # Comment entity
│   │   ├── attachment_model.dart     # Attachment entity
│   │   └── task_template_model.dart  # Task template entity
│   │
│   ├── providers/                     # State management
│   │   ├── task_provider.dart        # Task state management
│   │   ├── category_provider.dart    # Category state management
│   │   └── theme_provider.dart       # Theme state management
│   │
│   ├── screens/                       # Main application screens
│   │   ├── home_screen.dart          # Home screen with tabs
│   │   ├── add_task_screen.dart      # Add/Edit task screen
│   │   ├── task_detail_screen.dart   # Task details screen
│   │   ├── categories_screen.dart    # Category management
│   │   └── settings_screen.dart      # Settings screen
│   │
│   ├── pages/                         # Additional pages
│   │   ├── dashboard.dart            # Dashboard page
│   │   ├── homescreen.dart           # Alternative home
│   │   ├── login.dart                # Login page
│   │   ├── login_page.dart           # Login page (variant)
│   │   └── register_page.dart        # Registration page
│   │
│   ├── services/                      # Business logic services
│   │   ├── database_helper.dart      # SQLite database management
│   │   ├── task_service.dart         # Task operations
│   │   ├── category_service.dart     # Category operations
│   │   ├── subtask_service.dart      # Subtask operations
│   │   └── notification_service.dart # Notification management
│   │
│   ├── widgets/                       # Reusable UI components (17+)
│   │   ├── task_card.dart            # Task card widget
│   │   ├── priority_badge.dart       # Priority indicator
│   │   ├── category_badge.dart       # Category badge
│   │   ├── task_status_badge.dart    # Status badge
│   │   ├── progress_indicator_widget.dart # Progress indicator
│   │   ├── empty_state_widget.dart   # Empty state UI
│   │   ├── loading_widget.dart       # Loading indicator
│   │   ├── confirmation_dialog.dart  # Confirmation dialogs
│   │   ├── quick_add_dialog.dart     # Quick add dialog
│   │   ├── animated_fab.dart         # Animated FAB
│   │   ├── statistic_card.dart       # Statistics card
│   │   └── ... (more widgets)
│   │
│   ├── components/                    # Shared components
│   │   ├── my_button.dart            # Custom button
│   │   └── my_text_field.dart        # Custom text field
│   │
│   ├── utils/                         # Utility functions (20+ files)
│   │   ├── validators.dart           # Form validators
│   │   ├── date_formatter.dart       # Date formatting
│   │   ├── notification_scheduler.dart # Notification scheduling
│   │   ├── backup_manager.dart       # Backup functionality
│   │   ├── error_handler.dart        # Error handling
│   │   ├── logger.dart               # Logging utility
│   │   ├── task_sorter.dart          # Task sorting logic
│   │   ├── task_filter_helper.dart   # Task filtering
│   │   ├── productivity_insights.dart # Analytics
│   │   ├── eisenhower_matrix.dart    # Task prioritization
│   │   └── ... (more utilities)
│   │
│   └── extensions/                    # Dart extensions
│       ├── date_time_extensions.dart # DateTime extensions
│       └── string_extensions.dart    # String extensions
│
├── android/                           # Android platform files
├── ios/                               # iOS platform files
├── test/                              # Unit and widget tests
├── pubspec.yaml                       # Dependencies
└── README.md                          # Frontend documentation
```

### Backend Structure

```
Backend/
├── config/
│   └── db.js                         # MongoDB connection configuration
│
├── model/
│   ├── user_model.js                 # User schema & model
│   └── todoList.model.js             # Todo schema & model
│
├── controllers/
│   ├── user.controller.js            # User request handlers
│   └── todo.controller.js            # Todo request handlers
│
├── sevices/                          # Business logic layer
│   ├── user.service.js               # User service (auth, JWT)
│   └── todo.services.js              # Todo service (CRUD)
│
├── routers/
│   ├── user.router.js                # User routes
│   └── todo.router.js                # Todo routes
│
├── index.js                          # Application entry point
├── app.js                            # Express app configuration
├── package.json                      # Dependencies
└── package-lock.json                 # Dependency lock file
```

---
## 📋 Prerequisites

### Frontend Requirements

- **Flutter SDK**: 3.7.2 or higher
- **Dart SDK**: 3.0 or higher
- **Android Studio** / **Xcode**: For building Android/iOS apps
- **Android SDK**: API level 21 (Android 5.0) or higher
- **iOS**: iOS 11.0 or higher
- **Git**: For version control

### Backend Requirements

- **Node.js**: 18.x or higher
- **npm**: 9.x or higher
- **MongoDB Atlas**: Free tier account (or local MongoDB)
- **Git**: For version control

### Development Tools (Recommended)

- **VS Code** / **Android Studio**: IDE with Flutter/Dart plugins
- **Postman** / **Insomnia**: For API testing
- **MongoDB Compass**: For database visualization

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/todo-mobile-app.git
cd todo-mobile-app
```

### 2. Backend Setup

```bash
# Navigate to backend directory
cd Backend

# Install dependencies
npm install

# Or use
npm ci  # For clean install from lock file
```

#### Required Backend Dependencies

The following packages will be installed:

- `express`: ^5.1.0
- `mongoose`: ^8.15.1
- `bcrypt`: ^6.0.0
- `jsonwebtoken`: ^9.0.2
- `body-parser`: ^2.2.0
- `nodemon`: ^3.1.10 (dev dependency)

### 3. Frontend Setup

```bash
# Navigate to frontend directory
cd ../frontend

# Get Flutter dependencies
flutter pub get

# For iOS, install CocoaPods dependencies
cd ios && pod install && cd ..
```

#### Required Frontend Dependencies

Key packages (see `pubspec.yaml` for complete list):

- `provider`: ^6.1.1
- `sqflite`: ^2.3.2
- `flutter_local_notifications`: ^17.0.0
- `intl`: ^0.19.0
- `table_calendar`: ^3.0.9
- `fl_chart`: ^0.66.0
- `shared_preferences`: ^2.5.3

---

## ⚙️ Configuration

### Backend Configuration

#### 1. Database Configuration

Edit `Backend/config/db.js` to configure your MongoDB connection:

```javascript
const mongoose = require("mongoose");

// Replace with your MongoDB connection string
const DB_URI = "mongodb+srv://username:password@cluster.mongodb.net/database?retryWrites=true&w=majority";

// Or use environment variable
// const DB_URI = process.env.MONGODB_URI;

const connection = mongoose
  .connect(DB_URI)
  .then(() => console.log("MongoDB connected successfully"))
  .catch((err) => console.error("MongoDB connection failed:", err));

module.exports = mongoose;
```

**Security Note**: For production, use environment variables:

```bash
# Create .env file in Backend directory
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
PORT=3000
```

#### 2. JWT Secret Configuration

Update JWT secret in `Backend/controllers/user.controller.js` and `Backend/sevices/user.service.js`:

```javascript
// Replace "secreteKey" with environment variable
const secretKey = process.env.JWT_SECRET || "your_secure_secret_key";
```

### Frontend Configuration

#### 1. API Endpoint Configuration

Edit `frontend/lib/config/config.dart` to point to your backend:

```dart
// For local development
const uri = "http://localhost:3000/";

// For Android emulator
// const uri = "http://10.0.2.2:3000/";

// For physical device (use your computer's IP)
// const uri = "http://192.168.1.100:3000/";

// For production
// const uri = "https://your-api-domain.com/";

const register = uri + "register";
const login = uri + "login";
const addTodoUri = uri + "createTodoList";
```

#### 2. Android Configuration (for Notifications)

Ensure proper permissions in `frontend/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### 3. iOS Configuration (for Notifications)

Update `frontend/ios/Runner/Info.plist` if needed for permissions.

---

## 🎮 Running the Application

### Starting the Backend

#### Development Mode

```bash
cd Backend

# Start with nodemon (auto-reload on changes)
npm run dev

# Or
npm start
```

The server will start on `http://localhost:3000`

#### Production Mode

```bash
cd Backend
NODE_ENV=production node index.js
```

### Starting the Frontend

#### Running on Android Emulator/Device

```bash
cd frontend

# Check connected devices
flutter devices

# Run the app
flutter run

# Or specify device
flutter run -d <device-id>
```

#### Running on iOS Simulator/Device

```bash
cd frontend

# Open iOS simulator
open -a Simulator

# Run the app
flutter run

# Or specify device
flutter run -d <device-id>
```

#### Running in Debug Mode

```bash
flutter run --debug
```

#### Running in Release Mode

```bash
flutter run --release
```

---
## 📡 API Documentation

### Base URL

```
http://localhost:3000
```

### Authentication Endpoints

#### 1. Register User

**POST** `/register`

Creates a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Success Response (201):**
```json
{
  "status": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "the user has been registered succesfully"
}
```

**Error Response (400):**
```json
{
  "status": false,
  "error": "Email and password are required"
}
```

#### 2. Login User

**POST** `/login`

Authenticates an existing user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Success Response (200):**
```json
{
  "status": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Response:**
```json
{
  "error": "Invalid Password"
}
```
or
```json
{
  "error": "the User does not exist please Sign up first"
}
```

### Todo Endpoints

#### 3. Create Todo

**POST** `/createTodoList`

Creates a new todo item for a user.

**Request Body:**
```json
{
  "userId": "507f1f77bcf86cd799439011",
  "title": "Complete project documentation",
  "description": "Write comprehensive README and API docs"
}
```

**Success Response (200):**
```json
{
  "status": true,
  "success": {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "__v": 0
  }
}
```

#### 4. Get User Todos

**GET** `/getTodoList`

Retrieves all todo items for a specific user.

**Request Body:**
```json
{
  "userId": "507f1f77bcf86cd799439011"
}
```

**Success Response (200):**
```json
{
  "status": true,
  "success": [
    {
      "_id": "507f1f77bcf86cd799439012",
      "userId": "507f1f77bcf86cd799439011",
      "title": "Complete project documentation",
      "description": "Write comprehensive README and API docs",
      "__v": 0
    },
    {
      "_id": "507f1f77bcf86cd799439013",
      "userId": "507f1f77bcf86cd799439011",
      "title": "Fix authentication bug",
      "description": "Debug and fix JWT token validation",
      "__v": 0
    }
  ]
}
```

### API Authentication

The JWT token returned from `/register` or `/login` should be used for authenticated requests:

```javascript
// Example with fetch
fetch('http://localhost:3000/createTodoList', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + token
  },
  body: JSON.stringify(data)
});
```

**Note**: Currently, the todo endpoints don't enforce authentication middleware. To add JWT verification, implement middleware:

```javascript
// Example authentication middleware (to be implemented)
const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  try {
    const decoded = jwt.verify(token, 'secreteKey');
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};
```

---

## 🗄️ Database Schema

### MongoDB Collections

#### Users Collection

```javascript
{
  _id: ObjectId,
  email: String (unique, lowercase, required),
  password: String (hashed, required),
  __v: Number
}
```

**Features:**
- Password hashing with bcrypt (salt rounds: 10)
- Pre-save hook for automatic password hashing
- `comparePassword` method for authentication

#### TodoList Collection

```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: 'user'),
  title: String (required),
  description: String (required),
  __v: Number
}
```

**Relationships:**
- `userId` references the `users` collection
- One-to-many relationship (User → Todos)

### SQLite Schema (Frontend)

#### Tasks Table

```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  dueDate TEXT,
  dueTime TEXT,
  priority INTEGER NOT NULL DEFAULT 1,
  status INTEGER NOT NULL DEFAULT 0,
  categoryId TEXT,
  tags TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  hasReminder INTEGER NOT NULL DEFAULT 0,
  reminderTime TEXT,
  isRecurring INTEGER NOT NULL DEFAULT 0,
  recurringPattern TEXT,
  notes TEXT,
  completionPercentage INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE SET NULL
);

-- Indexes for performance
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_dueDate ON tasks(dueDate);
CREATE INDEX idx_tasks_categoryId ON tasks(categoryId);
```

#### Categories Table

```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  colorHex TEXT NOT NULL,
  iconCodePoint TEXT NOT NULL,
  createdAt TEXT NOT NULL
);
```

#### Subtasks Table

```sql
CREATE TABLE subtasks (
  id TEXT PRIMARY KEY,
  taskId TEXT NOT NULL,
  title TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  orderIndex INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL,
  FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
);

CREATE INDEX idx_subtasks_taskId ON subtasks(taskId);
```

---

## 🧪 Testing

### Backend Testing

```bash
cd Backend

# Run tests (when implemented)
npm test

# Test individual endpoints with curl
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### Frontend Testing

```bash
cd frontend

# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Manual Testing Checklist

#### Backend
- [ ] User registration with valid credentials
- [ ] User registration with duplicate email (should fail)
- [ ] User login with correct credentials
- [ ] User login with incorrect credentials (should fail)
- [ ] Create todo with valid userId
- [ ] Retrieve todos for a user
- [ ] JWT token expiration handling

#### Frontend
- [ ] Create task with all fields
- [ ] Edit existing task
- [ ] Delete task
- [ ] Complete task
- [ ] Set task priority
- [ ] Add subtasks
- [ ] Create category
- [ ] Filter tasks by status/priority/category
- [ ] Search tasks
- [ ] Sort tasks
- [ ] Set reminder notifications
- [ ] Export/backup data
- [ ] Theme switching (light/dark)
- [ ] Offline functionality

---

## 🚢 Deployment

### Backend Deployment

#### Option 1: Heroku

```bash
# Install Heroku CLI
# Login to Heroku
heroku login

# Create app
cd Backend
heroku create your-app-name

# Set environment variables
heroku config:set MONGODB_URI=your_mongodb_uri
heroku config:set JWT_SECRET=your_secret_key
heroku config:set NODE_ENV=production

# Deploy
git push heroku main
```

#### Option 2: Railway / Render / AWS

1. Connect your GitHub repository
2. Set environment variables
3. Deploy with one click

#### Option 3: VPS (Ubuntu)

```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Clone and setup
git clone your-repo
cd Backend
npm install
pm2 start index.js --name todo-api

# Setup nginx reverse proxy
sudo apt install nginx
# Configure nginx to proxy to localhost:3000
```

### Frontend Deployment

#### Building for Android

```bash
cd frontend

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

#### Building for iOS

```bash
cd frontend

# Build for iOS
flutter build ios --release

# Or open in Xcode
open ios/Runner.xcworkspace
# Then archive and upload to App Store
```

#### Play Store Deployment

1. Create a Google Play Console account
2. Create a new application
3. Upload `app-release.aab`
4. Fill in store listing details
5. Set content rating and pricing
6. Submit for review

#### App Store Deployment

1. Create Apple Developer account
2. Create App Store Connect app
3. Archive in Xcode
4. Upload to App Store Connect
5. Submit for review

---
## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Code Style

#### Frontend (Dart/Flutter)
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check for issues
- Format code with `dart format .`

#### Backend (JavaScript/Node.js)
- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use ESLint for linting
- Use Prettier for formatting

### Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Example:**
```
feat(frontend): add dark mode toggle to settings

Added a toggle switch in the settings screen that allows users
to switch between light and dark themes.

Closes #123
```

---

## 🐛 Known Issues & Roadmap

### Known Issues

- [ ] Backend todo endpoints don't enforce JWT authentication
- [ ] No password reset functionality
- [ ] Todo update and delete endpoints not implemented
- [ ] Frontend login/register pages exist but aren't connected to backend

### Future Enhancements

#### High Priority
- [ ] Implement authentication middleware for todo endpoints
- [ ] Add todo update and delete endpoints
- [ ] Connect frontend login/register to backend
- [ ] Add password reset functionality
- [ ] Implement refresh token mechanism

#### Medium Priority
- [ ] Add user profile management
- [ ] Implement cloud sync between devices
- [ ] Add collaboration features (shared todos)
- [ ] Implement real-time updates with WebSockets
- [ ] Add file attachments to tasks
- [ ] Implement task templates

#### Low Priority
- [ ] Add voice input for task creation
- [ ] Implement AI-powered smart suggestions
- [ ] Add home screen widgets (Android/iOS)
- [ ] Implement custom themes
- [ ] Add task dependencies visualization
- [ ] Implement Eisenhower matrix view
- [ ] Add focus mode with Pomodoro timer

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👥 Authors & Contributors

### Main Contributors

- **[Your Name]** - Initial work and development
  - GitHub: [@yourusername](https://github.com/yourusername)
  - Email: your.email@example.com

See also the list of [contributors](CONTRIBUTORS.md) who participated in this project.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- MongoDB team for the excellent database
- All open-source package maintainers
- Material Design team for the design guidelines
- Stack Overflow community for troubleshooting help

---

## 📞 Support & Contact

### Getting Help

- **Documentation**: Read this README and check the [FEATURES.md](frontend/FEATURES.md)
- **Issues**: Open an issue on [GitHub Issues](https://github.com/yourusername/todo-app/issues)
- **Discussions**: Join our [GitHub Discussions](https://github.com/yourusername/todo-app/discussions)

### Contact

- **Email**: support@yourapp.com
- **Website**: https://yourapp.com
- **Twitter**: [@yourapp](https://twitter.com/yourapp)

---

## 📊 Project Statistics

- **Frontend Lines of Code**: 6000+
- **Backend Lines of Code**: 400+
- **Total Features**: 75+
- **Total Files**: 60+
- **Supported Platforms**: Android, iOS
- **Database Tables**: 3 (SQLite) + 2 (MongoDB)
- **Reusable Widgets**: 17+
- **Utility Functions**: 20+
- **State Providers**: 3
- **API Endpoints**: 4

---

## 🔗 Related Projects & Resources

### Similar Projects
- [Google Tasks](https://play.google.com/store/apps/details?id=com.google.android.apps.tasks)
- [Todoist](https://todoist.com/)
- [Microsoft To Do](https://todo.microsoft.com/)

### Learning Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Node.js Documentation](https://nodejs.org/docs/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [Material Design 3](https://m3.material.io/)

### Tools Used
- [VS Code](https://code.visualstudio.com/)
- [Android Studio](https://developer.android.com/studio)
- [Postman](https://www.postman.com/)
- [MongoDB Compass](https://www.mongodb.com/products/compass)
- [Git](https://git-scm.com/)

---

## 📝 Additional Documentation

For more detailed information, please check:

- **[FEATURES.md](frontend/FEATURES.md)** - Complete feature list with 75+ features
- **[PROJECT_SUMMARY.md](frontend/PROJECT_SUMMARY.md)** - Project overview and statistics
- **[CHANGELOG.md](frontend/CHANGELOG.md)** - Version history and changes
- **[CONTRIBUTORS.md](frontend/CONTRIBUTORS.md)** - List of contributors

---

## 🎯 Quick Start Guide

### For Developers

1. **Clone the repository**
2. **Setup Backend**: Install Node.js dependencies, configure MongoDB
3. **Setup Frontend**: Install Flutter dependencies
4. **Configure**: Update API endpoints and database connections
5. **Run**: Start backend server, then run Flutter app
6. **Test**: Create account, add tasks, test features

### For Users

1. **Download** the app from Play Store / App Store (when published)
2. **Install** on your device
3. **Create Account** or use offline mode
4. **Start** organizing your tasks!

---

## 🔐 Security

### Reporting Security Issues

If you discover a security vulnerability, please email security@yourapp.com. Do not create a public GitHub issue.

### Security Best Practices

- Passwords are hashed using bcrypt with 10 salt rounds
- JWT tokens expire after 1 hour
- All API endpoints should use HTTPS in production
- Database credentials should be stored in environment variables
- Never commit sensitive data to version control

---

## 💡 Tips & Tricks

### Backend Tips
- Use environment variables for sensitive data
- Implement rate limiting to prevent abuse
- Add request validation middleware
- Use MongoDB indexes for better query performance
- Implement proper error handling and logging

### Frontend Tips
- Use `const` constructors for better performance
- Implement pagination for large task lists
- Cache images and assets
- Use `FutureBuilder` and `StreamBuilder` efficiently
- Test on both Android and iOS devices
- Optimize database queries with proper indexes

---

## 🎨 Design Philosophy

This application follows these design principles:

- **Offline-First**: Works seamlessly without internet connection
- **User-Centric**: Intuitive UI/UX with Material Design 3
- **Performance**: Optimized for speed and efficiency
- **Scalability**: Clean architecture for easy maintenance
- **Accessibility**: Follows accessibility guidelines
- **Privacy**: User data stays on device (offline mode)

---

## 📱 Platform Support

### Current Support
- ✅ Android 5.0+ (API 21)
- ✅ iOS 11.0+

### Future Support
- 🔜 Web (PWA)
- 🔜 macOS
- 🔜 Windows
- 🔜 Linux

---

<div align="center">

**⭐ Star this repository if you find it helpful! ⭐**

Made with ❤️ using Flutter and Node.js

[Report Bug](https://github.com/yourusername/todo-app/issues) · [Request Feature](https://github.com/yourusername/todo-app/issues) · [Documentation](https://github.com/yourusername/todo-app/wiki)

---

### Show your support

Give a ⭐️ if this project helped you!

</div>
