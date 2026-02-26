# 🚨 CrashBot — AI-Powered Android Crash Triage Automation

AI-powered Android crash triage automation using **Firebase Crashlytics**, **BigQuery**, **n8n**, **Ollama (llama3.1)**, and **Slack** for near real-time root cause analysis and fix suggestions.

---

## 📌 Problem Statement

In many product teams, **Firebase Crashlytics** collects thousands of crash events daily.

However:

* Engineers must manually inspect crash groups
* Root cause analysis is time-consuming
* Important crashes may be overlooked
* Repetitive triaging wastes engineering time
* There is no automatic technical explanation or fix suggestion

As crash volume increases, manual triage becomes inefficient and reactive.

---

## 🎯 Objective

Build an automated system that:

* Detects new crashes in near real-time
* Analyzes stack traces using AI
* Generates technical root cause analysis
* Suggests concrete fixes
* Proposes regression tests
* Posts structured alerts directly to Slack
* Avoids duplicate notifications

All without manual intervention.

---

## 🏗️ System Architecture

```
Firebase Crashlytics
        ↓
BigQuery Export
        ↓
n8n (Cron Trigger - 1 min)
        ↓
Ollama (llama3.1 Local LLM)
        ↓
Slack Alert
        ↓
Data Store (Deduplication)
```

---

## ⚙️ How It Works

### 1️⃣ Crash Export

Firebase Crashlytics exports crash data to **BigQuery**.

---

### 2️⃣ Scheduled Polling

n8n runs every 1 minute using a Cron trigger.

It:

* Fetches crashes newer than the last processed timestamp
* Groups by `issue_id`
* Retrieves metadata (device, OS, app version, stack trace)
* Stores last processed timestamp in Data Store

---

### 3️⃣ AI Crash Analysis

Crash data is sent to **Ollama (llama3.1)** running locally.

The model:

* Analyzes stack traces
* Infers probable root cause
* Suggests Android/Kotlin-specific fixes
* Generates reproduction steps
* Proposes regression test ideas
* Returns structured JSON

---

### 4️⃣ Normalization Layer

A transformation step ensures:

* Consistent formatting
* Handling of string/array variations
* Slack-friendly output formatting
* Fault tolerance if AI returns inconsistent schema

---

### 5️⃣ Slack Alert

CrashBot posts structured Slack alerts including:

* Issue metadata
* Root cause
* Why it happened
* Recommended fixes
* Reproduction steps
* Regression tests
* Confidence score

Example:

```
🚨 CrashBot Alert

🔥 Issue: Fatal Exception @ MainActivity.kt
📱 Device: Pixel 3 XL
🤖 Android: 12
📦 App Version: 1.0
📊 Occurrences: 51

🧠 Root Cause
NullPointerException inside Compose lambda

🛠️ Recommended Fixes
• Add null checks before accessing object
• Use safe call operator (?.)

🎯 Confidence: 0.85
```

---

## 🔁 Deduplication Strategy

To prevent duplicate alerts:

* `crashbot_last_seen_ms` is stored in n8n Data Store
* Only crashes newer than last timestamp are processed
* Each `issue_id` is tracked

This ensures:

* No repeated Slack spam
* Efficient incremental processing

---

## 🧠 Why This Matters

CrashBot transforms raw crash logs into:

> Structured engineering insights.

Instead of manually reading stack traces, engineers receive:

* AI-generated root cause explanations
* Suggested fixes
* Test recommendations

This reduces MTTR (Mean Time To Resolution) and improves team efficiency.

---

## 🛠️ Tech Stack

* Firebase Crashlytics
* BigQuery
* n8n (Workflow automation)
* Ollama (Local LLM – llama3.1)
* Slack API
* Google Data Store (n8n built-in)

---

## 📂 Repository Structure

```
crashbot-ai-triage/
│
├── workflow/
│   └── crashbot-workflow.json
│
├── sql/
│   └── crash_query.sql
│
├── prompts/
│   └── crash_analysis_prompt.txt
│
├── slack/
│   └── slack_template.txt
│
├── docs/
│   └── architecture.png
│
└── README.md
```

---

## ▶️ How To Run

1. Enable Crashlytics BigQuery export
2. Install and run n8n
3. Install Ollama and pull llama3.1
4. Import the workflow JSON into n8n
5. Configure Slack credentials
6. Start workflow

---

## 🎥 Demo Video

📹 CrashBot-Demo.mov

The demo shows:

* Crash triggered in Android app
* Crash exported to BigQuery
* n8n detecting new crash
* AI analyzing stack trace
* Slack receiving structured alert

---

## 📈 Future Improvements

* Web dashboard for crash trends
* Automatic Jira ticket creation
* Priority scoring model
* Crash clustering improvements
* Multi-app support

---

## 👤 Author
Shakiba E Nur


