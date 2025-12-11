# Academic Assessment System (Faculty App)

Local, offline classroom feedback app implemented in Flutter.

## Features
- First-run faculty onboarding (save name locally)
- Start a local session; server serves student page via local network
- Students submit name, roll, and A/B/C/D understanding
- Real-time dashboard on faculty device (via WebSocket)
- Sessions saved as JSON files under device storage

## How to run
1. flutter pub get
2. Configure Android permissions if needed (see AndroidManifest)
3. Build and install on Android device on same Wi-Fi network as students
4. Start app → enter name → create session → share link

## Storage
Session JSON files are stored in device external/app directory:
`/storage/emulated/0/Android/data/<package>/files/AcademicAssessment/`

## Notes
- No cloud or external backend used.
- Network requires both devices on same LAN.

# 📘 **Academic Assessment System – Firebase Version**

A modern, real-time **student feedback collection system** built with **Flutter**, **Firebase Firestore**, and **Firebase Hosting**.
This application allows faculty to create assessment sessions, share a link with students, and view responses live on a dashboard.

---

## 🚀 **Features**

### 👨‍🏫 **Faculty App (Flutter)**

* Create new assessment sessions
* Automatically generates a shareable session link
* View real-time student responses (A/B/C/D)
* Live pie-chart visualization
* End & archive sessions
* View session history
* All data stored securely in Firebase Firestore

---

### 🎓 **Student Page (Web – Firebase Hosting)**

* Accessible from **mobile/desktop browser**
* Students submit:

  * Name
  * Roll number
  * Understanding level (A/B/C/D)
* Directly writes responses into Firestore
* Works globally without needing local servers

---

## 🧱 **Tech Stack**

### **Frontend (App)**

* Flutter 3.x
* Material 3 UI

### **Backend & Database**

* Firebase Firestore
* Firebase Hosting (for student HTML page)
* Firebase Core

### **Storage**

* Firestore collection structure:

```
sessions/
   {sessionId}/
      topic
      faculty
      ended
      createdAt
      responses/
          {responseId}/
              name
              roll
              level
              timestamp
```

---

## 🗂 **Project Folder Structure**

```
lib/
 ├── models/
 │    ├── session.dart
 │    └── response.dart
 ├── services/
 │    ├── firebase_session_service.dart
 │    └── local_prefs.dart
 ├── ui/
 │    ├── onboarding_page.dart
 │    ├── create_session_page.dart
 │    ├── dashboard_page.dart
 │    └── history_page.dart
 ├── widgets/
 │    ├── simple_pie_chart.dart
 │    └── response_tile.dart
 ├── app.dart
 └── main.dart

hosting/
 ├── student_page.html
 └── firebase.json
```

---

## 🔥 **How It Works**

### 1️⃣ **Faculty creates session**

App → Firestore:

```
sessions/{id}
```

### 2️⃣ **App generates public link**

Example:

```
https://academic-assessment-system.web.app/student_page.html?session=SESSION_ID
```

### 3️⃣ **Students submit responses**

HTML → Firestore:

```
sessions/{id}/responses/{response}
```

### 4️⃣ **Dashboard displays real-time updates**

Using Firestore `.snapshots()` stream.

---

## 📦 Installation & Run Instructions

### **1. Install dependencies**

```
flutter pub get
```

### **2. Run the app**

```
flutter run
```

---

## 🌐 Deploy Student Page to Firebase Hosting

```
firebase deploy --only hosting
```

Hosting URL (example):

```
https://academic-assessment-system.web.app
```

---

## 📜 License

This project is for educational use and may be extended freely.

---

## ❤️ Contribution

Feel free to open issues or create pull requests.
