rm -r build/web || echo 'Ops!'
flutter build web --web-renderer html
#--web-renderer canvaskit
firebase deploy --only hosting:edge --token="1//03yO_ovTWbbmBCgYIARAAGAMSNwF-L9IrKl4cAocingM3g3J9KTlCU-xAg1oCjReGT9CPISfUIP0-VZfuSOiWN_6Y80qE0lybLzA"
firebase deploy --only hosting:web --token="1//03yO_ovTWbbmBCgYIARAAGAMSNwF-L9IrKl4cAocingM3g3J9KTlCU-xAg1oCjReGT9CPISfUIP0-VZfuSOiWN_6Y80qE0lybLzA"
