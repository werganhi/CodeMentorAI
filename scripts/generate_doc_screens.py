from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


OUT = Path("docs/_work/screens")
OUT.mkdir(parents=True, exist_ok=True)

FONT = "C:/Windows/Fonts/arial.ttf"
FONT_BOLD = "C:/Windows/Fonts/arialbd.ttf"
regular = ImageFont.truetype(FONT, 18)
small = ImageFont.truetype(FONT, 14)
bold = ImageFont.truetype(FONT_BOLD, 20)
title = ImageFont.truetype(FONT_BOLD, 25)
big = ImageFont.truetype(FONT_BOLD, 31)

W, H = 390, 844
BG = (246, 248, 252)
CARD = (255, 255, 255)
TEXT = (31, 37, 48)
MUTED = (102, 112, 133)
BLUE = (45, 101, 246)
GREEN = (16, 185, 129)
PURPLE = (124, 58, 237)
RED = (225, 29, 72)
BORDER = (222, 228, 238)


def text(draw, xy, value, font=regular, fill=TEXT):
    draw.text(xy, value, font=font, fill=fill)


def card(draw, xy, radius=18, fill=CARD, outline=BORDER):
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=1)


def wrap(draw, value, max_width, font):
    words = value.split()
    lines = []
    current = ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if draw.textlength(candidate, font=font) <= max_width:
            current = candidate
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def base(header, subtitle):
    image = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(image)
    draw.rectangle((0, 0, W, 74), fill=(20, 26, 38))
    text(draw, (22, 18), header, title, (255, 255, 255))
    text(draw, (22, 47), subtitle, small, (190, 205, 230))
    return image, draw


def bottom_nav(draw, active):
    labels = ["Главная", "Уроки", "Практика", "Справочник", "ИИ"]
    xs = [34, 108, 185, 270, 344]
    draw.rectangle((0, H - 74, W, H), fill=(255, 255, 255), outline=BORDER)
    for index, label in enumerate(labels):
        color = BLUE if index == active else (116, 125, 145)
        draw.ellipse((xs[index] - 9, H - 58, xs[index] + 9, H - 40), fill=color)
        text(draw, (xs[index] - 24, H - 34), label, small, color)


def progress(draw, x, y, width, value, color=BLUE):
    draw.rounded_rectangle((x, y, x + width, y + 8), 4, fill=(230, 235, 243))
    draw.rounded_rectangle((x, y, x + int(width * value), y + 8), 4, fill=color)


def save(image, name):
    image.save(OUT / name)


def screen_home():
    image, draw = base("CodeMentor AI", "Привет, студент")
    card(draw, (18, 92, 372, 202))
    text(draw, (36, 112), "Прогресс курса", bold)
    text(draw, (36, 144), "4 из 16 уроков завершено", regular, MUTED)
    progress(draw, 36, 176, 300, 0.25)
    for index, (label, value, color) in enumerate(
        [("XP", "180", BLUE), ("Серия", "3 дня", GREEN), ("Цель", "30 мин", PURPLE)]
    ):
        x = 18 + index * 122
        card(draw, (x, 220, x + 110, 305), 14)
        text(draw, (x + 15, 238), label, small, MUTED)
        text(draw, (x + 15, 262), value, bold, color)
    card(draw, (18, 328, 372, 430))
    text(draw, (36, 350), "Следующий шаг", bold)
    text(draw, (36, 380), "Старт в Python", bold)
    text(draw, (36, 407), "Первая программа и вывод данных", small, MUTED)
    text(draw, (18, 462), "Быстрые действия", bold)
    for index, (label, color) in enumerate(
        [("Открыть уроки", BLUE), ("Практика", PURPLE), ("Справочник", GREEN), ("Спросить ИИ", RED)]
    ):
        y = 500 + index * 58
        card(draw, (18, y, 372, y + 46), 12)
        draw.ellipse((34, y + 13, 54, y + 33), fill=color)
        text(draw, (70, y + 12), label)
    bottom_nav(draw, 0)
    save(image, "screen_01_home.png")


def screen_lessons():
    image, draw = base("Уроки", "16 тем по разным языкам")
    text(draw, (18, 92), "Каталог уроков", bold)
    lessons = [
        ("Python", "Старт в Python", "Основы синтаксиса и print()"),
        ("JavaScript", "DOM и события", "Интерактивность web-страницы"),
        ("SQL", "Запрос SELECT", "Выборка данных из таблиц"),
        ("Dart", "Виджеты Flutter", "Экран как дерево компонентов"),
        ("Java", "Классы", "Объектно-ориентированный подход"),
        ("C++", "Память", "Типы, указатели и функции"),
    ]
    for index, (tag, name, desc) in enumerate(lessons):
        y = 130 + index * 94
        card(draw, (18, y, 372, y + 78), 14)
        draw.rounded_rectangle((32, y + 16, 100, y + 42), 8, fill=(232, 240, 255))
        text(draw, (40, y + 20), tag, small, BLUE)
        text(draw, (112, y + 15), name, bold)
        text(draw, (112, y + 44), desc, small, MUTED)
    bottom_nav(draw, 1)
    save(image, "screen_02_lessons.png")


