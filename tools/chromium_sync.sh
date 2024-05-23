#!/bin/bash 
echo "► Enabling Chromium sync"
echo
echo "Creating /etc/chromium.d/apikeys ..."
cat << EOF | sudo tee "/etc/chromium.d/apikeys" >/dev/null
# API keys found in chromium source code https://chromium.googlesource.com/experimental/chromium/src/+/b08bf82b0df37d15a822b478e23ce633616ed959/google_apis/google_api_keys.cc

export GOOGLE_API_KEY="AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k"
export GOOGLE_DEFAULT_CLIENT_ID="77185425430.apps.googleusercontent.com"
export GOOGLE_DEFAULT_CLIENT_SECRET="OTJgUOQcT7lO7GsGZq2G4IlT"
EOF
echo "Creating sync script /etc/chromium.d/enable_sync ..."
cat << "EOF" | sudo tee "/etc/chromium.d/enable_sync" >/dev/null
#!/bin/bash

profiles="$(find "$HOME/.config/chromium/" -maxdepth 1 -type d '(' -name Default -o -name 'Profile *' ')' | sed 's+.*/++g')"
echo "$profiles" | while read -r profile ;do
  [ ! -f "$HOME/.config/chromium/$profile/Preferences" ] && continue
  sed -i 's/"signin":{"allowed":false}/"signin":{"allowed":true,"allowed_on_next_startup":true}/g' "$HOME/.config/chromium/$profile/Preferences"
  sed -i 's/"signin":{"allowed":false,"allowed_on_next_startup":false}/"signin":{"allowed":true,"allowed_on_next_startup":true}/g' "$HOME/.config/chromium/$profile/Preferences"
  sed -i 's/"signin":{"AccountReconcilor":{"kDiceMigrationOnStartup2":true},"allowed":false,"allowed_on_next_startup":false}/"signin":{"AccountReconcilor":{"kDiceMigrationOnStartup2":true},"allowed":true,"allowed_on_next_startup":true}/g' "$HOME/.config/chromium/$profile/Preferences"
done
EOF
echo
echo done. 
