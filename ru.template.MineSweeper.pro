TARGET = ru.template.MineSweeper

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

qml.files = \
    qml/pages/*.qml \
    qml/MineSweeper.qml

qml.path = /usr/share/ru.template.MineSweeper/qml

js.files = js/*.js
js.path = /usr/share/ru.template.MineSweeper/js

DISTFILES += \
    js/logic.js \
    js/storage.js \
    qml/pages/Board.qml \
    qml/pages/Cell.qml \
    qml/pages/GamePage.qml \
    qml/pages/MenuPage.qml \
    qml/pages/StatsPage.qml \
    rpm/ru.template.MineSweeper.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.MineSweeper.ts \
    translations/ru.template.MineSweeper-ru.ts \

INSTALLS += qml js
