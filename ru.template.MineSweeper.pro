TARGET = ru.template.MineSweeper

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/logic.js \
    qml/pages/Board.qml \
    qml/pages/Cell.qml \
    qml/pages/GamePage.qml \
    qml/pages/MenuPage.qml \
    qml/pages/StatsPage.qml \
    qml/stats.js \
    rpm/ru.template.MineSweeper.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.MineSweeper.ts \
    translations/ru.template.MineSweeper-ru.ts \
