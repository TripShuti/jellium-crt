# Коротка команда для термінала: пишеш jellicrt — фільтр вмикається/вимикається.
# Сама логіка живе в toggle-crt.sh, тут тільки зручне ім'я.
function jellicrt --description "Вмикач CRT-фільтра в Jellium"
    ~/.config/jellium-desktop/mpv/toggle-crt.sh
end
