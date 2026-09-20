#!/bin/bash
# Вмикач/вимикач CRT-фільтра в Jellium однією командою.
# Всередину Jellium з клавіатурою не достукатись, тож смикаємо mpv
# через сокет напряму: "додай шейдер, якщо нема, і прибери, якщо є".
#
# Використання: toggle-crt.sh
# Зручно повісити на глобальний хоткей в налаштуваннях системи
# або викликати через fish-функцію jellicrt.

SOCK=/tmp/jellium-mpv.sock
SHADER="$HOME/.config/jellium-desktop/mpv/shaders/crt-lottes.glsl"

# Сокета нема — значить, Jellium зараз взагалі не запущений, тоглити нічого.
[ -S "$SOCK" ] || { echo "Jellium не запущено"; exit 1; }

OUT=$(printf '{ "command": ["change_list", "glsl-shaders", "toggle", "%s"] }\n' "$SHADER" | socat - "$SOCK" 2>&1)

if echo "$OUT" | grep -q '"success"'; then
    echo "CRT тоглнуто"
else
    # Буває: файл сокета лишився від минулого запуску, а слухати вже нікому.
    # Прибираємо сміття, щоб наступному запуску не заважало.
    echo "$OUT" | grep -q "Connection refused" && rm -f "$SOCK"
    echo "Jellium не запущено"
    exit 1
fi
