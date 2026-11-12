# MEZO OS 1.0 — сборка из Termux через GitHub Actions

Termux управляет сборкой, а сам образ собирается на облачном Ubuntu runner GitHub Actions. Локальная сборка pi-gen в обычном Termux без root/loop devices не подходит.

## Что включает базовая версия
- Raspberry Pi OS 32-bit (Bookworm) через официальный RPi-Distro/pi-gen.
- SSH и hostname `mezo`.
- Avahi/mDNS.
- Python 3, OpenCV, NumPy, ALSA utilities, I2C/V4L2 tools.
- Служба MEZO CORE с диагностическим журналом.

Это базовая консольная ОС, а не готовый голосовой робот. Графический интерфейс, камера и драйвер конкретной платы усилителя добавляются после проверки дисплея и аудиоплаты.

## Запуск
1. Распакуй архив в Termux home, в папку `~/MEZO_Termux_GitHub_Builder`.
2. Выполни:
   `cd ~/MEZO_Termux_GitHub_Builder`
   `bash scripts/setup-termux.sh`
3. Установи GitHub CLI, если предложит, и войди через код устройства в браузере.
4. Скрипт создаст приватный GitHub-репозиторий по умолчанию, отправит конфигурацию и запустит Actions.
5. На GitHub открой репозиторий → Actions. После успешной сборки скачай artifact `MEZO_OS_1.0-image`.
6. Распакуй artifact, найди `.img` (или архивированный образ), затем запиши его Raspberry Pi Imager.

## Безопасность и ограничения
- Не помещай Wi-Fi пароль, Linux-пароли, GitHub токены или SSH private keys в репозиторий.
- Wi-Fi, имя пользователя и пароль задай через Raspberry Pi Imager при записи карты.
- Артефакт хранится 3 дня.
- Сборка может занять длительное время и зависит от лимитов GitHub Actions.
- Не открывай SSH в интернет; для удалённого доступа используй VPN.
- Сборка не считается проверенной, пока образ не загрузится на реальном Raspberry Pi Zero 2 WH.