def screen_lesson_detail():
    image, draw = base("Старт в Python", "Урок: теория, код, тест")
    text(draw, (18, 92), "Первая программа", bold)
    card(draw, (18, 128, 372, 270))
    for index, line in enumerate(
        wrap(draw, "Python часто используют для обучения, потому что синтаксис читается близко к обычному языку.", 320, regular)
    ):
        text(draw, (36, 150 + 24 * index), line)
    card(draw, (18, 292, 372, 450), 14, fill=(17, 24, 39), outline=(17, 24, 39))
    for index, line in enumerate(['print("Hello, CodeMentor!")', 'name = "Oleg"', "print(name)"]):
        text(draw, (36, 314 + 34 * index), line, regular, (226, 232, 240))
    card(draw, (18, 476, 372, 610))
    text(draw, (36, 498), "Тест", bold)
    text(draw, (36, 530), "Что делает print()?")
    draw.rounded_rectangle((36, 568, 336, 598), 8, outline=BLUE, width=2)
    text(draw, (52, 573), "Выводит данные на экран", small, BLUE)
    bottom_nav(draw, 1)
    save(image, "screen_03_lesson_detail.png")


def screen_practice():
    image, draw = base("Практика", "Задания по чтению кода")
    text(draw, (18, 92), "Мини-задача", bold)
    card(draw, (18, 128, 372, 292), 14, fill=(17, 24, 39), outline=(17, 24, 39))
    for index, line in enumerate(["let total = 0;", "for (let i = 1; i <= 3; i++) {", "  total += i;", "}", "console.log(total);"]):
        text(draw, (36, 148 + 25 * index), line, regular, (226, 232, 240))
    card(draw, (18, 318, 372, 420))
    text(draw, (36, 340), "Вопрос", bold)
    text(draw, (36, 372), "Какой результат появится в консоли?", regular, MUTED)
    card(draw, (18, 450, 372, 510))
    text(draw, (36, 468), "Ответ пользователя: 6", bold, GREEN)
    text(draw, (36, 492), "Верно, цикл суммирует 1 + 2 + 3.", small, MUTED)
    card(draw, (18, 540, 372, 620))
    text(draw, (36, 560), "+15 XP", big, BLUE)
    text(draw, (36, 594), "Прогресс сохранен в аккаунте", small, MUTED)
    bottom_nav(draw, 2)
    save(image, "screen_04_practice.png")


def screen_reference():
    image, draw = base("Справочник", "100+ терминов")
    card(draw, (18, 92, 372, 140))
    text(draw, (36, 106), "Поиск: async", regular, MUTED)
    terms = [
        ("async/await", "JavaScript, Dart", "Future и Promise"),
        ("SELECT", "SQL", "Данные из таблицы"),
        ("Class", "Java, C#, Kotlin", "Шаблон объектов"),
        ("Widget", "Flutter", "Компонент UI"),
        ("Dockerfile", "DevOps", "Сборка контейнера"),
    ]
    for index, (name, category, desc) in enumerate(terms):
        y = 162 + index * 92
        card(draw, (18, y, 372, y + 76), 14)
        text(draw, (36, y + 14), name, bold)
        text(draw, (36, y + 39), category, small, BLUE)
        text(draw, (190, y + 39), desc, small, MUTED)
    bottom_nav(draw, 3)
    save(image, "screen_05_reference.png")


def screen_ai():
    image, draw = base("ИИ-наставник", "Gemini 2.5 Flash")
    card(draw, (18, 96, 315, 180))
    text(draw, (34, 116), "Объясни ошибку NameError")
    text(draw, (34, 146), "почему переменная не найдена?", small, MUTED)
    card(draw, (72, 214, 372, 390), 18, fill=(232, 240, 255), outline=(198, 214, 255))
    answer = "NameError означает, что код обращается к имени, которое Python не знает. Проверь написание переменной и место, где она создана."
    for index, line in enumerate(wrap(draw, answer, 260, regular)):
        text(draw, (92, 236 + 24 * index), line)
    card(draw, (18, 428, 372, 520))
    text(draw, (36, 448), "API key сохранен", bold, GREEN)
    text(draw, (36, 478), "Если лимит закончится, будет локальная подсказка.", small, MUTED)
    card(draw, (18, 690, 372, 744))
    text(draw, (36, 707), "Написать вопрос...", regular, MUTED)
    bottom_nav(draw, 4)
    save(image, "screen_06_ai.png")


