# DailyFlow — Personal AI Habit & Reflection App

A **personal productivity and reflection app** built with Flutter.  
It helps you establish daily routines, write summaries, and receive AI-based encouragement —  
all in a fully local, privacy-first, and free workflow.

---

## 🌟 Features

### 🕓 1. Smart Daily Reminders
- Customizable daily notifications (e.g., “Write daily summary at 10PM”)
- Simple habit tracking and completion logging
- Local notification scheduling — no backend required

### 🧠 2. Daily Summaries & AI Feedback
- Record what you did and how you feel each day
- Get short motivational or constructive feedback from an AI (via free APIs or manual copy-paste)
- Store both your input and AI feedback for later review

### 🪴 3. Notion Integration (Lightweight)
- One-tap jump to your Notion page for long-form journaling
- Optional Notion API sync (manual or automated)
- Keeps data organized under your own Notion workspace

### 🧗 4. Activity Reflection
- Create structured reflections after activities (e.g., climbing, studying)
- AI extracts key takeaways and generates supportive feedback
- Track learning progress and growth patterns

### 🧑‍🤝‍🧑 5. Social Interaction Notes
- Record impressions and personality notes after social events
- Tag people by personality or context
- (Future) Compare keywords to find similar patterns in your social graph

---

## 🧩 Tech Stack

| Layer | Technology |
|--------|-------------|
| **Frontend** | Flutter (Dart) |
| **Data Storage** | Local SQLite (`sqflite`) |
| **Notifications** | `flutter_local_notifications` |
| **Notion Linking** | `url_launcher` |
| **AI Interaction (optional)** | Free APIs (Gemini, HuggingFace) or manual ChatGPT |
| **State Management** | `provider` / `riverpod` |
| **Platform** | Android + iOS (self-install) |

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/DailyFlow.git
cd DailyFlow
