# mctrd

Консольная утилита для работы с образами носителей ZX Spectrum: TAP (кассета), SCL и TRD (диск). Команды: создание образа, просмотр каталога, добавление файлов, извлечение файлов, переименование.

## Сборка

Требуются Linux и gcc.

```
make            сборка -> build/mctrd
make clean      удаление build/
```

Дальше в примерах `mctrd` означает `./build/mctrd`.

## Форматы

| формат | расширение | команды |
|---|---|---|
| TAP | `.tap` | `new`, `list`, `add` |
| SCL | `.scl` | `new`, `list`, `add`, `pop`, `rename` |
| TRD | `.trd` | `new`, `list`, `add`, `pop`, `rename` |

Тип изображения определяется расширением и сигнатурой файла.

## Команды

```
mctrd [-h][-z][-b][-n][-a num] command name1 [name2] [name3]
```

| команда | действие |
|---|---|
| `new <image>` | создать новый образ (тип по расширению: TAP, TRD, SCL) |
| `list <image>` | каталог образа |
| `add <file> <image>` | положить файл в образ |
| `pop <file> <image> [<outname>]` | извлечь один файл (SCL, TRD); без `<file>` - все файлы |
| `rename <image> <oname> <nname>` | переименовать файл внутри образа |

## Флаги

| флаг | действие |
|---|---|
| `-b`, `--basic` | добавить файл в архив как BASIC (в конец данных дописываются байты `80,AA,<строка>`) |
| `-a`, `--autostart NUM` | номер строки автостарта для BASIC-файла (используется с `-b`) |
| `-z`, `--hobeta` | извлечь/положить файл как хобета (только SCL, TRD) |
| `-n`, `--no-head` | положить файл в TAP без заголовка |
| `-h`, `--help` | справка |

## Имена файлов

Имя файла в каталоге образа формируется из имени исходного файла: до 8 символов имени + первый символ расширения. Расширение сохраняется в регистре, имя - как есть (пробелы не допускаются). Примеры: `boot.B` -> `boot B`, `data.bin` -> `data b`.

Поиск при `pop` и `rename` - точное совпадение имени с каталогом. Имя можно посмотреть командой `list`; если имя в каталоге содержит пробелы, заключайте его в кавычки:

```
mctrd pop "boot    .B" demo.trd boot.B
```

## Примеры

### Создать TRD-диск с программой и данными

```
mctrd new demo.trd
mctrd -b -a 10 add prog.b demo.trd      # BASIC, автостарт строка 10
mctrd add data.bin demo.trd             # данные
mctrd list demo.trd
```

### Разобрать готовый TRD-диск на файлы

```
mkdir work && cd work
cp /путь/к/demo.trd .
mctrd pop demo.trd                      # все файлы: 000_имя.расш, 001_... и т.д.
ls
```

Имена файлов в каталоге могут содержать пробелы (заполнение до 8 символов), при использовании заключайте их в кавычки.

### Собрать TRD-диск обратно из файлов

Порядок добавления должен совпадать с порядком в исходном каталоге (`list`):

```
mctrd new rebuilt.trd
mctrd -b -a 10 add "boot    .B" rebuilt.trd
mctrd add covox000.C rebuilt.trd
mctrd add mlbmscr0.C rebuilt.trd
mctrd list rebuilt.trd
cmp demo.trd rebuilt.trd                # совпадает байт-в-байт
```

### SCL и TAP

```
# SCL: создать, положить файл, посмотреть, извлечь
mctrd new demo.scl
mctrd add data.bin demo.scl
mctrd list demo.scl
mctrd pop data.bin demo.scl out.bin

# TAP: создать, положить файл с заголовком (или -n без заголовка), посмотреть
mctrd new demo.tap
mctrd add prog.b demo.tap
mctrd list demo.tap
```

### Переименовать файл внутри образа

```
mctrd rename demo.scl data.bin newname.bin
mctrd list demo.scl
```

## Лицензия

GPL v2, см. [LICENSE.txt](LICENSE.txt).

