# Secure Time Synchronization 

A Windows/Powershell port of [Madaidan's secure-time-sync](https://gitlab.com/madaidan/secure-time-sync)

To use the script, download it, and run it as an Administrator. If you run it as a Standard Windows user, it will self-elevate, and ask for permission to do so.

    .\secure-time-sync.ps1

The script extracts the current UTC time from HTTP headers after connecting to a website.

The websites used are:
+ Whonix
+ DuckDuckGo
+ The Tor Project

The -URL parameter can also be used to specify a custom website. For example: 
    
    .\secure-time-sync.ps1 -URL https://google.com

To sync time regularly, add the script to Task Scheduler. A setup script for this will be added in the future.

# NTP

NTP is fundamentally insecure, and should be avoided; [Madaidan's article](https://madaidans-insecurities.github.io/guides/linux-hardening.html#time-synchronisation) explains why in more detail.