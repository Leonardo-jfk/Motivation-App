#!/bin/sh

#  build_ipa.sh
#  Motivation
#
#  Created by Leonardo Aurelio on 30/12/2025.
#  

## Assurez-vous d'être dans le bon dossier
#cd "$(dirname "$0")"
#
#echo "Dossier actuel: $(pwd)"
#echo "Contenu:"
#ls -la
#
## Essayez avec .xcodeproj
#if [ -d "Motivation.xcodeproj" ]; then
#    echo "✓ Projet Xcode trouvé"
#    xcodebuild -list -project Motivation.xcodeproj
#elif [ -d "Motivation.xcworkspace" ]; then
#    echo "✓ Workspace Xcode trouvé"
#    xcodebuild -list -workspace Motivation.xcworkspace
#else
#    echo "✗ Aucun projet Xcode trouvé dans $(pwd)"
#    echo "Cherchez avec: find ~ -name 'Motivation.xcodeproj' 2>/dev/null"
#fi







#!/bin/bash

# Motivation IPA Builder
# Placez ce fichier dans /Users/yaroslavyakovlev/ACoding/coding 2025/projects/Motivation/

cd "/Users/yaroslavyakovlev/ACoding/coding 2025/projects/Motivation"

echo "=== Construction IPA pour Motivation ==="
echo "📁 Dossier: $(pwd)"

# 1. Vérification
if [ ! -d "Motivation.xcodeproj" ]; then
    echo "❌ ERREUR: Motivation.xcodeproj non trouvé"
    exit 1
fi

# 2. Nettoyage du dossier build
rm -rf ./build
mkdir -p ./build

# 3. Nettoyage Xcode
echo "🧹 Nettoyage du projet..."
xcodebuild clean -project Motivation.xcodeproj \
                 -scheme Motivation \
                 -configuration Release \
                 -destination 'generic/platform=iOS'

# 4. Archive
echo "📦 Création de l'archive..."
xcodebuild archive -project Motivation.xcodeproj \
                   -scheme Motivation \
                   -configuration Release \
                   -archivePath ./build/Motivation.xcarchive \
                   -destination 'generic/platform=iOS' \
                   -allowProvisioningUpdates

# 5. Export IPA (méthode simple pour développement)
echo "📤 Export IPA..."
xcodebuild -exportArchive \
           -archivePath ./build/Motivation.xcarchive \
           -exportOptionsPlist ./ExportOptions.plist \
           -exportPath ./build \
           -allowProvisioningUpdates

# 6. Vérification
if [ -f "./build/Motivation.ipa" ]; then
    echo ""
    echo "✅ SUCCÈS ! IPA créé :"
    echo "   📍 ./build/Motivation.ipa"
    echo "   📏 Taille: $(du -h ./build/Motivation.ipa | cut -f1)"
    echo ""
    echo "📱 Pour installer sur iPhone:"
    echo "   1. Transférez Motivation.ipa sur iPhone"
    echo "   2. Ouvrez AltStore → My Apps → +"
    echo "   3. Sélectionnez le fichier"
    echo ""
    open ./build
else
    echo "❌ Échec: IPA non créé"
    ls -la ./build/
fi
