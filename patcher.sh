#!/usr/bin/bash

while read -r command; do
	printf "Start: $command\n"
	if ($command); then
		printf "\tDone\n"
	else
		echo "Fatal Error during '$command'"
		exit 1
	fi
done <<- EOM
	asar extract app.asar app_original
	mv app.asar app_original.asar
	js-beautify app_original/dist/electron/renderer.js -o renderer.js
	git apply ui.patch
	cp -r app_original app
	mv renderer.js app/dist/electron/renderer.js
	asar pack app app.asar
	rm -rf app/ app_original/
EOM

echo "All Done"

