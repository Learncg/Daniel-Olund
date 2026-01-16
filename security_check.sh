#!/bin/bash

# ==========================================================
# Script name: security_check.sh
# Description: Automated security checks for Linux systems
# Author: Automationsingenjör IT-säkerhet
# ==========================================================

LOGFILE="/var/log/security_check.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

log_message() {
    echo "$DATE - $1" | tee -a "$LOGFILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_message "ERROR: Script must be run as root."
        exit 1
    fi
}

check_file_permissions() {
    log_message "Checking critical file permissions..."
    FILES=("/etc/passwd" "/etc/shadow" "/etc/ssh/sshd_config")

    for file in "${FILES[@]}"; do
        if [[ -f "$file" ]]; then
            perms=$(stat -c "%a" "$file")
            log_message "File: $file Permissions: $perms"
        else
            log_message "WARNING: $file not found"
        fi
    done
}

check_auth_logs() {
    log_message "Analyzing authentication logs..."
    if [[ -f /var/log/auth.log ]]; then
        grep "Failed password" /var/log/auth.log | tail -n 5 | tee -a "$LOGFILE"
    else
        log_message "WARNING: auth.log not found"
    fi
}

check_updates() {
    log_message "Checking available updates..."
    apt update -qq
    updates=$(apt list --upgradable 2>/dev/null | wc -l)
    log_message "Number of available updates: $updates"
}

main() {
    check_root
    log_message "Security check started"
    check_file_permissions
    check_auth_logs
    check_updates
    log_message "Security check completed"
}

main
