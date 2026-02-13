The following is the set of guidelines that I want to follow while trying to write a systemd service file. 
## The following are the best practises for RDK

### 1. 

### 2. ✅ Use Absolute Paths for Executables and Files
**Always** specify full absolute paths in directives like `ExecStart` to avoid reliance on environment variables like `$PATH`, which systemd does not inherit.

**Check for:**
- All `ExecStart`, `ExecStartPre`, `ExecStartPost`, `ExecStop`, `ExecReload` use absolute paths
- No relative paths or commands without full paths

**Example:**
```ini
[Service]
ExecStart=/usr/bin/mydaemon --option
