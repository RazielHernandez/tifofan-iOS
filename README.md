# TifoFan App 🏆⚽

**TifoFan** is a cross-platform mobile app built with **React Native** that provides live scores, match schedules, player and team information, news, predictions, and community features for football fans — designed for the 2026 World Cup and beyond.

---

## 🚀 Features

### Live Scores & Match Info
- Real-time live scores for all matches.
- Match timelines (goals, cards, substitutions).
- Detailed match stats: possession, shots, passes, fouls.
- Notifications for match start, goals, and final results.

### Teams & Players
- Full team lists with squad, coach, and group info.
- Player profiles with position, stats, and bio.
- Favorite teams and players tracking.

### Standings & Schedule
- Group stage standings with automatic updates.
- Knockout stage bracket with visual tree.
- Calendar view for full tournament schedule.

### News & Media
- Football news feed (customizable by team or category).
- Video highlights via YouTube integration.
- Share news and media with friends.

### Predictions & Gamification
- Predict match outcomes or exact scores.
- Earn points and badges for correct predictions.
- Leaderboards for global and friends-only ranking.

### Fan Community
- Match-specific comments.
- Global fan feed with polls and trivia quizzes.
- Emoji reactions and discussion features.

### User Profile & Settings
- Account management (email, password, notifications).
- Theme support: light & dark mode.
- Privacy options, terms, and delete account functionality.

### Monetization & Extras
- Ad integration (banner, interstitial, rewarded ads).
- Premium subscription: ad-free experience + advanced stats.
- Affiliate shop links for official merchandise.

---

## 🏗️ Architecture

The app uses a **modular, layered architecture**:

- **UI Layer:** React Native screens and components.
- **State Management:** Zustand / Redux Toolkit + React Query.
- **Repository Layer:** Handles business logic and data caching.
- **API Layer:** Axios + TanStack Query for Football API, Weather, News, and Firebase.
- **Storage Layer:** AsyncStorage, SQLite, MMKV, and Firestore for offline and user data.
- **Services:** Firebase Cloud Messaging for notifications, analytics, and background fetch.

---

## 🛠️ Tech Stack

- **Frontend:** React Native, TypeScript, React Navigation.
- **State Management:** Zustand or Redux Toolkit, React Query.
- **API / Networking:** Axios, TanStack Query.
- **Storage:** AsyncStorage, MMKV, SQLite, Firebase Firestore.
- **Notifications:** Firebase Cloud Messaging (FCM).
- **Analytics:** Firebase Analytics.
- **Monetization:** AdMob, RevenueCat (IAPs).
- **CI/CD:** GitHub Actions, EAS Build / Fastlane.
- **Animations:** Moti / Reanimated.

---

## 📂 Project Structure (Simplified)

