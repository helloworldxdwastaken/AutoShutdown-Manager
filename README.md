# 🌙 AutoShutdown Manager

A simple tool to automatically shut down your computer at 11:00 PM daily, helping you maintain a consistent bedtime routine.

## ✨ Features

- **Daily shutdown reminder** at 11:00 PM
- **60-second countdown** with options to cancel or postpone
- **Force shutdown** - closes all applications without saving
- **Easy installation/removal** with simple menu interface
- **Cross-platform** - works on both macOS and Windows

## 🚀 Quick Start

### For macOS Users
1. Open the `macOS` folder
2. Double-click `AutoShutdown Manager.applescript`
3. Choose "Install AutoShutdown" from the menu
4. Done! Your Mac will now prompt you to shut down at 11:00 PM daily

### For Windows Users
1. Open the `Windows` folder
2. Double-click `AutoShutdown Manager.bat`
3. Choose "1. Install AutoShutdown" from the menu
4. Done! Your PC will now prompt you to shut down at 11:00 PM daily

## 📁 File Structure

```
AutoShutdown Manager/
├── README.md                           # This file
├── macOS/
│   └── AutoShutdown Manager.applescript # macOS installer/manager
└── Windows/
    ├── AutoShutdown Manager.bat        # Windows installer/manager (easy)
    └── AutoShutdown Manager.ps1        # Windows installer/manager (PowerShell)
```

## 🎯 How It Works

### At 11:00 PM Daily:
1. **Dialog appears** with 60-second countdown
2. **Options available:**
   - **"Shut Down Now"** → Immediate force shutdown
   - **"Postpone 30 min"** → Delays shutdown by 30 minutes
   - **"Cancel"** → Cancels shutdown for tonight
3. **If ignored** → Automatic force shutdown after 60 seconds

### Force Shutdown Warning ⚠️
- **Closes all applications** without saving
- **May cause data loss** if you have unsaved work
- **Use "Cancel"** if you need to save your work

## 🛠️ Management

### Check Status
- **macOS**: Run the app and choose "Check Status"
- **Windows**: Run the app and choose "3. Check Status"

### Remove AutoShutdown
- **macOS**: Run the app and choose "Remove AutoShutdown"
- **Windows**: Run the app and choose "2. Remove AutoShutdown"

## 🔧 Technical Details

### macOS
- Uses **LaunchAgents** for scheduling
- Creates `~/scripts/autoshutdown.applescript`
- Creates `~/Library/LaunchAgents/com.user.autoshutdown.plist`

### Windows
- Uses **Task Scheduler** for scheduling
- Creates `C:\Scripts\AutoShutdown.ps1`
- Creates scheduled task named "AutoShutdown"

## 📝 Notes

- **First run** may require administrator privileges
- **Force shutdown** bypasses application save prompts
- **Postpone option** gives you 30 extra minutes
- **Cancel option** only works for that night (will prompt again tomorrow)

## 🆘 Troubleshooting

### macOS
- If installation fails, try running from Terminal: `osascript "AutoShutdown Manager.applescript"`
- Check if LaunchAgent is loaded: `launchctl list | grep autoshutdown`

### Windows
- If `.bat` file doesn't work, try right-clicking `.ps1` file → "Run with PowerShell"
- Check if scheduled task exists: Open Task Scheduler and look for "AutoShutdown"

---

**Happy sleeping! 😴**
