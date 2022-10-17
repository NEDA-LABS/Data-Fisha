#rm -r build/web || echo 'Ops!'
flutter build web --web-renderer html
#--web-renderer canvaskit
export FIREBASE_TOKEN="1//03fR_okU7hCZyCgYIARAAGAMSNwF-L9IrfyErR8FogG6g19v9pYs6EJLWKxun9Q5OVHHh89i51XFqvSVgOfZmIVHvuvhsgZULbDw";
firebase deploy --only hosting:edge --token="$FIREBASE_TOKEN"
firebase deploy --only hosting:web --token="$FIREBASE_TOKEN"