def screen_account():
    image, draw = base("Аккаунт", "Google + Firestore")
    card(draw, (18, 96, 372, 214))
    draw.ellipse((36, 122, 92, 178), fill=(232, 240, 255))
    text(draw, (111, 122), "Вход через Google", bold)
    text(draw, (111, 152), "student@gmail.com", regular, MUTED)
    text(draw, (111, 180), "Синхронизация включена", small, GREEN)
    card(draw, (18, 244, 372, 378))
    text(draw, (36, 266), "Облачные данные", bold)
    text(draw, (36, 300), "completed: 4 урока")
    text(draw, (36, 326), "xp: 180, streak: 3")
    text(draw, (36, 352), "notes и favorites сохранены", small, MUTED)
    card(draw, (18, 412, 372, 544))
    text(draw, (36, 434), "Настройки", bold)
    text(draw, (36, 468), "Тема: системная")
    text(draw, (36, 496), "Цель дня: 30 минут")
    text(draw, (36, 524), "Имя студента: Олег", small, MUTED)
    bottom_nav(draw, 0)
    save(image, "screen_07_account.png")


def screen_testing():
    image, draw = base("Сборка APK", "Тестирование проекта")
    card(draw, (18, 96, 372, 238), 14, fill=(17, 24, 39), outline=(17, 24, 39))
    for index, line in enumerate(["flutter analyze", "No issues found!", "", "flutter test", "All tests passed!"]):
        text(draw, (36, 116 + 24 * index), line, regular, (226, 232, 240))
    card(draw, (18, 270, 372, 390))
    text(draw, (36, 292), "Release APK", bold)
    text(draw, (36, 326), "flutter build apk --release")
    text(draw, (36, 356), "CodeMentorAI-release.apk", small, BLUE)
    card(draw, (18, 426, 372, 536))
    text(draw, (36, 448), "Проверено", bold, GREEN)
    text(draw, (36, 482), "Кнопки, навигация, уроки, практика,", small, MUTED)
    text(draw, (36, 504), "справочник и ИИ-наставник.", small, MUTED)
    bottom_nav(draw, 0)
    save(image, "screen_08_testing.png")


def workplace_plan():
    image = Image.new("RGB", (720, 460), (248, 250, 252))
    draw = ImageDraw.Draw(image)
    text(draw, (24, 20), "План рабочего места и аудитории", title)
    draw.rectangle((50, 80, 670, 410), outline=(55, 65, 81), width=4, fill=(255, 255, 255))
    draw.rectangle((55, 90, 65, 210), fill=(147, 197, 253))
    text(draw, (80, 125), "Окна", regular, MUTED)
    draw.arc((610, 330, 700, 420), 180, 270, fill=(55, 65, 81), width=3)
    text(draw, (560, 382), "Дверь", regular, MUTED)
    for index, x in enumerate([115, 300, 485], 1):
        draw.rounded_rectangle((x, 170, x + 120, 235), 10, fill=(226, 232, 240), outline=(148, 163, 184), width=2)
        draw.rectangle((x + 35, 145, x + 85, 168), fill=(30, 41, 59))
        draw.rounded_rectangle((x + 35, 248, x + 85, 286), 12, fill=(203, 213, 225), outline=(148, 163, 184))
        text(draw, (x + 24, 292), f"Место {index}", small, MUTED)
    for x in [160, 330, 500]:
        draw.ellipse((x, 105, x + 34, 139), fill=(254, 249, 195), outline=(234, 179, 8))
    text(draw, (95, 350), "Столы расположены с проходом, экран не бликует,", regular)
    text(draw, (95, 376), "окна слева, рабочее место проветривается.", regular)
    draw.rounded_rectangle((500, 95, 635, 135), 8, fill=(220, 252, 231), outline=(34, 197, 94))
    text(draw, (515, 105), "Вентиляция", small, GREEN)
    image.save(OUT / "workplace_plan.png")


def main():
    screen_home()
    screen_lessons()
    screen_lesson_detail()
    screen_practice()
    screen_reference()
    screen_ai()
    screen_account()
    screen_testing()
    workplace_plan()
    print(f"generated {len(list(OUT.glob('*.png')))} screenshots in {OUT}")


if __name__ == "__main__":
    main()
