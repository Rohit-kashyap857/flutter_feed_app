# 🚀 Flutter Feed App 

A high-performance social media feed built using **Flutter + Riverpod**, designed with **production-level architecture, performance optimization, and real-world UX patterns**.

---

## 📱 Demo

https://drive.google.com/file/d/1nJoxVQgWilJPMzS65tbaCUsOx4jHWMg3/view

---

## 🔥 Features

### 📌 Core Features

* ✅ Infinite Scrolling (Pagination with limit = 10)
* ✅ Pull-to-Refresh
* ✅ REST API Integration (No WebSockets)

### ⚡ Performance Optimization

* 🚀 GPU Optimization using `RepaintBoundary`
* 🚀 Smooth scrolling with minimal frame drops
* 🚀 Selective rebuilds using Riverpod `.select()`

### 💾 Memory Optimization

* 🧠 Optimized image loading using `memCacheWidth`
* 🧠 Prevents Out Of Memory (OOM) crashes

### 🎬 UI & UX

* ✨ Beautiful card UI with heavy shadows
* ✨ Hero Animation (Feed → Detail screen)
* ✨ Animated Like button

### 🖼️ Tiered Image Loading

* 🟢 Thumbnail → instant load
* 🟡 Mobile (1080p) → auto upgrade
* 🔴 Raw image → loaded on demand

### ❤️ Optimistic UI

* ⚡ Instant like/unlike response
* 🔄 Background API sync
* 🔁 Rollback on failure (offline safe)

---

## 🧪 Edge Case Handling (Phase 4)

* 🛡️ Spam click protection (debounce + lock system)
* 📶 Offline handling with UI rollback
* 🔁 Prevent duplicate API calls
* ⚡ Smooth performance during rapid scrolling
* 🧠 Memory-safe list rendering

---

## 🧠 Tech Stack

* **Flutter**
* **Riverpod (State Management)**
* **Supabase (Backend / RPC)**
* **CachedNetworkImage**

---

## 📁 Project Structure

```
lib/
│
├── core/
│   ├── models/
│   ├── services/
│   └── utils/
│
├── features/
│   └── feed/
│       ├── provider/
│       ├── screens/
│       └── widgets/
│
└── main.dart
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the repository

```
git clone https://github.com/your-username/flutter-feed-app.git
cd flutter-feed-app
```

### 2️⃣ Install dependencies

```
flutter pub get
```

### 3️⃣ Run the app

```
flutter run
```

---

## 📌 Key Learnings

* Efficient state management using Riverpod
* Handling large lists without performance issues
* GPU & memory optimization techniques in Flutter
* Real-world UX patterns (Optimistic UI)
* Robust error and edge case handling

---

## 🎯 Future Improvements

* 🔄 Add caching layer for offline feed
* 🌐 Better error UI & retry system
* 🎥 Video/media support
* 🔔 Notifications system

---

## 🙌 Author

**Rohit Kashyap**
