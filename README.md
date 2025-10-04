# 🌙 AutoShutdown Manager

A simple tool to automatically shut down your computer at 10:00 PM daily, helping you maintain a consistent bedtime routine.

## ✨ Features

- **Daily shutdown** at 10:00 PM (22:00)
- **System warning dialog** with 8+ minutes to cancel
- **Works with locked screens** - even when your computer is locked or sleeping
- **Easy installation/removal** with simple menu interface
- **Cross-platform** - works on both macOS and Windows

## 🚀 Quick Start

### For macOS Users
1. Open the `macOS` folder
2. Double-click `AutoShutdown Manager.applescript`
3. Choose "Install AutoShutdown" from the menu
4. Enter your admin password when prompted
5. Done! Your Mac will now shut down at 10:00 PM daily

### For Windows Users
1. Open the `Windows` folder
2. Double-click `AutoShutdown Manager.bat`
3. Choose "1. Install AutoShutdown" from the menu
4. Done! Your PC will now shut down at 10:00 PM daily

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

### At 10:00 PM Daily:
1. **System dialog appears** with shutdown warning
2. **8+ minute countdown** gives you time to react
3. **Options available:**
   - **"Shut Down"** → Immediate shutdown
   - **"Cancel"** → Cancels shutdown for tonight
4. **If ignored** → Automatic shutdown after countdown

### Key Features ✅
- **Works when locked** - even if your screen is locked, the system will show the shutdown dialog
- **Works when sleeping** - computer will wake up to show the warning
- **System-level** - uses native power management (pmset on macOS, Task Scheduler on Windows)
- **Reliable** - no issues with user sessions or permissions

## 🛠️ Management

### Check Status
- **macOS**: Run the app and choose "Check Status"
- **Windows**: Run the app and choose "3. Check Status"

### Remove AutoShutdown
- **macOS**: Run the app and choose "Remove AutoShutdown"
- **Windows**: Run the app and choose "2. Remove AutoShutdown"

## 🔧 Technical Details

### macOS
- Uses **pmset (Power Management)** for scheduling
- Command: `pmset repeat shutdown MTWRFSU 22:00:00`
- System-level shutdown schedule (works with locked screens)
- Shows native macOS shutdown dialog

### Windows
- Uses **Task Scheduler** for scheduling
- Creates `C:\Scripts\AutoShutdown.ps1`
- Creates scheduled task named "AutoShutdown" with `-WakeToRun` parameter
- Wakes computer from sleep to execute shutdown

## 📝 Notes

- **First run** requires administrator privileges
- **macOS**: Uses system power management (pmset)
- **Windows**: Uses Task Scheduler with wake-from-sleep capability
- **Cancel button** in the dialog allows you to stop the shutdown
- **Works reliably** with locked screens and sleep mode

## 🆘 Troubleshooting

### macOS
- If installation fails, make sure to enter your admin password when prompted
- Check if schedule is set: `pmset -g sched`
- To manually remove: `sudo pmset schedule cancel`

### Windows
- If `.bat` file doesn't work, try right-clicking `.ps1` file → "Run with PowerShell"
- Check if scheduled task exists: Open Task Scheduler and look for "AutoShutdown"
- Make sure task has "Wake the computer to run this task" enabled

---

**Happy sleeping! 😴**
