# 🎉 Quark '26 – Official Campus Fest Mobile Application

A cross-platform Flutter application developed for **Quark '26**, the annual technical festival, providing participants with a unified platform to explore events, access rulebooks, make payments, view galleries, and manage digital gate passes.

---

# 📖 Overview

The Quark '26 mobile application serves as a one-stop solution for festival attendees by bringing together event discovery, digital payments, sponsor information, media galleries, and gate pass management into a single intuitive interface.

The application follows a modular Flutter architecture, making it scalable and easy to maintain while delivering a seamless cross-platform experience on Android, iOS, Web, Windows, Linux, and macOS.

---

# ✨ Features

- Secure user authentication
- Event browsing and categorization
- Digital rulebooks
- QR-based payment workflow
- PIN-protected wallet
- Transaction history
- Event galleries
- Aftermovie section
- Digital gate pass
- Sponsor showcase
- Contact information
- Cross-platform support

---

# 📂 Project Structure

```text
lib/
│
├── Screens/
│   ├── Homepage/
│   ├── Events/
│   ├── Gallery/
│   ├── Sponsors/
│   ├── ContactUs/
│   ├── Rulebook/
│   ├── Aftermovie/
│   ├── Payments/
│   ├── Login.dart
│   ├── entry.dart
│   └── gate_pass_screen.dart
│
├── Services/
│   ├── config.dart
│   ├── payments.dart
│   └── permissions.dart
│
├── Widgets/
│   ├── EventCard.dart
│   ├── EventTab.dart
│   ├── homepageCard.dart
│   └── credit_card.dart
│
├── Models/
│   ├── events.dart
│   └── transaction.dart
│
└── main.dart
```

---

# ⚙️ Workflow

## User Authentication

Users log in to access festival services and personalized features.

↓

## Homepage

The homepage acts as the central navigation hub, providing quick access to all modules.

↓

## Event Discovery

Participants can

- Browse events
- View event details
- Read competition information
- Access official rulebooks

↓

## Payments

The payment module allows users to

- Set a secure PIN
- Scan QR codes
- Enter payment amount
- Confirm transactions
- View transaction history
- Reset payment PIN

↓

## Digital Gate Pass

Users can generate and access their digital entry pass for the event.

↓

## Additional Modules

- Gallery
- Aftermovie
- Sponsors
- Contact Information

---

# 🏗️ Application Architecture

```text
                  Flutter App

                      │
      ┌───────────────┼───────────────┐
      ▼               ▼               ▼

 Authentication     Homepage      Navigation

      │               │               │
      ▼               ▼               ▼

 Events         Payments        Media Modules

      │               │               │
      ▼               ▼               ▼

 Rulebook      QR Scanner      Gallery

                      │
                      ▼

              Transaction History

                      │
                      ▼

                Digital Gate Pass
```

---

# 🛠️ Technologies Used

| Category | Technologies |
|-----------|--------------|
| Framework | Flutter |
| Language | Dart |
| Platforms | Android, iOS, Web, Windows, Linux, macOS |
| Backend Services | Firebase |
| Payments | QR Code-based Payment Module |
| Development Tools | VS Code, Git |

---

# 📱 Modules

### 🏠 Homepage

- Central navigation
- Featured events
- Quick access cards

---

### 🎯 Events

- Browse competitions
- Event information
- Event categories

---

### 📖 Rulebook

- Competition guidelines
- Rules and regulations

---

### 💳 Payments

- QR Scanner
- Secure PIN
- Payment confirmation
- Transaction history
- PIN reset

---

### 🎫 Gate Pass

- Digital event entry
- Quick verification

---

### 🖼️ Gallery

- Festival images
- Event highlights

---

### 🎬 Aftermovie

- Official event recap videos

---

### 🤝 Sponsors

- Sponsor showcase
- Partnership information

---

### 📞 Contact Us

- Organizing committee contacts

---

# 🚀 Future Improvements

- Push notifications
- Live event schedules
- Real-time leaderboard
- Event registration
- In-app chat
- Attendance tracking
- Offline support
- Dark mode

---

# 📷 Screenshots

Add screenshots for:

- Login Screen
- Homepage
- Event Listing
- Payments
- QR Scanner
- Gallery
- Gate Pass

---

# 👨‍💻 Author

**Karan Pote**

Developed as part of the Quark '26 organizing team to provide a modern, cross-platform mobile application for event management, digital payments, and participant engagement.

Used during Quark '26 to support festival participants with event information, digital payments, and gate pass management.
