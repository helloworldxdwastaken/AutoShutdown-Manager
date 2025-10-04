-- AutoShutdown Complete - All-in-One App
-- Contains installer, remover, and menu interface in one file

on run
    set menuChoice to choose from list {"Install AutoShutdown", "Remove AutoShutdown", "Check Status", "Quit"} with prompt "AutoShutdown Manager" default items {"Check Status"}
    
    if menuChoice is false then return -- User cancelled
    
    set choice to item 1 of menuChoice
    
    if choice is "Install AutoShutdown" then
        installAutoShutdown()
    else if choice is "Remove AutoShutdown" then
        removeAutoShutdown()
    else if choice is "Check Status" then
        checkStatus()
    else if choice is "Quit" then
        return
    end if
end run

-- Install AutoShutdown function
on installAutoShutdown()
    try
        -- Create scripts directory
        do shell script "mkdir -p ~/scripts"
        
        -- Create the AppleScript file
        set appleScriptContent to "-- ~/scripts/autoshutdown.applescript
-- Popup at 23:00; if ignored for 60s -> shutdown. You can Cancel or Postpone 30 min.

set timeoutSecs to 60
set d to display dialog ¬
  \"It's 23:00. Your Mac will shut down in \" & timeoutSecs & \" seconds unless you cancel or postpone.\" ¬
  buttons {\"Shut Down Now\", \"Postpone 30 min\", \"Cancel\"} ¬
  default button \"Cancel\" ¬
  giving up after timeoutSecs
-- If user ignored the dialog (timed out):
if gave up of d then
  do shell script \"sudo shutdown -h now\"
else
  set btn to button returned of d
  if btn is \"Shut Down Now\" then
    do shell script \"sudo shutdown -h now\"
  else if btn is \"Postpone 30 min\" then
    do shell script \"nohup bash -lc 'sleep 1800; sudo shutdown -h now' >/dev/null 2>&1 &\"
    -- Cancel does nothing
  end if
end if"
        
        do shell script "cat > ~/scripts/autoshutdown.applescript << 'EOF'
" & appleScriptContent & "
EOF"
        
        -- Create the LaunchAgent plist
        set plistContent to "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key><string>com.user.autoshutdown</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/osascript</string>
    <string>~/scripts/autoshutdown.applescript</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key><integer>23</integer>
    <key>Minute</key><integer>0</integer>
  </dict>
  <key>RunAtLoad</key><false/>
  <key>KeepAlive</key><false/>
  <key>StandardOutPath</key><string>/tmp/com.user.autoshutdown.out</string>
  <key>StandardErrorPath</key><string>/tmp/com.user.autoshutdown.err</string>
</dict>
</plist>"
        
        do shell script "cat > ~/Library/LaunchAgents/com.user.autoshutdown.plist << 'EOF'
" & plistContent & "
EOF"
        
        -- Load the LaunchAgent
        do shell script "launchctl unload ~/Library/LaunchAgents/com.user.autoshutdown.plist >/dev/null 2>&1 || true"
        do shell script "launchctl load ~/Library/LaunchAgents/com.user.autoshutdown.plist"
        
        display dialog "✅ AutoShutdown installed successfully!

Your Mac will now show a shutdown prompt every day at 11:00 PM." buttons {"OK"} default button "OK" with icon note
        
    on error errMsg
        display dialog "❌ Installation failed:

" & errMsg buttons {"OK"} default button "OK" with icon caution
    end try
end installAutoShutdown

-- Remove AutoShutdown function
on removeAutoShutdown()
    try
        -- Unload LaunchAgent
        do shell script "launchctl unload ~/Library/LaunchAgents/com.user.autoshutdown.plist >/dev/null 2>&1 || true"
        
        -- Remove files
        do shell script "rm -f ~/Library/LaunchAgents/com.user.autoshutdown.plist ~/scripts/autoshutdown.applescript"
        
        display dialog "🧹 AutoShutdown removed successfully!

Your Mac will no longer automatically shut down." buttons {"OK"} default button "OK" with icon note
        
    on error errMsg
        display dialog "❌ Removal failed:

" & errMsg buttons {"OK"} default button "OK" with icon caution
    end try
end removeAutoShutdown

-- Check Status function
on checkStatus()
    try
        set status to do shell script "launchctl list | grep autoshutdown || echo 'Not installed'"
        if status contains "com.user.autoshutdown" then
            display dialog "✅ AutoShutdown is ACTIVE

Will show shutdown prompt at 11:00 PM daily.

Force shutdown enabled - will close all apps without saving." buttons {"OK"} default button "OK" with icon note
        else
            display dialog "❌ AutoShutdown is NOT installed

Click 'Install AutoShutdown' to set it up." buttons {"OK"} default button "OK" with icon caution
        end if
    on error
        display dialog "❌ AutoShutdown is NOT installed" buttons {"OK"} default button "OK" with icon caution
    end try
end checkStatus
