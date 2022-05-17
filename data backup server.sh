#!/bin/bash  
# Den Pfad zum Quell- und Backupverzeichnis ohne abschließenden Schrägstrich '/' angeben.  
    quelle=/pfad/quelle     # Welches Verzeichnis soll gesichert werden?  Netzwerkmount????
    backup=/pfad/backup         # Wo sollen die Sicherungen gespeichert werden?  
    nosave=/pfad/exclude.txt    # Ausschlüsse werden in dieser Datei zeilenweise eingetragen.  

    backupdevice=/dev/sdb1     # device used for backup
    mountpoint=/mnt/backup     # mount point for backup device


# Ab hier muss man eigentlich nichts mehr ändern.  
  
# Ausschlussdatei neu anlegen, nur falls noch keine existiert:  
touch $nosave  

sudo mount -o rw,user=fickdich $backupdevice $mountpoint # mount backup device

# Archive Backup to old function
function old ()
{




}

  
# Backup Funktion definieren:  
function backup ()  
{  
 rsync -av --delete --checksum --stats --exclude-from="$nosave" --link-dest="$quelle/" "$quelle/" "$backup/$1/" >"$backup/_letzte_Sicherung.txt" 2>&1  
 # alle protokollierende Standardausgaben und ggf. auftretende Fehlerausgaben (2>&1) werden in der Datei "_letzte_Sicherung.txt" gespeichert.  
 echo -e '\n'-- '\n'letzte Sicherung: $(date "+%Y-%m-%d %H:%M:%S") >> "$backup/_letzte_Sicherung.txt"  
 # Das Logfile kann während der Sicherung nicht direkt im Sicherungsordner liegen, so dass dieses im Anschluss dorthin verschoben wird.  
 mv $backup/_letzte_Sicherung.txt $backup/$1/_letzte_Sicherung_$(date "+%Y-%m-%d").txt  
 # Optional: Sicherungsprotokoll per E-Mail versenden. Ein eingerichteter MTA ([mail transfer agent](https://ctaas.de/software-raid.htm#mdadm_postfix_E-Mail_config) siehe Punkte A-I) ist Voraussetzung:  
 # mail -s "Protokoll" backup@ctaas.com <$backup/$1/_letzte_Sicherung*.txt  
}  

  backup