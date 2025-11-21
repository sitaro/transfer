# --- PARAMETER ANPASSEN ---
$DomainNamePart = "mathops" # Teil des Namens Ihrer Domäne
$ExportPath = "C:\Temp\AD_Root_CA.cer"
# -------------------------

# Sucht in ALLEN lokalen Speichern nach selbstsignierten Root-Zertifikaten
# (Dies schließt 'Persönlich', 'Root', 'CA', etc. ein)
$AllRootCerts = Get-ChildItem -Path Cert:\LocalMachine -Recurse |
    Where-Object { $_.Issuer -eq $_.Subject -and $_.Subject -like "*$DomainNamePart*" } |
    Select-Object -First 1 # Nur das erste Ergebnis nehmen

if ($AllRootCerts) {
    # Exportieren, wenn gefunden
    $AllRootCerts | Export-Certificate -FilePath $ExportPath -Type CERT -Force
    
    Write-Host "`n✅ Internes Root-Zertifikat gefunden und exportiert!"
    Write-Host "   Gefundener Speicherort: $($AllRootCerts.PSParentPath)"
    Write-Host "   Zertifikat Betreff: $($AllRootCerts.Subject)"
    Write-Host "   Exportiert nach: $ExportPath"
}
else {
    Write-Error "Das interne Root-Zertifikat konnte nicht gefunden werden. Bitte prüfen Sie, ob die CA auf diesem Server installiert ist und die Web-Enrollment-Methode (`http://<PDC-Name>/certsrv/`) verfügbar ist."
}