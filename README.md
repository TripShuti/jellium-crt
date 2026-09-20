# jellicrt — CRT-фільтр для Jellium Desktop

*English version: [README.en.md](README.en.md).*

Вмикає ламповий CRT-вигляд (сканлайни + маска, без закруглення екрана)
в Jellium однією командою `jellicrt`.

## Встановлення

Руками, тут всього чотири файли. У `mpv.conf` підстав свій домашній шлях замість `__HOME__`:

```bash
mkdir -p ~/.config/jellium-desktop/mpv/shaders ~/.config/fish/functions
sed "s|__HOME__|$HOME|" mpv.conf > ~/.config/jellium-desktop/mpv/mpv.conf
cp shaders/crt-lottes.glsl ~/.config/jellium-desktop/mpv/shaders/
cp toggle-crt.sh ~/.config/jellium-desktop/mpv/ && chmod +x ~/.config/jellium-desktop/mpv/toggle-crt.sh
cp fish-functions/jellicrt.fish ~/.config/fish/functions/
```

Потрібен `socat` (`sudo pacman -S socat`). Після встановлення перезапусти Jellium.

## Використання

- `jellicrt` — вмкнути/вимкнути фільтр
- за дефолтом фільтр вимкнений, вмикається тільки вручну
- хочеш автозавантаження при старті — розкоментуй `glsl-shaders` в `~/.config/jellium-desktop/mpv/mpv.conf`

## Що всередині

| Файл | Куди ставиться | Навіщо |
|---|---|---|
| `mpv.conf` | `~/.config/jellium-desktop/mpv/` | Сокет для керування + вимкнений за дефолтом шейдер |
| `shaders/crt-lottes.glsl` | `.../mpv/shaders/` | Сам фільтр, mpv-порт, кривизна прибрана |
| `toggle-crt.sh` | `.../mpv/` | Тогл через mpv IPC-сокет |
| `fish-functions/jellicrt.fish` | `~/.config/fish/functions/` | Коротка команда для термінала |

## Чому так складно, а не просто бінд в input.conf

Три граблі, на які ми вже наступили:

1. Jellium читає конфіги тільки з `~/.config/jellium-desktop/mpv/`, звичайний `~/.config/mpv/` ігнорує.
2. Клавіатуру в Jellium з'їдає CEF, до mpv вона не доходить — бінди в `input.conf` не працюють.
3. RetroArch-шейдери (`#pragma parameter`, `MVPMatrix`) mpv відкидає — потрібен формат з `//!HOOK`.

Тому: шейдер вантажиться через `mpv.conf`, а перемикається ззовні через IPC-сокет.
