"""
Script name: log_analysis.py
Description: Log analysis and anomaly detection
Author: Automationsingenjör IT-säkerhet
"""

import datetime

LOGFILE = "security_report.txt"
FAILED_THRESHOLD = 5

def log(message):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOGFILE, "a") as f:
        f.write(f"{timestamp} - {message}\n")

def analyze_logfile(logfile_path):
    failed_logins = 0

    try:
        with open(logfile_path, "r") as logfile:
            for line in logfile:
                if "Failed password" in line or "failed login" in line.lower():
                    failed_logins += 1
    except FileNotFoundError:
        log(f"ERROR: Log file {logfile_path} not found")
        return

    log(f"Failed login attempts detected: {failed_logins}")

    if failed_logins >= FAILED_THRESHOLD:
        log("WARNING: Potential brute-force attack detected")

def generate_report():
    log("Security log analysis completed")

def main():
    log("Log analysis started")
    analyze_logfile("system.log")
    generate_report()

if __name__ == "__main__":
    main()
