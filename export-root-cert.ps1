# --- PARAMETER ANPASSEN ---
$CAName = "mathops"  # Teil des Namens Ihrer Zertifizierungsstelle
$ExportPath = "C:\Temp\AD_Root_CA.cer"
# -------------------------

# 1. Root-Zertifikate aus dem Speicher abrufen
# Filtert nach Zertifikaten im Root-Store, die sich selbst ausgestellt haben (Root-Zertifikate)
# und deren Name den Parameter $CAName enthält.
$RootCert = Get-ChildItem -Path Cert:\LocalMachine\Root |
    Where-Object { $_.Issuer -eq $_.Subject -and $_.Subject -like "*$CAName*" }

# 2. Prüfen, ob ein eindeutiges Zertifikat gefunden wurde
if ($RootCert.Count -eq 0) {
    Write-Error "Fehler: Es wurde kein passendes Root-Zertifikat mit '$CAName' gefunden."
}
elseif ($RootCert.Count -gt 1) {
    Write-Error "Fehler: Es wurden mehrere passende Zertifikate gefunden. Bitte Namen ($CAName) spezifischer wählen."
    $RootCert | Select-Object Subject, NotAfter
}
else {
    # 3. Zertifikat im Base64-Format exportieren (.cer)
    # Die Methode Export() speichert das Zertifikat im gewünschten CER-Format.
    $RootCert | Export-Certificate -FilePath $ExportPath -Type CERT -Force
    
    Write-Host "`n✅ Export erfolgreich:"
    Write-Host "   Zertifikat: $($RootCert.Subject)"
    Write-Host "   Gültig bis: $($RootCert.NotAfter)"
    Write-Host "   Exportiert nach: $ExportPath"
}