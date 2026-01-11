//
//  build_final.sh.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 30/12/2025.
//

#!/bin/bash

cd "/Users/yaroslavyakovlev/ACoding/coding 2025/projects/Motivation"

echo "🔧 Construction de Motivation.ipa"
echo "================================="

# 1. Vérifications
if [ ! -f "ExportOptions.plist" ]; then
    echo "Création de ExportOptions.plist..."
    cat > ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOF
fi

# 2. Nettoyage
echo "🧹 Nettoyage..."
rm -rf build
mkdir build

# 3. Archive (sans provisioning d'abord pour voir)
echo "📦 Création archive..."
set -x  # Montre les commandes exécutées
xcodebuild archive \
    -project Motivation.xcodeproj \
    -scheme Motivation \
    -configuration Release \
    -archivePath build/Motivation.xcarchive \
    -destination 'generic/platform=iOS' \
    -quiet
set +x

# 4. Export
echo "📤 Export IPA..."
set -x
xcodebuild -exportArchive \
    -archivePath build/Motivation.xcarchive \
    -exportOptionsPlist ExportOptions.plist \
    -exportPath build \
    -allowProvisioningUpdates \
    -quiet
set +x

# 5. Résultat
if [ -f "build/Motivation.ipa" ]; then
    echo ""
    echo "✅ SUCCÈS!"
    echo "IPA: build/Motivation.ipa"
    echo "Taille: $(du -h build/Motivation.ipa | cut -f1)"
    open build
else
    echo ""
    echo "❌ Échec"
    echo "Contenu du dossier build:"
    ls -la build/
fi
