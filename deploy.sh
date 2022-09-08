rm -r build/web || echo 'Ops!'
flutter build web --web-renderer canvaskit
firebase deploy --only hosting:edge-smartstock --token="1//03yO_ovTWbbmBCgYIARAAGAMSNwF-L9IrKl4cAocingM3g3J9KTlCU-xAg1oCjReGT9CPISfUIP0-VZfuSOiWN_6Y80qE0lybLzA"
