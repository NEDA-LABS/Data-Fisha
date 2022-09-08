rm -r build/web || echo 'Ops!'
flutter build web --web-renderer canvaskit
firebase deploy --only hosting:edge-smartstock --token ${{secrets.FIREBASE_TOKEN}}
