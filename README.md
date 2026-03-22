# Academic Assessment System 📊  
**Real-time Student Feedback Platform using Flutter & Firebase**

A modern **Flutter + Firebase** application designed to help faculty instantly assess student understanding during a lecture using live responses and analytics.

This project is suitable for:
- 🎓 **College / B.Tech Final Year Project**
- 🚀 **Startup MVP**
- 💼 **Portfolio / Resume / Recruiter Review**

---

## 🔥 Problem Statement

Traditional faculty feedback systems are:
- Delayed
- Not topic-specific
- Collected only at semester end

Faculty have **no real-time insight** into whether students understood a concept *during* the class.

---

## 💡 Solution

The **Academic Assessment System** enables:
- Instant session creation by faculty
- Public link sharing with students
- One-tap response submission (A/B/C/D)
- **Live dashboard updates**
- Secure history access (per faculty only)

---

## 🚀 Key Features

### 👨‍🏫 Faculty
- Secure login (Firebase Authentication)
- Create topic-based sessions
- Generate public shareable link
- Live response monitoring
- Visual analytics (pie chart)
- End session & view history
- Session data visible **only to owner**

### 👨‍🎓 Students
- No login required
- Open link from any browser
- Submit response instantly
- Hosted globally via Firebase Hosting

---

## 🔐 Security Architecture

| Layer | Security |
|----|----|
| Authentication | Firebase Auth |
| Database | Firestore Rules |
| Data Isolation | Faculty UID based |
| Student Access | Write-only |
| Hosting | HTTPS (Firebase) |

🔒 **Students cannot read session data**  
🔒 **Faculty can only read their own sessions**

---

## 🧠 Technology Stack

| Category | Technology |
|-------|-----------|
| Frontend | Flutter (Material 3) |
| Backend | Firebase Firestore |
| Authentication | Firebase Auth |
| Hosting | Firebase Hosting |
| Charts | Custom Flutter Widgets |
| Platform | Android, Web |

---

## 🏗️ Architecture Overview

```

Faculty App (Flutter)
│
├── Firebase Authentication
├── Firestore (sessions/{sessionId}/responses)
│
Student Web Page (HTML)
│
└── Firebase Hosting + Firestore Writes

```

---

## 🗂️ Project Structure

```

lib/
├── models/
│    ├── session.dart
│    └── response.dart
├── services/
│    ├── firebase_session_service.dart
│    └── auth_service.dart
├── ui/
│    ├── onboarding_page.dart
│    ├── create_session_page.dart
│    ├── dashboard_page.dart
│    └── history_page.dart
├── widgets/
│    ├── simple_pie_chart.dart
│    └── response_tile.dart
└── main.dart

hosting/
└── student_page.html

```

```

screenshots/
├── onboarding.png
├── create_session.png
├── dashboard.png
├── student_page.png
└── history.png

````

 ![Image Alt](https://github.com/snehith2024/academic_assessment_system_app/blob/a88889c53690aaba0c25975d719324b9b7fdf0f3/Dashboard.jpeg?raw=true) ![Image Alt](https://github.com/snehith2024/academic_assessment_system_app/blob/071dd62f8e9d93f796a4ba82fe73f79d0f2e57e9/student_feedback_data.jpeg?raw=true)


````

---

## ⚙️ Installation & Setup

### 1️⃣ Clone Repository

```bash
git clone https://github.com/your-username/academic_assessment_system_app.git
cd academic_assessment_system_app
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Firebase Setup

* Create Firebase project
* Enable:

  * Firestore
  * Authentication (Email / Google)
  * Hosting
* Add `google-services.json`
* Configure Firestore Rules
* Deploy hosting:

```bash
firebase deploy --only hosting
```

### 4️⃣ Run App

```bash
flutter run
```

---

## 📦 APK Export

```bash
flutter build apk --release
```

📍 APK Path:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎓 Academic Relevance

✔ Real-time systems
✔ Cloud computing
✔ Mobile application development
✔ Secure data handling
✔ Scalable architecture

---

## 💼 Recruiter Notes

* Uses **real-time database streams**
* Proper **authentication & access control**
* Clean architecture
* Production-ready Firebase integration
* Cross-platform Flutter app

---

## 🛠️ Future Enhancements

* QR-code based session join
* CSV / Excel export
* Attendance integration
* Role-based admin panel
* AI-based understanding analysis

---

## 📜 License

This project is created for educational and demonstration purposes.

---

Contact me on: snehith2024@gmail.com
---
