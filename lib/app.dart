import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const bg = Color(0xFFF6F7FB);
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF687086);
  static const line = Color(0xFFE1E5EE);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2563EB);
  static const teal = Color(0xFF0F766E);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const rose = Color(0xFFE11D48);
  static const violet = Color(0xFF7C3AED);
  static const cyan = Color(0xFF0891B2);

  static const darkBg = Color(0xFF10131A);
  static const darkSurface = Color(0xFF171B24);
  static const darkText = Color(0xFFECEFF6);
  static const darkMuted = Color(0xFF9AA3B8);
  static const darkLine = Color(0xFF2A3040);
}

class Lesson {
  final String id;
  final String title;
  final String track;
  final String level;
  final String duration;
  final String description;
  final IconData icon;
  final Color color;
  final int xp;
  final List<String> theory;
  final List<CodeSample> samples;
  final List<Question> questions;

  const Lesson({
    required this.id,
    required this.title,
    required this.track,
    required this.level,
    required this.duration,
    required this.description,
    required this.icon,
    required this.color,
    required this.xp,
    required this.theory,
    required this.samples,
    required this.questions,
  });
}

class CodeSample {
  final String title;
  final String code;
  final String output;
  final String note;

  const CodeSample({
    required this.title,
    required this.code,
    required this.output,
    required this.note,
  });
}

class Question {
  final String text;
  final List<String> options;
  final int answer;
  final String explanation;

  const Question({
    required this.text,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}

class Term {
  final String title;
  final String category;
  final String description;
  final String syntax;
  final String example;

  const Term({
    required this.title,
    required this.category,
    required this.description,
    required this.syntax,
    required this.example,
  });
}

class PracticeTask {
  final String title;
  final String topic;
  final String prompt;
  final String code;
  final String answer;
  final String hint;
  final Color color;

  const PracticeTask({
    required this.title,
    required this.topic,
    required this.prompt,
    required this.code,
    required this.answer,
    required this.hint,
    required this.color,
  });
}

class ReferenceSeed {
  final String title;
  final String category;
  final String description;
  final String syntax;
  final String example;

  const ReferenceSeed({
    required this.title,
    required this.category,
    required this.description,
    required this.syntax,
    required this.example,
  });
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final int progress;
  final int total;

  const Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.progress,
    required this.total,
  });
}

class StudyPlanItem {
  final String day;
  final String title;
  final String focus;
  final IconData icon;
  final Color color;

  const StudyPlanItem({
    required this.day,
    required this.title,
    required this.focus,
    required this.icon,
    required this.color,
  });
}

const studyPlan = <StudyPlanItem>[
  StudyPlanItem(
    day: 'День 1',
    title: 'База Python',
    focus: 'print, переменные, типы и короткие выводы',
    icon: Icons.flag_rounded,
    color: AppColors.primary,
  ),
  StudyPlanItem(
    day: 'День 2',
    title: 'Логика',
    focus: 'if, сравнения, and/or/not и разбор веток',
    icon: Icons.account_tree_rounded,
    color: AppColors.amber,
  ),
  StudyPlanItem(
    day: 'День 3',
    title: 'Повторение',
    focus: 'for, while, range и прогноз результата',
    icon: Icons.loop_rounded,
    color: AppColors.cyan,
  ),
  StudyPlanItem(
    day: 'День 4',
    title: 'Функции',
    focus: 'def, параметры, return и декомпозиция',
    icon: Icons.functions_rounded,
    color: AppColors.violet,
  ),
  StudyPlanItem(
    day: 'День 5',
    title: 'Мини-проект',
    focus: 'собрать задачу, протестировать и объяснить решение',
    icon: Icons.rocket_launch_rounded,
    color: AppColors.green,
  ),
];

const lessons = <Lesson>[
  Lesson(
    id: 'python_start',
    title: 'Старт в Python',
    track: 'Основы',
    level: 'Новичок',
    duration: '12 мин',
    description:
        'Первая программа, вывод данных и понимание того, как компьютер выполняет инструкции.',
    icon: Icons.rocket_launch_rounded,
    color: AppColors.primary,
    xp: 25,
    theory: [
      'Программа - это точный набор команд. Python читает команды сверху вниз и выполняет их по порядку.',
      'Функция print выводит текст, числа и результаты выражений. Ее удобно использовать для проверки работы кода.',
      'Комментарии начинаются с символа #. Они помогают объяснить важную логику и не выполняются интерпретатором.',
    ],
    samples: [
      CodeSample(
        title: 'Первый вывод',
        code: "print('Привет, код!')\nprint(2 + 3)",
        output: 'Привет, код!\n5',
        note: 'Каждый вызов print печатает значение на новой строке.',
      ),
      CodeSample(
        title: 'Комментарий',
        code: "# Эта строка не выполняется\nprint('Учусь программировать')",
        output: 'Учусь программировать',
        note: 'Комментарии нужны для человека, который читает код.',
      ),
    ],
    questions: [
      Question(
        text: 'Что делает print?',
        options: [
          'Удаляет файл',
          'Выводит данные',
          'Создает цикл',
          'Меняет тему'
        ],
        answer: 1,
        explanation: 'print выводит текст, числа или результат выражения.',
      ),
      Question(
        text: 'В каком порядке Python выполняет простые команды?',
        options: [
          'Снизу вверх',
          'Случайно',
          'Сверху вниз',
          'Только по алфавиту'
        ],
        answer: 2,
        explanation:
            'Обычные инструкции выполняются последовательно сверху вниз.',
      ),
    ],
  ),
  Lesson(
    id: 'variables',
    title: 'Переменные и типы',
    track: 'Основы',
    level: 'Новичок',
    duration: '15 мин',
    description:
        'Имена, значения, строки, числа и логические данные в программе.',
    icon: Icons.data_object_rounded,
    color: AppColors.green,
    xp: 30,
    theory: [
      'Переменная хранит значение под понятным именем. Хорошее имя делает код читаемым.',
      'int и float нужны для чисел, str - для текста, bool - для значений True и False.',
      'Python определяет тип автоматически, но программист должен понимать, какие операции допустимы.',
    ],
    samples: [
      CodeSample(
        title: 'Профиль студента',
        code:
            "name = 'Алия'\nage = 19\nactive = True\nprint(name, age, active)",
        output: 'Алия 19 True',
        note: 'В одной программе можно хранить разные типы данных.',
      ),
      CodeSample(
        title: 'f-строка',
        code: "score = 85\nprint(f'Результат: {score}%')",
        output: 'Результат: 85%',
        note: 'f-строка аккуратно подставляет значение переменной в текст.',
      ),
    ],
    questions: [
      Question(
        text: 'Какой тип используется для текста?',
        options: ['int', 'str', 'bool', 'list'],
        answer: 1,
        explanation: 'str - строковый тип данных.',
      ),
      Question(
        text: 'Какое имя переменной лучше?',
        options: ['x', 'a', 'student_score', 'мои данные'],
        answer: 2,
        explanation: 'student_score объясняет назначение значения.',
      ),
    ],
  ),
  Lesson(
    id: 'conditions',
    title: 'Условия и логика',
    track: 'Алгоритмы',
    level: 'База',
    duration: '18 мин',
    description: 'if, elif, else и выбор разных сценариев выполнения кода.',
    icon: Icons.account_tree_rounded,
    color: AppColors.amber,
    xp: 35,
    theory: [
      'Условие позволяет программе принимать решение. Если выражение истинно, выполняется один блок, если ложно - другой.',
      'Операторы сравнения: ==, !=, >, <, >=, <=. Их результатом является True или False.',
      'and требует выполнения всех условий, or - хотя бы одного, not меняет логическое значение.',
    ],
    samples: [
      CodeSample(
        title: 'Порог зачета',
        code:
            "score = 76\nif score >= 80:\n    print('Отлично')\nelif score >= 50:\n    print('Зачет')\nelse:\n    print('Повторить')",
        output: 'Зачет',
        note: 'Python выбирает первый подходящий блок.',
      ),
    ],
    questions: [
      Question(
        text: 'Когда выполняется else?',
        options: [
          'Всегда',
          'Если условия выше ложные',
          'До if',
          'Только при ошибке'
        ],
        answer: 1,
        explanation:
            'else запускается, если ни одно предыдущее условие не сработало.',
      ),
      Question(
        text: 'Что вернет 10 > 7?',
        options: ['10', '7', 'True', 'False'],
        answer: 2,
        explanation: '10 больше 7, значит сравнение истинно.',
      ),
    ],
  ),
  Lesson(
    id: 'loops',
    title: 'Циклы',
    track: 'Алгоритмы',
    level: 'База',
    duration: '20 мин',
    description: 'for, while и повторение действий без копирования строк.',
    icon: Icons.loop_rounded,
    color: AppColors.cyan,
    xp: 40,
    theory: [
      'Цикл повторяет действие несколько раз. Это экономит код и уменьшает вероятность ошибки.',
      'for удобен для перебора списка, строки или диапазона чисел.',
      'while работает, пока условие истинно. Важно менять условие, иначе цикл может стать бесконечным.',
    ],
    samples: [
      CodeSample(
        title: 'Перебор тем',
        code:
            "topics = ['if', 'for', 'list']\nfor topic in topics:\n    print('Повторить:', topic)",
        output: 'Повторить: if\nПовторить: for\nПовторить: list',
        note: 'Переменная topic по очереди получает элементы списка.',
      ),
      CodeSample(
        title: 'Обратный счет',
        code: "count = 3\nwhile count > 0:\n    print(count)\n    count -= 1",
        output: '3\n2\n1',
        note: 'count уменьшается, поэтому цикл завершается.',
      ),
    ],
    questions: [
      Question(
        text: 'Какой цикл удобен для перебора списка?',
        options: ['if', 'for', 'class', 'return'],
        answer: 1,
        explanation: 'for перебирает элементы последовательности.',
      ),
      Question(
        text: 'Что важно в while?',
        options: [
          'Не менять условие',
          'Обновлять условие завершения',
          'Писать без отступов',
          'Использовать только строки'
        ],
        answer: 1,
        explanation:
            'Без изменения условия while может выполняться бесконечно.',
      ),
    ],
  ),
  Lesson(
    id: 'functions',
    title: 'Функции',
    track: 'Архитектура',
    level: 'База',
    duration: '22 мин',
    description: 'Повторное использование кода, параметры и return.',
    icon: Icons.functions_rounded,
    color: AppColors.violet,
    xp: 45,
    theory: [
      'Функция объединяет действия под одним именем. Это делает код короче, понятнее и удобнее для тестирования.',
      'Параметры позволяют передавать данные внутрь функции.',
      'return возвращает результат наружу и завершает выполнение функции.',
    ],
    samples: [
      CodeSample(
        title: 'Бонус XP',
        code:
            "def add_bonus(score):\n    return score + 10\n\nprint(add_bonus(80))",
        output: '90',
        note: 'Функция принимает score и возвращает новое значение.',
      ),
    ],
    questions: [
      Question(
        text: 'Что делает return?',
        options: [
          'Печатает текст',
          'Возвращает значение',
          'Создает список',
          'Запускает цикл'
        ],
        answer: 1,
        explanation: 'return передает результат функции в место вызова.',
      ),
      Question(
        text: 'Зачем нужны функции?',
        options: [
          'Чтобы код был длиннее',
          'Чтобы переиспользовать логику',
          'Чтобы удалить Python',
          'Чтобы скрыть ошибки'
        ],
        answer: 1,
        explanation: 'Функции помогают не повторять один и тот же код.',
      ),
    ],
  ),
  Lesson(
    id: 'debug_ai',
    title: 'Отладка и ИИ',
    track: 'ИИ',
    level: 'Проект',
    duration: '25 мин',
    description:
        'Как читать ошибки, задавать ИИ правильные вопросы и проверять ответы.',
    icon: Icons.auto_awesome_rounded,
    color: AppColors.rose,
    xp: 55,
    theory: [
      'Ошибка - это подсказка. В сообщении обычно есть тип проблемы и строка, где программа остановилась.',
      'ИИ-наставник помогает объяснить ошибку простыми словами, но итоговое решение нужно проверять самостоятельно.',
      'Хороший промпт содержит контекст, цель и формат ответа: "объясни причину, исправь код, дай похожее задание".',
    ],
    samples: [
      CodeSample(
        title: 'NameError',
        code: "score = 10\nprint(scroe)",
        output: "NameError: name 'scroe' is not defined",
        note: 'В имени переменной опечатка: создана score, используется scroe.',
      ),
      CodeSample(
        title: 'Промпт для ИИ',
        code:
            'Объясни ошибку NameError в этом коде. Дай исправление и одно похожее упражнение.',
        output: 'ИИ должен вернуть причину, исправленный код и тренировку.',
        note: 'Чем точнее запрос, тем полезнее ответ наставника.',
      ),
    ],
    questions: [
      Question(
        text: 'Что чаще всего означает NameError?',
        options: [
          'Опечатка в имени',
          'Нет интернета',
          'Плохой цвет кнопки',
          'Мало памяти телефона'
        ],
        answer: 0,
        explanation:
            'NameError возникает, когда Python не нашел имя переменной или функции.',
      ),
      Question(
        text: 'Почему ответы ИИ нужно проверять?',
        options: [
          'ИИ всегда прав',
          'ИИ может ошибаться',
          'Так требует print',
          'Чтобы увеличить код'
        ],
        answer: 1,
        explanation: 'ИИ полезен как помощник, но может дать неточный ответ.',
      ),
    ],
  ),
  Lesson(
    id: 'javascript_web',
    title: 'JavaScript для веба',
    track: 'JavaScript',
    level: 'База',
    duration: '18 мин',
    description:
        'Переменные, функции, DOM и события: как JavaScript оживляет страницу.',
    icon: Icons.javascript_rounded,
    color: AppColors.amber,
    xp: 35,
    theory: [
      'JavaScript работает в браузере и на сервере через Node.js. Он нужен для интерактивности, логики интерфейса и обмена данными с API.',
      'let и const создают переменные. const используют, когда значение не должно переназначаться.',
      'События вроде click, input и submit позволяют реагировать на действия пользователя.',
    ],
    samples: [
      CodeSample(
        title: 'Клик по кнопке',
        code:
            "const button = document.querySelector('button');\nbutton.addEventListener('click', () => {\n  console.log('Clicked');\n});",
        output: 'Clicked',
        note:
            'addEventListener связывает действие пользователя и функцию-обработчик.',
      ),
    ],
    questions: [
      Question(
        text: 'Где чаще всего выполняется JavaScript в веб-разработке?',
        options: ['В браузере', 'Только в Excel', 'В BIOS', 'В архиваторе'],
        answer: 0,
        explanation:
            'JavaScript изначально создавался для браузера, хотя сейчас работает и на сервере.',
      ),
      Question(
        text: 'Что делает addEventListener?',
        options: [
          'Удаляет файл',
          'Подписывает на событие',
          'Создает базу',
          'Меняет язык ОС'
        ],
        answer: 1,
        explanation:
            'addEventListener запускает обработчик, когда происходит выбранное событие.',
      ),
    ],
  ),
  Lesson(
    id: 'html_css_layout',
    title: 'HTML и CSS интерфейсы',
    track: 'Frontend',
    level: 'Новичок',
    duration: '16 мин',
    description:
        'Структура страницы, стили, flexbox, grid и адаптивность под телефон.',
    icon: Icons.web_rounded,
    color: AppColors.cyan,
    xp: 30,
    theory: [
      'HTML описывает смысловую структуру: заголовки, кнопки, формы, списки и секции.',
      'CSS отвечает за внешний вид: цвета, отступы, размеры, сетки и адаптивность.',
      'Flexbox удобен для строки или колонки, а Grid для двумерной раскладки.',
    ],
    samples: [
      CodeSample(
        title: 'Карточка',
        code:
            "<article class=\"card\">\n  <h2>Lesson</h2>\n  <button>Start</button>\n</article>",
        output: 'Карточка с заголовком и кнопкой',
        note: 'HTML дает структуру, CSS превращает ее в аккуратный интерфейс.',
      ),
    ],
    questions: [
      Question(
        text: 'За что отвечает CSS?',
        options: [
          'За стиль страницы',
          'За компиляцию ядра',
          'За заряд батареи',
          'За SQL-запросы'
        ],
        answer: 0,
        explanation: 'CSS управляет визуальным оформлением HTML-элементов.',
      ),
      Question(
        text: 'Что лучше подходит для адаптивной сетки карточек?',
        options: ['Grid', 'ping', 'print', 'commit'],
        answer: 0,
        explanation:
            'CSS Grid удобен для раскладки карточек по строкам и колонкам.',
      ),
    ],
  ),
  Lesson(
    id: 'java_oop',
    title: 'Java и ООП',
    track: 'Java',
    level: 'База',
    duration: '24 мин',
    description:
        'Классы, объекты, методы, инкапсуляция и почему Java часто используют в backend.',
    icon: Icons.coffee_rounded,
    color: AppColors.rose,
    xp: 45,
    theory: [
      'Java строится вокруг классов и объектов. Класс описывает форму, объект хранит конкретные данные.',
      'Методы описывают поведение объекта, а поля хранят состояние.',
      'Инкапсуляция помогает скрывать детали и открывать только нужный интерфейс.',
    ],
    samples: [
      CodeSample(
        title: 'Класс',
        code:
            "class User {\n  String name;\n  User(String name) { this.name = name; }\n}",
        output: 'Объект User хранит имя',
        note: 'Конструктор задает начальное состояние объекта.',
      ),
    ],
    questions: [
      Question(
        text: 'Что описывает класс?',
        options: ['Шаблон объекта', 'IP-адрес', 'Только цвет', 'Коммит'],
        answer: 0,
        explanation: 'Класс задает поля и методы будущих объектов.',
      ),
      Question(
        text: 'Зачем нужна инкапсуляция?',
        options: [
          'Скрывать детали реализации',
          'Ускорять Wi-Fi',
          'Удалять код',
          'Менять шрифт'
        ],
        answer: 0,
        explanation:
            'Инкапсуляция защищает внутреннее состояние и упрощает использование класса.',
      ),
    ],
  ),
  Lesson(
    id: 'csharp_dotnet',
    title: 'C# и .NET',
    track: 'C#',
    level: 'База',
    duration: '22 мин',
    description: 'Синтаксис C#, LINQ, классы и где применяется платформа .NET.',
    icon: Icons.apps_rounded,
    color: AppColors.violet,
    xp: 42,
    theory: [
      'C# используют для backend, desktop, игр на Unity и корпоративных систем.',
      'LINQ позволяет удобно фильтровать, сортировать и преобразовывать коллекции.',
      'Типизация помогает находить ошибки до запуска программы.',
    ],
    samples: [
      CodeSample(
        title: 'LINQ',
        code: "var strong = scores.Where(score => score >= 80).ToList();",
        output: 'Список оценок 80 и выше',
        note: 'Where оставляет элементы, подходящие под условие.',
      ),
    ],
    questions: [
      Question(
        text: 'Где часто используют C#?',
        options: [
          'Unity и .NET backend',
          'Только в CSS',
          'Только в SQL',
          'В HTML-тегах'
        ],
        answer: 0,
        explanation: 'C# популярен в .NET-приложениях и Unity-разработке.',
      ),
      Question(
        text: 'Что делает Where в LINQ?',
        options: [
          'Фильтрует коллекцию',
          'Запускает браузер',
          'Сжимает картинку',
          'Переименовывает файл'
        ],
        answer: 0,
        explanation:
            'Where возвращает элементы, которые удовлетворяют условию.',
      ),
    ],
  ),
  Lesson(
    id: 'cpp_memory',
    title: 'C++ и память',
    track: 'C++',
    level: 'Средний',
    duration: '26 мин',
    description:
        'Указатели, ссылки, стек, куча и аккуратная работа с ресурсами.',
    icon: Icons.memory_rounded,
    color: AppColors.teal,
    xp: 50,
    theory: [
      'C++ дает высокий контроль над памятью и производительностью.',
      'Ссылка является альтернативным именем объекта, указатель хранит адрес.',
      'RAII помогает освобождать ресурсы автоматически через жизненный цикл объекта.',
    ],
    samples: [
      CodeSample(
        title: 'Ссылка',
        code: "int score = 10;\nint& ref = score;\nref = 15;",
        output: 'score становится 15',
        note: 'Ссылка работает с тем же объектом, а не с копией.',
      ),
    ],
    questions: [
      Question(
        text: 'Что хранит указатель?',
        options: [
          'Адрес в памяти',
          'CSS-класс',
          'HTTP-метод',
          'Название ветки'
        ],
        answer: 0,
        explanation:
            'Указатель хранит адрес объекта или null-подобное значение.',
      ),
      Question(
        text: 'Для чего нужен RAII?',
        options: [
          'Управлять ресурсами через объекты',
          'Красить кнопки',
          'Писать SQL',
          'Скрывать URL'
        ],
        answer: 0,
        explanation:
            'RAII связывает ресурс с объектом и освобождает его при уничтожении объекта.',
      ),
    ],
  ),
  Lesson(
    id: 'sql_data',
    title: 'SQL и данные',
    track: 'SQL',
    level: 'База',
    duration: '20 мин',
    description: 'SELECT, WHERE, JOIN, GROUP BY и мышление таблицами.',
    icon: Icons.storage_rounded,
    color: AppColors.green,
    xp: 38,
    theory: [
      'SQL нужен для работы с реляционными базами данных.',
      'SELECT выбирает столбцы, FROM указывает таблицу, WHERE фильтрует строки.',
      'JOIN объединяет данные из нескольких таблиц по связанным полям.',
    ],
    samples: [
      CodeSample(
        title: 'Фильтр',
        code: "SELECT name FROM students WHERE score >= 80;",
        output: 'Имена студентов с оценкой 80+',
        note: 'WHERE оставляет только строки, которые подходят под условие.',
      ),
    ],
    questions: [
      Question(
        text: 'Что делает SELECT?',
        options: [
          'Выбирает данные',
          'Рисует экран',
          'Создает APK',
          'Запускает таймер'
        ],
        answer: 0,
        explanation: 'SELECT описывает, какие данные нужно получить из базы.',
      ),
      Question(
        text: 'Зачем нужен JOIN?',
        options: [
          'Объединять таблицы',
          'Открывать браузер',
          'Собирать CSS',
          'Печатать логи'
        ],
        answer: 0,
        explanation:
            'JOIN связывает строки из разных таблиц по общему признаку.',
      ),
    ],
  ),
  Lesson(
    id: 'dart_flutter',
    title: 'Dart и Flutter',
    track: 'Dart/Flutter',
    level: 'Проект',
    duration: '24 мин',
    description:
        'Виджеты, состояние, Material Design и сборка мобильного интерфейса.',
    icon: Icons.flutter_dash_rounded,
    color: AppColors.primary,
    xp: 48,
    theory: [
      'Flutter строит интерфейс из виджетов: маленьких описаний того, что должно быть на экране.',
      'StatelessWidget подходит для неизменяемого UI, StatefulWidget хранит состояние.',
      'Dart поддерживает async/await для сетевых запросов и работы с будущими результатами.',
    ],
    samples: [
      CodeSample(
        title: 'Виджет',
        code: "Text('Hello Flutter', style: TextStyle(fontSize: 18))",
        output: 'Текст на экране',
        note: 'Каждый элемент интерфейса во Flutter является виджетом.',
      ),
    ],
    questions: [
      Question(
        text: 'Из чего строится UI во Flutter?',
        options: [
          'Из виджетов',
          'Из SQL-таблиц',
          'Из zip-файлов',
          'Из BIOS-настроек'
        ],
        answer: 0,
        explanation: 'Flutter описывает интерфейс деревом виджетов.',
      ),
      Question(
        text: 'Когда нужен StatefulWidget?',
        options: [
          'Когда есть изменяемое состояние',
          'Когда нет экрана',
          'Только для HTML',
          'Только для Git'
        ],
        answer: 0,
        explanation:
            'StatefulWidget используют, если экран должен реагировать на изменение данных.',
      ),
    ],
  ),
  Lesson(
    id: 'go_backend',
    title: 'Go для backend',
    track: 'Go',
    level: 'База',
    duration: '21 мин',
    description:
        'Простые сервисы, goroutine, каналы и быстрые серверные приложения.',
    icon: Icons.dns_rounded,
    color: AppColors.cyan,
    xp: 40,
    theory: [
      'Go ценят за простоту, скорость компиляции и удобство разработки серверов.',
      'Goroutine запускает легковесную параллельную задачу.',
      'Каналы помогают безопасно передавать данные между goroutine.',
    ],
    samples: [
      CodeSample(
        title: 'Goroutine',
        code: "go sendReport()\nfmt.Println(\"main\")",
        output: 'sendReport запускается параллельно',
        note: 'Ключевое слово go запускает функцию в отдельной goroutine.',
      ),
    ],
    questions: [
      Question(
        text: 'Что запускает goroutine?',
        options: [
          'Легковесную параллельную задачу',
          'CSS-анимацию',
          'SQL JOIN',
          'APK-подпись'
        ],
        answer: 0,
        explanation:
            'Goroutine позволяет выполнять функцию параллельно с основной логикой.',
      ),
      Question(
        text: 'Для чего нужны каналы в Go?',
        options: [
          'Передавать данные между goroutine',
          'Менять цвет текста',
          'Открывать Excel',
          'Сохранять картинки'
        ],
        answer: 0,
        explanation:
            'Каналы являются механизмом обмена данными между параллельными задачами.',
      ),
    ],
  ),
];

const baseTerms = <Term>[
  Term(
    title: 'print()',
    category: 'Основы',
    description: 'Функция для вывода данных на экран.',
    syntax: "print('текст')",
    example: "print('Hello')",
  ),
  Term(
    title: 'Переменная',
    category: 'Основы',
    description: 'Имя, связанное со значением в памяти программы.',
    syntax: 'name = value',
    example: "course = 'Python'",
  ),
  Term(
    title: 'str',
    category: 'Типы',
    description: 'Строковый тип данных для текста.',
    syntax: "'текст'",
    example: "city = 'Oral'",
  ),
  Term(
    title: 'bool',
    category: 'Типы',
    description: 'Логический тип данных: True или False.',
    syntax: 'True / False',
    example: 'is_done = False',
  ),
  Term(
    title: 'if',
    category: 'Алгоритмы',
    description: 'Оператор условия.',
    syntax: 'if condition:',
    example: 'if score >= 70:',
  ),
  Term(
    title: 'for',
    category: 'Алгоритмы',
    description: 'Цикл для перебора элементов.',
    syntax: 'for item in items:',
    example: 'for n in range(5):',
  ),
  Term(
    title: 'while',
    category: 'Алгоритмы',
    description: 'Цикл, который работает, пока условие истинно.',
    syntax: 'while condition:',
    example: 'while attempts > 0:',
  ),
  Term(
    title: 'def',
    category: 'Архитектура',
    description: 'Ключевое слово для объявления функции.',
    syntax: 'def name(params):',
    example: 'def greet(name):',
  ),
  Term(
    title: 'return',
    category: 'Архитектура',
    description: 'Возвращает результат из функции.',
    syntax: 'return value',
    example: 'return total',
  ),
  Term(
    title: 'NameError',
    category: 'Ошибки',
    description: 'Python не нашел переменную или функцию с таким именем.',
    syntax: "NameError: name 'x' is not defined",
    example: 'print(total) без total = ...',
  ),
  Term(
    title: 'Промпт',
    category: 'ИИ',
    description: 'Текстовая инструкция для ИИ-модели.',
    syntax: 'роль + контекст + задача + формат',
    example: 'Ты наставник. Объясни цикл for на примере.',
  ),
  Term(
    title: 'input()',
    category: 'Основы',
    description: 'Функция для ввода текста от пользователя.',
    syntax: 'name = input("Имя: ")',
    example: "age = input('Возраст: ')",
  ),
  Term(
    title: 'type()',
    category: 'Типы',
    description: 'Показывает тип значения или переменной.',
    syntax: 'type(value)',
    example: 'print(type(42))',
  ),
  Term(
    title: 'len()',
    category: 'Основы',
    description: 'Возвращает длину строки, списка или другой коллекции.',
    syntax: 'len(items)',
    example: "len(['a', 'b', 'c'])",
  ),
  Term(
    title: 'int',
    category: 'Типы',
    description: 'Целочисленный тип данных.',
    syntax: 'int(value)',
    example: "age = int('18')",
  ),
  Term(
    title: 'float',
    category: 'Типы',
    description: 'Тип данных для дробных чисел.',
    syntax: 'float(value)',
    example: "price = float('12.5')",
  ),
  Term(
    title: 'list',
    category: 'Коллекции',
    description: 'Изменяемый упорядоченный список значений.',
    syntax: '[item1, item2]',
    example: "topics = ['if', 'for']",
  ),
  Term(
    title: 'dict',
    category: 'Коллекции',
    description: 'Словарь: коллекция пар ключ-значение.',
    syntax: "{'key': value}",
    example: "{'name': 'Alya', 'xp': 80}",
  ),
  Term(
    title: 'tuple',
    category: 'Коллекции',
    description: 'Неизменяемая упорядоченная коллекция.',
    syntax: '(a, b)',
    example: "point = (10, 20)",
  ),
  Term(
    title: 'set',
    category: 'Коллекции',
    description: 'Коллекция уникальных значений без строгого порядка.',
    syntax: '{a, b, c}',
    example: "skills = {'python', 'sql'}",
  ),
  Term(
    title: 'append()',
    category: 'Коллекции',
    description: 'Добавляет новый элемент в конец списка.',
    syntax: 'items.append(value)',
    example: "tasks.append('practice')",
  ),
  Term(
    title: 'range()',
    category: 'Алгоритмы',
    description: 'Создает диапазон чисел для цикла.',
    syntax: 'range(start, stop)',
    example: 'for n in range(1, 5):',
  ),
  Term(
    title: 'break',
    category: 'Алгоритмы',
    description: 'Досрочно завершает цикл.',
    syntax: 'break',
    example: 'if found: break',
  ),
  Term(
    title: 'continue',
    category: 'Алгоритмы',
    description: 'Пропускает текущий шаг цикла и переходит к следующему.',
    syntax: 'continue',
    example: 'if score < 0: continue',
  ),
  Term(
    title: 'in',
    category: 'Алгоритмы',
    description: 'Проверяет наличие значения в коллекции или строке.',
    syntax: 'value in items',
    example: "'py' in 'python'",
  ),
  Term(
    title: 'and / or / not',
    category: 'Алгоритмы',
    description: 'Логические операторы для объединения условий.',
    syntax: 'a and b',
    example: 'score >= 70 and active',
  ),
  Term(
    title: 'import',
    category: 'Архитектура',
    description: 'Подключает модуль или библиотеку к программе.',
    syntax: 'import module',
    example: 'import math',
  ),
  Term(
    title: 'Модуль',
    category: 'Архитектура',
    description: 'Файл Python с функциями, классами или константами.',
    syntax: 'module.py',
    example: 'helpers.py',
  ),
  Term(
    title: 'Пакет',
    category: 'Архитектура',
    description: 'Папка с модулями, объединенными общей задачей.',
    syntax: 'package/module.py',
    example: 'app/services.py',
  ),
  Term(
    title: 'pip',
    category: 'Инструменты',
    description: 'Менеджер пакетов Python для установки библиотек.',
    syntax: 'pip install package',
    example: 'pip install requests',
  ),
  Term(
    title: 'class',
    category: 'ООП',
    description: 'Шаблон для создания объектов с данными и поведением.',
    syntax: 'class User:',
    example: 'class Student:',
  ),
  Term(
    title: 'Объект',
    category: 'ООП',
    description: 'Конкретный экземпляр класса.',
    syntax: 'object = Class()',
    example: 'student = Student()',
  ),
  Term(
    title: 'Метод',
    category: 'ООП',
    description: 'Функция, которая принадлежит классу или объекту.',
    syntax: 'def method(self):',
    example: 'student.learn()',
  ),
  Term(
    title: 'Атрибут',
    category: 'ООП',
    description: 'Данные, привязанные к объекту.',
    syntax: 'object.name',
    example: 'student.xp = 100',
  ),
  Term(
    title: '__init__',
    category: 'ООП',
    description: 'Конструктор, который настраивает объект при создании.',
    syntax: 'def __init__(self):',
    example: 'self.name = name',
  ),
  Term(
    title: 'Исключение',
    category: 'Ошибки',
    description:
        'Ситуация, когда программа не может продолжить обычное выполнение.',
    syntax: 'Exception',
    example: 'ValueError при неверном числе',
  ),
  Term(
    title: 'try / except',
    category: 'Ошибки',
    description: 'Конструкция для обработки ошибок без падения программы.',
    syntax: 'try: ... except Error:',
    example: 'except ValueError:',
  ),
  Term(
    title: 'SyntaxError',
    category: 'Ошибки',
    description: 'Ошибка синтаксиса: Python не может прочитать код.',
    syntax: 'SyntaxError',
    example: 'if score > 70 без :',
  ),
  Term(
    title: 'TypeError',
    category: 'Ошибки',
    description: 'Операция применена к неподходящему типу данных.',
    syntax: 'TypeError',
    example: "'age' + 5",
  ),
  Term(
    title: 'IndexError',
    category: 'Ошибки',
    description: 'Индекс выходит за границы списка или строки.',
    syntax: 'IndexError',
    example: 'items[10] при длине 3',
  ),
  Term(
    title: 'KeyError',
    category: 'Ошибки',
    description: 'В словаре нет запрошенного ключа.',
    syntax: 'KeyError',
    example: "profile['email'] без email",
  ),
  Term(
    title: 'ValueError',
    category: 'Ошибки',
    description: 'Тип подходит, но значение некорректное.',
    syntax: 'ValueError',
    example: "int('abc')",
  ),
  Term(
    title: 'None',
    category: 'Типы',
    description: 'Специальное значение, которое означает отсутствие данных.',
    syntax: 'None',
    example: 'result = None',
  ),
  Term(
    title: 'Отступ',
    category: 'Основы',
    description: 'Пробелы в начале строки, которые задают блок кода в Python.',
    syntax: '    code',
    example: 'строки внутри if имеют отступ',
  ),
  Term(
    title: 'Область видимости',
    category: 'Архитектура',
    description: 'Место программы, где доступно имя переменной.',
    syntax: 'scope',
    example: 'переменная внутри функции локальная',
  ),
  Term(
    title: 'Локальная переменная',
    category: 'Архитектура',
    description: 'Переменная, созданная внутри функции.',
    syntax: 'def f(): value = 1',
    example: 'value доступна внутри f',
  ),
  Term(
    title: 'global',
    category: 'Архитектура',
    description: 'Ключевое слово для работы с глобальной переменной.',
    syntax: 'global name',
    example: 'global score',
  ),
  Term(
    title: 'Параметр',
    category: 'Функции',
    description: 'Имя в объявлении функции, которое принимает значение.',
    syntax: 'def greet(name):',
    example: 'name - параметр',
  ),
  Term(
    title: 'Аргумент',
    category: 'Функции',
    description: 'Конкретное значение, переданное в функцию.',
    syntax: 'function(argument)',
    example: "greet('Alya')",
  ),
  Term(
    title: 'Рекурсия',
    category: 'Алгоритмы',
    description: 'Прием, когда функция вызывает саму себя.',
    syntax: 'def f(): f()',
    example: 'factorial(n)',
  ),
  Term(
    title: 'Алгоритм',
    category: 'Алгоритмы',
    description: 'Пошаговый способ решения задачи.',
    syntax: 'шаг 1 -> шаг 2',
    example: 'найти максимум в списке',
  ),
  Term(
    title: 'Сложность',
    category: 'Алгоритмы',
    description:
        'Оценка того, как растет время или память при увеличении данных.',
    syntax: 'O(n)',
    example: 'один проход по списку - O(n)',
  ),
  Term(
    title: 'Срез',
    category: 'Коллекции',
    description: 'Получение части строки или списка.',
    syntax: 'items[start:end]',
    example: 'name[0:3]',
  ),
  Term(
    title: 'Индекс',
    category: 'Коллекции',
    description: 'Позиция элемента в строке или списке.',
    syntax: 'items[index]',
    example: 'topics[0]',
  ),
  Term(
    title: 'Аккумулятор',
    category: 'Алгоритмы',
    description: 'Переменная, которая накапливает результат в цикле.',
    syntax: 'total += value',
    example: 'total = total + score',
  ),
  Term(
    title: 'Счетчик',
    category: 'Алгоритмы',
    description: 'Переменная для подсчета количества событий или шагов.',
    syntax: 'count += 1',
    example: 'count ошибок',
  ),
  Term(
    title: 'JSON',
    category: 'Данные',
    description: 'Текстовый формат обмена структурированными данными.',
    syntax: '{"key": "value"}',
    example: '{"name": "CodeMentor"}',
  ),
  Term(
    title: 'API',
    category: 'Веб',
    description: 'Интерфейс, через который программы обмениваются данными.',
    syntax: 'request -> response',
    example: 'получить список уроков через API',
  ),
  Term(
    title: 'HTTP',
    category: 'Веб',
    description: 'Протокол запросов и ответов между клиентом и сервером.',
    syntax: 'GET / POST',
    example: 'GET /lessons',
  ),
  Term(
    title: 'База данных',
    category: 'Данные',
    description: 'Система для хранения и поиска данных приложения.',
    syntax: 'table / document',
    example: 'таблица students',
  ),
  Term(
    title: 'SQL',
    category: 'Данные',
    description: 'Язык запросов к реляционным базам данных.',
    syntax: 'SELECT * FROM table',
    example: 'SELECT name FROM students',
  ),
];

final terms = <Term>[
  ...baseTerms,
  ...languageReference.map(
    (item) => Term(
      title: item.title,
      category: item.category,
      description: item.description,
      syntax: item.syntax,
      example: item.example,
    ),
  ),
];

const languageReference = <ReferenceSeed>[
  ReferenceSeed(
      title: 'JavaScript',
      category: 'Языки',
      description:
          'Язык веб-интерфейсов, серверов Node.js и интерактивной логики.',
      syntax: 'const value = 10;',
      example: "console.log('Hello');"),
  ReferenceSeed(
      title: 'TypeScript',
      category: 'Языки',
      description:
          'JavaScript с типами, который помогает ловить ошибки до запуска.',
      syntax: 'let score: number = 100;',
      example: 'type User = { name: string }'),
  ReferenceSeed(
      title: 'Java',
      category: 'Языки',
      description:
          'Строго типизированный язык для backend, Android и корпоративных систем.',
      syntax: 'public class Main {}',
      example: 'System.out.println("Hi");'),
  ReferenceSeed(
      title: 'C#',
      category: 'Языки',
      description: 'Язык платформы .NET для backend, desktop и Unity-игр.',
      syntax: 'string name = "Aruzhan";',
      example: 'Console.WriteLine(name);'),
  ReferenceSeed(
      title: 'C++',
      category: 'Языки',
      description:
          'Производительный язык с ручным контролем памяти и системными возможностями.',
      syntax: 'int score = 10;',
      example: 'std::cout << score;'),
  ReferenceSeed(
      title: 'C',
      category: 'Языки',
      description:
          'Низкоуровневый язык для системного программирования и embedded.',
      syntax: 'int main(void) {}',
      example: 'printf("Hello");'),
  ReferenceSeed(
      title: 'Go',
      category: 'Языки',
      description:
          'Простой язык для backend-сервисов, CLI и конкурентных задач.',
      syntax: 'func main() {}',
      example: 'fmt.Println("Go")'),
  ReferenceSeed(
      title: 'Rust',
      category: 'Языки',
      description: 'Системный язык с безопасной моделью владения памятью.',
      syntax: 'let score: i32 = 10;',
      example: 'println!("Rust");'),
  ReferenceSeed(
      title: 'Dart',
      category: 'Языки',
      description: 'Язык Flutter для мобильных, веб и desktop-приложений.',
      syntax: 'final title = "App";',
      example: "print('Dart');"),
  ReferenceSeed(
      title: 'Kotlin',
      category: 'Языки',
      description: 'Современный язык для Android и JVM-разработки.',
      syntax: 'val name = "Ali"',
      example: 'println(name)'),
  ReferenceSeed(
      title: 'Swift',
      category: 'Языки',
      description: 'Язык Apple-экосистемы для iOS, macOS и SwiftUI.',
      syntax: 'let name = "iOS"',
      example: 'print(name)'),
  ReferenceSeed(
      title: 'PHP',
      category: 'Языки',
      description:
          'Язык серверной веб-разработки, часто используется с Laravel.',
      syntax: r'$name = "web";',
      example: r'echo $name;'),
  ReferenceSeed(
      title: 'Ruby',
      category: 'Языки',
      description:
          'Динамический язык, известный веб-фреймворком Ruby on Rails.',
      syntax: 'name = "Ruby"',
      example: 'puts name'),
  ReferenceSeed(
      title: 'R',
      category: 'Языки',
      description: 'Язык анализа данных, статистики и визуализации.',
      syntax: 'scores <- c(80, 90)',
      example: 'mean(scores)'),
  ReferenceSeed(
      title: 'HTML',
      category: 'Frontend',
      description: 'Язык разметки, который задает структуру веб-страницы.',
      syntax: '<button>Start</button>',
      example: '<h1>CodeMentor</h1>'),
  ReferenceSeed(
      title: 'CSS',
      category: 'Frontend',
      description: 'Язык стилей для цветов, размеров, отступов и адаптивности.',
      syntax: '.card { padding: 16px; }',
      example: 'display: flex;'),
  ReferenceSeed(
      title: 'DOM',
      category: 'Frontend',
      description:
          'Дерево HTML-элементов, с которым JavaScript работает в браузере.',
      syntax: 'document.querySelector(".card")',
      example: 'element.textContent = "Done";'),
  ReferenceSeed(
      title: 'Flexbox',
      category: 'Frontend',
      description:
          'CSS-механизм для выравнивания элементов в строку или колонку.',
      syntax: 'display: flex;',
      example: 'justify-content: space-between;'),
  ReferenceSeed(
      title: 'CSS Grid',
      category: 'Frontend',
      description:
          'CSS-сетка для двумерной раскладки карточек и областей страницы.',
      syntax: 'display: grid;',
      example: 'grid-template-columns: repeat(2, 1fr);'),
  ReferenceSeed(
      title: 'React',
      category: 'Frontend',
      description: 'Библиотека JavaScript для компонентных интерфейсов.',
      syntax: 'function App() { return <h1/> }',
      example: '<Button title="Start" />'),
  ReferenceSeed(
      title: 'Vue',
      category: 'Frontend',
      description: 'Фреймворк для реактивных веб-интерфейсов.',
      syntax: 'v-if="visible"',
      example: '{{ title }}'),
  ReferenceSeed(
      title: 'Angular',
      category: 'Frontend',
      description: 'Фреймворк TypeScript для больших frontend-приложений.',
      syntax: '*ngFor="let item of items"',
      example: '{{ user.name }}'),
  ReferenceSeed(
      title: 'Flutter Widget',
      category: 'Dart/Flutter',
      description: 'Описание элемента интерфейса во Flutter.',
      syntax: 'Text("Hello")',
      example: 'Column(children: [])'),
  ReferenceSeed(
      title: 'StatefulWidget',
      category: 'Dart/Flutter',
      description: 'Виджет Flutter, который хранит и обновляет состояние.',
      syntax: 'setState(() {})',
      example: 'counter++'),
  ReferenceSeed(
      title: 'Provider',
      category: 'Dart/Flutter',
      description: 'Подход к передаче состояния в дереве Flutter-виджетов.',
      syntax: 'context.watch<T>()',
      example: 'ChangeNotifierProvider(...)'),
  ReferenceSeed(
      title: 'Future',
      category: 'Dart/Flutter',
      description: 'Результат асинхронной операции в Dart.',
      syntax: 'Future<String>',
      example: 'await fetchData()'),
  ReferenceSeed(
      title: 'async/await',
      category: 'Общие',
      description: 'Синтаксис для удобной работы с асинхронным кодом.',
      syntax: 'await request()',
      example: 'final data = await api.load();'),
  ReferenceSeed(
      title: 'Promise',
      category: 'JavaScript',
      description:
          'Объект будущего результата асинхронной операции в JavaScript.',
      syntax: 'fetch(url).then(...)',
      example: 'await fetch("/api")'),
  ReferenceSeed(
      title: 'Node.js',
      category: 'Backend',
      description: 'Среда выполнения JavaScript вне браузера.',
      syntax: 'node server.js',
      example: 'npm run dev'),
  ReferenceSeed(
      title: 'Express',
      category: 'Backend',
      description: 'Минималистичный backend-фреймворк для Node.js.',
      syntax: 'app.get("/api", handler)',
      example: 'res.json({ ok: true })'),
  ReferenceSeed(
      title: 'Spring Boot',
      category: 'Backend',
      description: 'Java-фреймворк для создания backend-сервисов.',
      syntax: '@RestController',
      example: '@GetMapping("/users")'),
  ReferenceSeed(
      title: 'ASP.NET Core',
      category: 'Backend',
      description: 'Платформа C# для веб-сервисов и API.',
      syntax: 'app.MapGet("/", ...)',
      example: 'return Results.Ok(data);'),
  ReferenceSeed(
      title: 'Django',
      category: 'Backend',
      description: 'Python-фреймворк для веб-приложений с ORM и админкой.',
      syntax: 'python manage.py runserver',
      example: 'class User(models.Model):'),
  ReferenceSeed(
      title: 'Laravel',
      category: 'Backend',
      description: 'PHP-фреймворк для веб-приложений и API.',
      syntax: 'Route::get(...)',
      example: 'php artisan serve'),
  ReferenceSeed(
      title: 'REST API',
      category: 'Веб',
      description: 'Стиль API, где ресурсы доступны через HTTP-методы.',
      syntax: 'GET /users',
      example: 'POST /lessons'),
  ReferenceSeed(
      title: 'GraphQL',
      category: 'Веб',
      description: 'Язык запросов к API, где клиент выбирает нужные поля.',
      syntax: 'query { users { name } }',
      example: 'mutation CreateUser'),
  ReferenceSeed(
      title: 'WebSocket',
      category: 'Веб',
      description: 'Постоянное соединение для чатов, игр и real-time данных.',
      syntax: 'new WebSocket(url)',
      example: 'socket.send(message)'),
  ReferenceSeed(
      title: 'JWT',
      category: 'Безопасность',
      description: 'Токен для передачи информации об авторизации пользователя.',
      syntax: 'Authorization: Bearer token',
      example: 'jwt.sign(payload)'),
  ReferenceSeed(
      title: 'OAuth',
      category: 'Безопасность',
      description: 'Протокол авторизации через внешние сервисы.',
      syntax: 'client_id + redirect_uri',
      example: 'Login with Google'),
  ReferenceSeed(
      title: 'Hash',
      category: 'Безопасность',
      description:
          'Одностороннее преобразование данных, полезное для паролей и проверок.',
      syntax: 'SHA-256',
      example: 'hash(password)'),
  ReferenceSeed(
      title: 'PostgreSQL',
      category: 'Данные',
      description:
          'Надежная реляционная база данных с SQL и расширенными типами.',
      syntax: 'CREATE TABLE users (...)',
      example: 'SELECT * FROM users;'),
  ReferenceSeed(
      title: 'MySQL',
      category: 'Данные',
      description: 'Популярная реляционная база данных для веб-приложений.',
      syntax: 'SELECT id FROM users',
      example: 'INSERT INTO users VALUES (...)'),
  ReferenceSeed(
      title: 'MongoDB',
      category: 'Данные',
      description:
          'Документная NoSQL-база, которая хранит JSON-подобные документы.',
      syntax: 'db.users.find({})',
      example: '{ "name": "Ali" }'),
  ReferenceSeed(
      title: 'Redis',
      category: 'Данные',
      description: 'Быстрое key-value хранилище для кэша, очередей и сессий.',
      syntax: 'SET key value',
      example: 'GET user:1'),
  ReferenceSeed(
      title: 'ORM',
      category: 'Данные',
      description:
          'Слой, который связывает объекты языка с таблицами базы данных.',
      syntax: 'User.findAll()',
      example: 'repository.save(user)'),
  ReferenceSeed(
      title: 'JOIN',
      category: 'SQL',
      description: 'Оператор SQL для объединения строк из нескольких таблиц.',
      syntax: 'INNER JOIN table ON ...',
      example: 'users JOIN orders'),
  ReferenceSeed(
      title: 'GROUP BY',
      category: 'SQL',
      description: 'Группировка строк для подсчета, суммы и других агрегатов.',
      syntax: 'GROUP BY user_id',
      example: 'COUNT(*)'),
  ReferenceSeed(
      title: 'Index',
      category: 'SQL',
      description: 'Структура базы данных для ускорения поиска по столбцам.',
      syntax: 'CREATE INDEX idx_name ON users(name)',
      example: 'поиск по email быстрее'),
  ReferenceSeed(
      title: 'Git',
      category: 'Инструменты',
      description: 'Система контроля версий для истории изменений проекта.',
      syntax: 'git status',
      example: 'git commit -m "feat"'),
  ReferenceSeed(
      title: 'Branch',
      category: 'Git',
      description: 'Отдельная линия разработки в Git.',
      syntax: 'git checkout -b feature',
      example: 'feature/auth'),
  ReferenceSeed(
      title: 'Pull Request',
      category: 'Git',
      description: 'Запрос на проверку и слияние изменений в общий код.',
      syntax: 'PR -> review -> merge',
      example: 'проверка новой функции'),
  ReferenceSeed(
      title: 'Docker',
      category: 'DevOps',
      description: 'Инструмент упаковки приложения и зависимостей в контейнер.',
      syntax: 'docker build .',
      example: 'docker run app'),
  ReferenceSeed(
      title: 'CI/CD',
      category: 'DevOps',
      description: 'Автоматическая проверка, сборка и доставка приложения.',
      syntax: 'push -> test -> deploy',
      example: 'GitHub Actions'),
  ReferenceSeed(
      title: 'Kubernetes',
      category: 'DevOps',
      description: 'Платформа управления контейнерами в кластере.',
      syntax: 'kubectl apply -f app.yaml',
      example: 'Deployment + Service'),
  ReferenceSeed(
      title: 'Unit test',
      category: 'Тестирование',
      description:
          'Тест маленькой части программы: функции, класса или компонента.',
      syntax: 'expect(result).toBe(5)',
      example: 'проверка суммы'),
  ReferenceSeed(
      title: 'Integration test',
      category: 'Тестирование',
      description: 'Тест взаимодействия нескольких частей приложения.',
      syntax: 'open app -> tap -> expect',
      example: 'логин через API'),
  ReferenceSeed(
      title: 'TDD',
      category: 'Тестирование',
      description: 'Подход, где сначала пишут тест, потом код.',
      syntax: 'red -> green -> refactor',
      example: 'тест на edge case'),
  ReferenceSeed(
      title: 'Algorithm',
      category: 'Алгоритмы',
      description: 'Пошаговый способ решения задачи.',
      syntax: 'input -> steps -> output',
      example: 'поиск максимума'),
  ReferenceSeed(
      title: 'Big O',
      category: 'Алгоритмы',
      description:
          'Оценка роста времени или памяти при увеличении входных данных.',
      syntax: 'O(n), O(log n)',
      example: 'линейный поиск O(n)'),
  ReferenceSeed(
      title: 'Stack',
      category: 'Структуры данных',
      description: 'Структура данных LIFO: последним пришел, первым ушел.',
      syntax: 'push / pop',
      example: 'история действий'),
  ReferenceSeed(
      title: 'Queue',
      category: 'Структуры данных',
      description: 'Структура данных FIFO: первым пришел, первым ушел.',
      syntax: 'enqueue / dequeue',
      example: 'очередь задач'),
  ReferenceSeed(
      title: 'HashMap',
      category: 'Структуры данных',
      description: 'Коллекция ключ-значение для быстрого доступа по ключу.',
      syntax: 'map[key] = value',
      example: 'userById[42]'),
  ReferenceSeed(
      title: 'Binary search',
      category: 'Алгоритмы',
      description:
          'Быстрый поиск в отсортированном массиве через деление пополам.',
      syntax: 'left, mid, right',
      example: 'O(log n)'),
  ReferenceSeed(
      title: 'Recursion',
      category: 'Алгоритмы',
      description:
          'Прием, где функция вызывает саму себя для меньшей подзадачи.',
      syntax: 'function f() { f(); }',
      example: 'factorial(n)'),
  ReferenceSeed(
      title: 'OOP',
      category: 'Архитектура',
      description:
          'Объектно-ориентированный подход: классы, объекты, наследование.',
      syntax: 'class User {}',
      example: 'user.login()'),
  ReferenceSeed(
      title: 'SOLID',
      category: 'Архитектура',
      description: 'Набор принципов для поддерживаемого объектного кода.',
      syntax: 'SRP, OCP, LSP, ISP, DIP',
      example: 'один класс - одна ответственность'),
  ReferenceSeed(
      title: 'MVC',
      category: 'Архитектура',
      description: 'Разделение приложения на Model, View и Controller.',
      syntax: 'Model / View / Controller',
      example: 'контроллер обрабатывает запрос'),
  ReferenceSeed(
      title: 'MVVM',
      category: 'Архитектура',
      description: 'Паттерн с ViewModel между интерфейсом и данными.',
      syntax: 'View -> ViewModel -> Model',
      example: 'state для экрана'),
  ReferenceSeed(
      title: 'Dependency Injection',
      category: 'Архитектура',
      description: 'Передача зависимостей извне вместо создания внутри класса.',
      syntax: 'constructor(service)',
      example: 'AuthController(authService)'),
  ReferenceSeed(
      title: 'Microservices',
      category: 'Архитектура',
      description: 'Разделение системы на небольшие независимые сервисы.',
      syntax: 'service A -> service B',
      example: 'users-service'),
  ReferenceSeed(
      title: 'CLI',
      category: 'Инструменты',
      description:
          'Интерфейс командной строки для запуска инструментов и сборок.',
      syntax: 'command --flag',
      example: 'flutter build apk'),
  ReferenceSeed(
      title: 'Package manager',
      category: 'Инструменты',
      description: 'Инструмент установки зависимостей проекта.',
      syntax: 'npm install / pub add',
      example: 'flutter pub add http'),
  ReferenceSeed(
      title: 'Compiler',
      category: 'Общие',
      description:
          'Программа, которая переводит исходный код в исполняемый формат.',
      syntax: 'source -> binary',
      example: 'javac Main.java'),
  ReferenceSeed(
      title: 'Interpreter',
      category: 'Общие',
      description:
          'Программа, которая выполняет код без отдельной полной компиляции.',
      syntax: 'python script.py',
      example: 'Node.js выполняет JS'),
];

const practiceTasks = <PracticeTask>[
  PracticeTask(
    title: 'Сумма бонусов',
    topic: 'Переменные',
    prompt: 'Какой вывод будет у программы?',
    code: 'xp = 40\nbonus = 15\nprint(xp + bonus)',
    answer: '55',
    hint: 'Сложи значения двух переменных.',
    color: AppColors.green,
  ),
  PracticeTask(
    title: 'Порог зачета',
    topic: 'Условия',
    prompt: 'Что напечатает программа при score = 62?',
    code:
        "score = 62\nif score >= 70:\n    print('strong')\nelse:\n    print('practice')",
    answer: 'practice',
    hint: '62 меньше 70, значит выполнится else.',
    color: AppColors.amber,
  ),
  PracticeTask(
    title: 'Цикл range',
    topic: 'Циклы',
    prompt: 'Укажи последний вывод программы.',
    code: 'for n in range(1, 4):\n    print(n)',
    answer: '3',
    hint: 'range(1, 4) дает 1, 2, 3.',
    color: AppColors.cyan,
  ),
  PracticeTask(
    title: 'Поиск ошибки',
    topic: 'Отладка',
    prompt: 'Какое имя переменной нужно использовать в print?',
    code: 'total_score = 90\nprint(totla_score)',
    answer: 'total_score',
    hint: 'В print переставлены буквы.',
    color: AppColors.rose,
  ),
  PracticeTask(
    title: 'Функция с return',
    topic: 'Функции',
    prompt: 'Какой результат вернет программа?',
    code: 'def double(value):\n    return value * 2\n\nprint(double(6))',
    answer: '12',
    hint: 'Функция умножает аргумент на 2.',
    color: AppColors.violet,
  ),
  PracticeTask(
    title: 'Список и индекс',
    topic: 'Коллекции',
    prompt: 'Что будет выведено на экран?',
    code: "topics = ['print', 'if', 'for']\nprint(topics[1])",
    answer: 'if',
    hint: 'Индексация начинается с 0.',
    color: AppColors.primary,
  ),
  PracticeTask(
    title: 'Логика условий',
    topic: 'Условия',
    prompt: 'Какой текст напечатает программа?',
    code:
        "score = 82\nactive = True\nif score >= 80 and active:\n    print('mentor')\nelse:\n    print('repeat')",
    answer: 'mentor',
    hint: 'Обе части условия истинны.',
    color: AppColors.teal,
  ),
  PracticeTask(
    title: 'JavaScript const',
    topic: 'JavaScript',
    prompt: 'Что выведет код?',
    code: "const score = 7;\nconsole.log(score + 3);",
    answer: '10',
    hint:
        'Сложи 7 и 3. const запрещает переназначение, но значение читать можно.',
    color: AppColors.amber,
  ),
  PracticeTask(
    title: 'TypeScript тип',
    topic: 'TypeScript',
    prompt: 'Какой тип указан у переменной score?',
    code: 'let score: number = 90;',
    answer: 'number',
    hint: 'Тип стоит после двоеточия.',
    color: AppColors.primary,
  ),
  PracticeTask(
    title: 'HTML тег',
    topic: 'Frontend',
    prompt: 'Какой тег создает кнопку?',
    code: '<button>Start</button>',
    answer: 'button',
    hint: 'Название тега находится между < и >.',
    color: AppColors.cyan,
  ),
  PracticeTask(
    title: 'CSS flex',
    topic: 'Frontend',
    prompt: 'Какое значение display включает flexbox?',
    code: '.toolbar {\n  display: flex;\n}',
    answer: 'flex',
    hint: 'Посмотри значение после display.',
    color: AppColors.green,
  ),
  PracticeTask(
    title: 'SQL SELECT',
    topic: 'SQL',
    prompt: 'Какое слово выбирает данные из таблицы?',
    code: 'SELECT name FROM students WHERE score >= 80;',
    answer: 'select',
    hint: 'Это первое слово запроса.',
    color: AppColors.green,
  ),
  PracticeTask(
    title: 'Java класс',
    topic: 'Java',
    prompt: 'Какое ключевое слово объявляет класс?',
    code: 'public class Student {\n}',
    answer: 'class',
    hint: 'Оно стоит перед названием Student.',
    color: AppColors.rose,
  ),
  PracticeTask(
    title: 'C# вывод',
    topic: 'C#',
    prompt: 'Что будет выведено?',
    code: 'int level = 2;\nConsole.WriteLine(level + 1);',
    answer: '3',
    hint: '2 + 1 = 3.',
    color: AppColors.violet,
  ),
  PracticeTask(
    title: 'C++ ссылка',
    topic: 'C++',
    prompt: 'Какое значение станет у score после ref = 15?',
    code: 'int score = 10;\nint& ref = score;\nref = 15;',
    answer: '15',
    hint: 'Ссылка ref работает с тем же объектом score.',
    color: AppColors.teal,
  ),
  PracticeTask(
    title: 'Go goroutine',
    topic: 'Go',
    prompt: 'Какое ключевое слово запускает goroutine?',
    code: 'go sendReport()',
    answer: 'go',
    hint: 'Оно стоит перед вызовом функции.',
    color: AppColors.cyan,
  ),
  PracticeTask(
    title: 'Rust let',
    topic: 'Rust',
    prompt: 'Какое ключевое слово создает переменную?',
    code: 'let score = 100;',
    answer: 'let',
    hint: 'Первое слово строки.',
    color: AppColors.rose,
  ),
  PracticeTask(
    title: 'Dart final',
    topic: 'Dart/Flutter',
    prompt: 'Какое ключевое слово создает значение без переназначения?',
    code: "final title = 'CodeMentor';",
    answer: 'final',
    hint: 'Оно стоит перед именем переменной.',
    color: AppColors.primary,
  ),
  PracticeTask(
    title: 'Kotlin val',
    topic: 'Kotlin',
    prompt: 'Какое ключевое слово в Kotlin похоже на final?',
    code: 'val name = "Ali"',
    answer: 'val',
    hint: 'Это первое слово строки.',
    color: AppColors.green,
  ),
  PracticeTask(
    title: 'Swift let',
    topic: 'Swift',
    prompt: 'Какое ключевое слово создает константу?',
    code: 'let name = "iOS"',
    answer: 'let',
    hint: 'В Swift let используют для констант.',
    color: AppColors.cyan,
  ),
  PracticeTask(
    title: 'Git commit',
    topic: 'Git',
    prompt: 'Какая команда сохраняет изменения в истории?',
    code: 'git commit -m "add lesson"',
    answer: 'commit',
    hint: 'Это второе слово команды.',
    color: AppColors.amber,
  ),
  PracticeTask(
    title: 'Docker build',
    topic: 'DevOps',
    prompt: 'Какое слово запускает сборку образа?',
    code: 'docker build .',
    answer: 'build',
    hint: 'Команда состоит из docker и действия.',
    color: AppColors.violet,
  ),
];

class CodeMentorApp extends StatefulWidget {
  const CodeMentorApp({super.key});

  @override
  State<CodeMentorApp> createState() => _CodeMentorAppState();
}

class _CodeMentorAppState extends State<CodeMentorApp> {
  static bool googleSignInInitialized = false;

  static const completedKey = 'codementor_completed';
  static const xpKey = 'codementor_xp';
  static const streakKey = 'codementor_streak';
  static const dateKey = 'codementor_last_open';
  static const nameKey = 'codementor_name';
  static const themeKey = 'codementor_theme';
  static const dailyGoalKey = 'codementor_daily_goal';

  final navigatorKey = GlobalKey<NavigatorState>();

  bool get firebaseReady => Firebase.apps.isNotEmpty;
  FirebaseAuth? get firebaseAuth =>
      firebaseReady ? FirebaseAuth.instance : null;
  FirebaseFirestore? get firebaseFirestore =>
      firebaseReady ? FirebaseFirestore.instance : null;

  int tab = 0;
  int xp = 0;
  int streak = 1;
  String studentName = 'Студент';
  Set<String> completed = {};
  bool loaded = false;
  bool authBusy = false;
  bool cloudBusy = false;
  User? user;
  ThemeMode themeMode = ThemeMode.system;
  int dailyGoal = 25;
  StreamSubscription<User?>? authSubscription;

  @override
  void initState() {
    super.initState();
    _initAuth();
    _load();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initAuth() async {
    final auth = firebaseAuth;
    if (auth == null) return;
    if (!googleSignInInitialized) {
      await GoogleSignIn.instance.initialize();
      googleSignInInitialized = true;
    }
    authSubscription = auth.authStateChanges().listen((nextUser) async {
      if (!mounted) return;
      setState(() => user = nextUser);
      if (nextUser != null) {
        await _loadCloudProgress(nextUser);
      }
    });
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCompleted = prefs.getStringList(completedKey)?.toSet() ?? {};
    final savedXp = prefs.getInt(xpKey) ?? 0;
    var savedStreak = prefs.getInt(streakKey) ?? 1;
    final today = _day(DateTime.now());
    final lastOpen = prefs.getString(dateKey);

    if (lastOpen != today) {
      final yesterday = _day(DateTime.now().subtract(const Duration(days: 1)));
      savedStreak = lastOpen == yesterday ? savedStreak + 1 : 1;
      await prefs.setString(dateKey, today);
      await prefs.setInt(streakKey, savedStreak);
    }

    if (!mounted) return;
    setState(() {
      completed = savedCompleted;
      xp = savedXp;
      streak = savedStreak;
      studentName = prefs.getString(nameKey) ?? 'Студент';
      themeMode = _themeModeFromString(prefs.getString(themeKey));
      dailyGoal = prefs.getInt(dailyGoalKey) ?? 25;
      loaded = true;
    });
  }

  String _day(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  void completeLesson(Lesson lesson) {
    if (completed.contains(lesson.id)) return;
    setState(() {
      completed = {...completed, lesson.id};
      xp += lesson.xp;
    });
    _saveProgress();
  }

  void addPracticeXp() {
    setState(() => xp += 10);
    _saveProgress();
  }

  void rename(String value) {
    final text = value.trim();
    if (text.length < 2) return;
    setState(() => studentName = text);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(nameKey, text);
    });
    _saveProgress();
  }

  void changeThemeMode(ThemeMode value) {
    setState(() => themeMode = value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(themeKey, value.name);
    });
    _saveProgress();
  }

  void resetProgress() {
    setState(() {
      completed = {};
      xp = 0;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(completedKey);
      prefs.remove(xpKey);
    });
    _saveProgress();
  }

  void changeDailyGoal(int value) {
    final normalized = value.clamp(10, 90).toInt();
    setState(() => dailyGoal = normalized);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(dailyGoalKey, normalized);
    });
    _saveProgress();
  }

  ThemeMode _themeModeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void _saveProgress() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList(completedKey, completed.toList());
      prefs.setInt(xpKey, xp);
    });
    _saveCloudProgress();
  }

  DocumentReference<Map<String, dynamic>> _userDoc(User targetUser) =>
      firebaseFirestore!.collection('users').doc(targetUser.uid);

  Future<void> signInWithGoogle() async {
    if (authBusy) return;
    final auth = firebaseAuth;
    if (auth == null) {
      showAppSnack(context, 'Firebase не инициализирован');
      return;
    }
    setState(() => authBusy = true);
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      if (mounted) showAppSnack(context, 'Вход выполнен');
    } catch (error) {
      if (mounted) showAppSnack(context, 'Не удалось войти: $error');
    } finally {
      if (mounted) setState(() => authBusy = false);
    }
  }

  Future<void> signOut() async {
    if (authBusy) return;
    final auth = firebaseAuth;
    if (auth == null) return;
    setState(() => authBusy = true);
    try {
      await GoogleSignIn.instance.signOut();
      await auth.signOut();
      if (mounted) showAppSnack(context, 'Вы вышли из аккаунта');
    } catch (error) {
      if (mounted) showAppSnack(context, 'Не удалось выйти: $error');
    } finally {
      if (mounted) setState(() => authBusy = false);
    }
  }

  Future<void> _loadCloudProgress(User targetUser) async {
    if (firebaseFirestore == null) return;
    setState(() => cloudBusy = true);
    try {
      final snapshot = await _userDoc(targetUser).get();
      if (!snapshot.exists) {
        await _saveCloudProgress();
        return;
      }
      final data = snapshot.data() ?? {};
      final cloudCompleted =
          (data['completed'] as List?)?.whereType<String>().toSet() ?? {};
      final cloudXp = data['xp'] is int ? data['xp'] as int : 0;
      final cloudStreak = data['streak'] is int ? data['streak'] as int : 1;
      final cloudName = data['studentName'] as String?;
      final cloudDailyGoal =
          data['dailyGoal'] is int ? data['dailyGoal'] as int : dailyGoal;
      final cloudTheme = data['themeMode'] as String?;

      if (!mounted) return;
      setState(() {
        completed = {...completed, ...cloudCompleted};
        xp = max(xp, cloudXp);
        streak = max(streak, cloudStreak);
        if (cloudName != null && cloudName.trim().isNotEmpty) {
          studentName = cloudName;
        } else if ((targetUser.displayName ?? '').trim().isNotEmpty) {
          studentName = targetUser.displayName!;
        }
        dailyGoal = cloudDailyGoal;
        themeMode = _themeModeFromString(cloudTheme);
      });
      await _saveProgressLocalOnly();
      await _saveCloudProgress();
      if (mounted) showAppSnack(context, 'Прогресс загружен из аккаунта');
    } catch (error) {
      if (mounted) showAppSnack(context, 'Не удалось загрузить облако: $error');
    } finally {
      if (mounted) setState(() => cloudBusy = false);
    }
  }

  Future<void> _saveProgressLocalOnly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(completedKey, completed.toList());
    await prefs.setInt(xpKey, xp);
    await prefs.setInt(streakKey, streak);
    await prefs.setString(nameKey, studentName);
    await prefs.setInt(dailyGoalKey, dailyGoal);
    await prefs.setString(themeKey, themeMode.name);
  }

  Future<void> _saveCloudProgress() async {
    final currentUser = user;
    if (currentUser == null || firebaseFirestore == null) return;
    try {
      await _userDoc(currentUser).set({
        'uid': currentUser.uid,
        'email': currentUser.email,
        'displayName': currentUser.displayName,
        'photoUrl': currentUser.photoURL,
        'studentName': studentName,
        'completed': completed.toList()..sort(),
        'xp': xp,
        'streak': streak,
        'dailyGoal': dailyGoal,
        'themeMode': themeMode.name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Offline mode keeps local progress; the next successful action can sync.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeMentor AI',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: themeMode,
      home: loaded
          ? Scaffold(
              body: IndexedStack(
                index: tab,
                children: [
                  HomeScreen(
                    name: studentName,
                    xp: xp,
                    streak: streak,
                    completed: completed,
                    onTab: (value) => setState(() => tab = value),
                    onRename: rename,
                    themeMode: themeMode,
                    onThemeModeChanged: changeThemeMode,
                    onResetProgress: resetProgress,
                    dailyGoal: dailyGoal,
                    onDailyGoalChanged: changeDailyGoal,
                    user: user,
                    authBusy: authBusy,
                    cloudBusy: cloudBusy,
                    onSignIn: signInWithGoogle,
                    onSignOut: signOut,
                  ),
                  LessonsScreen(
                    completed: completed,
                    onOpen: (lesson) => navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(
                          lesson: lesson,
                          isCompleted: completed.contains(lesson.id),
                          onComplete: completeLesson,
                        ),
                      ),
                    ),
                  ),
                  PracticeScreen(onCorrect: addPracticeXp),
                  const ReferenceScreen(),
                  const AiMentorScreen(),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                height: 68,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: tab,
                onDestinationSelected: (value) => setState(() => tab = value),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard_rounded),
                    label: 'Главная',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.menu_book_outlined),
                    selectedIcon: Icon(Icons.menu_book_rounded),
                    label: 'Уроки',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.code_rounded),
                    selectedIcon: Icon(Icons.integration_instructions_rounded),
                    label: 'Практика',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search_rounded),
                    selectedIcon: Icon(Icons.manage_search_rounded),
                    label: 'Справочник',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.auto_awesome_outlined),
                    selectedIcon: Icon(Icons.auto_awesome_rounded),
                    label: 'ИИ',
                  ),
                ],
              ),
            )
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.green,
        surface: dark ? AppColors.darkSurface : AppColors.surface,
      ),
      scaffoldBackgroundColor: dark ? AppColors.darkBg : AppColors.bg,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: dark ? AppColors.darkBg : AppColors.bg,
        foregroundColor: dark ? AppColors.darkText : AppColors.text,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: dark ? AppColors.darkSurface : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: dark ? AppColors.darkLine : AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkSurface : AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: dark ? AppColors.darkLine : AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: dark ? AppColors.darkLine : AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? AppColors.darkSurface : AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String name;
  final int xp;
  final int streak;
  final Set<String> completed;
  final ValueChanged<int> onTab;
  final ValueChanged<String> onRename;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onResetProgress;
  final int dailyGoal;
  final ValueChanged<int> onDailyGoalChanged;
  final User? user;
  final bool authBusy;
  final bool cloudBusy;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;

  const HomeScreen({
    super.key,
    required this.name,
    required this.xp,
    required this.streak,
    required this.completed,
    required this.onTab,
    required this.onRename,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onResetProgress,
    required this.dailyGoal,
    required this.onDailyGoalChanged,
    required this.user,
    required this.authBusy,
    required this.cloudBusy,
    required this.onSignIn,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final progress = completed.length / lessons.length;
    final nextLesson = lessons.firstWhere(
      (lesson) => !completed.contains(lesson.id),
      orElse: () => lessons.last,
    );
    final totalXp = lessons.fold<int>(0, (total, lesson) => total + lesson.xp);
    final courseProgress = totalXp == 0 ? 0.0 : (xp / totalXp).clamp(0.0, 1.0);
    final level = xp ~/ 120 + 1;
    final levelStart = (level - 1) * 120;
    final levelProgress = ((xp - levelStart) / 120).clamp(0.0, 1.0);
    final achievements = [
      Achievement(
        title: 'Первый шаг',
        description: 'Пройди 1 урок',
        icon: Icons.flag_rounded,
        color: AppColors.green,
        unlocked: completed.isNotEmpty,
        progress: completed.isEmpty ? 0 : 1,
        total: 1,
      ),
      Achievement(
        title: 'Серия',
        description: '3 дня подряд',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.rose,
        unlocked: streak >= 3,
        progress: streak > 3 ? 3 : streak,
        total: 3,
      ),
      Achievement(
        title: 'Практик',
        description: '100 XP',
        icon: Icons.bolt_rounded,
        color: AppColors.amber,
        unlocked: xp >= 100,
        progress: xp > 100 ? 100 : xp,
        total: 100,
      ),
      Achievement(
        title: 'Финалист',
        description: 'Все уроки',
        icon: Icons.workspace_premium_rounded,
        color: AppColors.violet,
        unlocked: completed.length == lessons.length,
        progress: completed.length,
        total: lessons.length,
      ),
    ];

    return SafeArea(
      child: ListView(
        padding: pagePadding(context),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CodeMentor AI',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Привет, $name. Сегодня тренируем мышление разработчика.',
                      style: TextStyle(color: muted(context)),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => showProfileSheet(context),
                icon: const Icon(Icons.person_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _AccountCard(
            user: user,
            authBusy: authBusy,
            cloudBusy: cloudBusy,
            onSignIn: onSignIn,
            onSignOut: onSignOut,
          ),
          const SizedBox(height: 14),
          _HeroPanel(
            progress: progress,
            completed: completed.length,
            xp: xp,
            streak: streak,
            onStart: () => onTab(1),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.bolt_rounded,
                  value: '$xp',
                  label: 'XP',
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.local_fire_department_rounded,
                  value: '$streak',
                  label: 'Дней',
                  color: AppColors.rose,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.verified_rounded,
                  value: '${completed.length}',
                  label: 'Уроков',
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _LevelCard(
            level: level,
            xp: xp,
            nextLevelXp: level * 120,
            progress: levelProgress,
            courseProgress: courseProgress,
          ),
          const SizedBox(height: 14),
          _DailyCoachCard(
            nextLesson: nextLesson,
            streak: streak,
            onPractice: () => onTab(2),
            onMentor: () => onTab(4),
          ),
          const SizedBox(height: 14),
          _StudyPulseCard(
            xp: xp,
            streak: streak,
            completed: completed.length,
            dailyGoal: dailyGoal,
          ),
          const SizedBox(height: 14),
          _FocusTimerCard(dailyGoal: dailyGoal),
          const SizedBox(height: 22),
          _SectionTitle(
            title: 'План на 5 дней',
            action: 'Учиться',
            onAction: () => onTab(1),
          ),
          const SizedBox(height: 10),
          const _StudyPlanStrip(),
          const SizedBox(height: 22),
          _SkillMapCard(completed: completed),
          const SizedBox(height: 14),
          const _DefenseChecklistCard(),
          const SizedBox(height: 22),
          _SectionTitle(
            title: 'Достижения',
            action:
                '${achievements.where((item) => item.unlocked).length}/${achievements.length}',
          ),
          const SizedBox(height: 10),
          _AchievementStrip(achievements: achievements),
          const SizedBox(height: 22),
          _SectionTitle(
            title: 'Следующий шаг',
            action: 'Все уроки',
            onAction: () => onTab(1),
          ),
          const SizedBox(height: 10),
          _NextLessonCard(lesson: nextLesson, onTap: () => onTab(1)),
          const SizedBox(height: 22),
          Text('Быстрые действия',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isCompact(context) ? 2 : 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isCompact(context) ? 1.18 : 1.48,
            children: [
              _ActionCard(
                icon: Icons.integration_instructions_rounded,
                title: 'Решить задачу',
                subtitle: 'Мини-практика',
                color: AppColors.cyan,
                onTap: () => onTab(2),
              ),
              _ActionCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Спросить ИИ',
                subtitle: 'Разбор ошибки',
                color: AppColors.violet,
                onTap: () => onTab(4),
              ),
              _ActionCard(
                icon: Icons.manage_search_rounded,
                title: 'Термины',
                subtitle: 'Быстрый поиск',
                color: AppColors.green,
                onTap: () => onTab(3),
              ),
              _ActionCard(
                icon: Icons.bug_report_rounded,
                title: 'Отладка',
                subtitle: 'Найти причину',
                color: AppColors.rose,
                onTap: () => onTab(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showProfileSheet(BuildContext context) {
    final controller = TextEditingController(text: name);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            18,
            4,
            18,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Профиль обучения',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Имя студента',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              _ThemeSelector(
                value: themeMode,
                onChanged: (value) {
                  onThemeModeChanged(value);
                  showAppSnack(context, 'Тема обновлена');
                },
              ),
              const SizedBox(height: 14),
              _DailyGoalSelector(
                value: dailyGoal,
                onChanged: onDailyGoalChanged,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.bolt_rounded,
                      value: '$xp XP',
                      label: 'Опыт',
                      color: AppColors.amber,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.verified_rounded,
                      value: '${completed.length}/${lessons.length}',
                      label: 'Прогресс',
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    onRename(controller.text);
                    Navigator.pop(context);
                    showAppSnack(context, 'Профиль сохранен');
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Сохранить'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    onResetProgress();
                    Navigator.pop(context);
                    showAppSnack(context, 'Прогресс сброшен');
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Сбросить прогресс'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonsScreen extends StatefulWidget {
  final Set<String> completed;
  final ValueChanged<Lesson> onOpen;

  const LessonsScreen({
    super.key,
    required this.completed,
    required this.onOpen,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final search = TextEditingController();
  String selectedTrack = 'Все';
  String statusFilter = 'all';
  String query = '';

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracks = ['Все', ...lessons.map((lesson) => lesson.track).toSet()];
    final filtered = lessons.where((lesson) {
      final q = query.toLowerCase();
      final byTrack = selectedTrack == 'Все' || lesson.track == selectedTrack;
      final done = widget.completed.contains(lesson.id);
      final byStatus = statusFilter == 'all' ||
          (statusFilter == 'todo' && !done) ||
          (statusFilter == 'done' && done);
      final byQuery = q.isEmpty ||
          lesson.title.toLowerCase().contains(q) ||
          lesson.track.toLowerCase().contains(q) ||
          lesson.level.toLowerCase().contains(q) ||
          lesson.description.toLowerCase().contains(q);
      return byTrack && byStatus && byQuery;
    }).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Уроки программирования'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: _Pill(
                    label: '${widget.completed.length}/${lessons.length}',
                    color: AppColors.primary,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
              child: TextField(
                controller: search,
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: 'Найти урок, тему или уровень',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            search.clear();
                            setState(() => query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final track = tracks[index];
                  return ChoiceChip(
                    label: Text(track),
                    selected: track == selectedTrack,
                    onSelected: (_) => setState(() => selectedTrack = track),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: tracks.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: 'all',
                      icon: Icon(Icons.library_books_rounded),
                      label: Text('Все'),
                    ),
                    ButtonSegment(
                      value: 'todo',
                      icon: Icon(Icons.play_circle_outline_rounded),
                      label: Text('Новые'),
                    ),
                    ButtonSegment(
                      value: 'done',
                      icon: Icon(Icons.verified_rounded),
                      label: Text('Пройдены'),
                    ),
                  ],
                  selected: {statusFilter},
                  onSelectionChanged: (values) {
                    setState(() => statusFilter = values.first);
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
            sliver: filtered.isEmpty
                ? SliverToBoxAdapter(
                    child: _EmptyStateCard(
                      icon: Icons.search_off_rounded,
                      title: 'Ничего не найдено',
                      text: 'Попробуй другой запрос или сбрось фильтр темы.',
                      action: 'Сбросить',
                      onAction: () {
                        search.clear();
                        setState(() {
                          query = '';
                          selectedTrack = 'Все';
                          statusFilter = 'all';
                        });
                      },
                    ),
                  )
                : SliverList.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final lesson = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _LessonTile(
                          lesson: lesson,
                          index: lessons.indexOf(lesson) + 1,
                          done: widget.completed.contains(lesson.id),
                          onTap: () => widget.onOpen(lesson),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final bool isCompleted;
  final ValueChanged<Lesson> onComplete;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool completedNow = false;

  @override
  Widget build(BuildContext context) {
    final done = widget.isCompleted || completedNow;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lesson.title),
          actions: [
            if (done)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(
                  child: _Pill(
                    label: 'Пройден',
                    color: AppColors.green,
                    icon: Icons.verified_rounded,
                  ),
                ),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.auto_stories_rounded), text: 'Теория'),
              Tab(icon: Icon(Icons.code_rounded), text: 'Код'),
              Tab(icon: Icon(Icons.quiz_rounded), text: 'Тест'),
              Tab(icon: Icon(Icons.edit_note_rounded), text: 'Заметки'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TheoryTab(lesson: widget.lesson),
            _CodeTab(lesson: widget.lesson),
            _QuizTab(
              lesson: widget.lesson,
              onFinish: () {
                widget.onComplete(widget.lesson);
                setState(() => completedNow = true);
              },
            ),
            _LessonNotesTab(lesson: widget.lesson),
          ],
        ),
      ),
    );
  }
}

class _TheoryTab extends StatelessWidget {
  final Lesson lesson;

  const _TheoryTab({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        _LessonHeader(lesson: lesson),
        const SizedBox(height: 14),
        ...lesson.theory.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TheoryCard(
                  number: entry.key + 1,
                  text: entry.value,
                  color: lesson.color,
                ),
              ),
            ),
      ],
    );
  }
}

class _CodeTab extends StatelessWidget {
  final Lesson lesson;

  const _CodeTab({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        const _SectionTitle(title: 'Примеры кода'),
        const SizedBox(height: 10),
        ...lesson.samples.map(
          (sample) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CodeSampleCard(sample: sample, color: lesson.color),
          ),
        ),
      ],
    );
  }
}

class _QuizTab extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onFinish;

  const _QuizTab({required this.lesson, required this.onFinish});

  @override
  State<_QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<_QuizTab> {
  int index = 0;
  int correct = 0;
  int? selected;
  bool answered = false;
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    if (finished) {
      final score = (correct / widget.lesson.questions.length * 100).round();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: score >= 70 ? AppColors.green : AppColors.amber,
                size: 64,
              ),
              const SizedBox(height: 12),
              Text('$score%', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text('Правильно: $correct из ${widget.lesson.questions.length}'),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('К урокам'),
              ),
            ],
          ),
        ),
      );
    }

    final question = widget.lesson.questions[index];
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        LinearProgressIndicator(
          value: (index + 1) / widget.lesson.questions.length,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: widget.lesson.color,
          backgroundColor: widget.lesson.color.withValues(alpha: 0.15),
        ),
        const SizedBox(height: 20),
        Text(question.text, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        ...question.options.asMap().entries.map((entry) {
          final i = entry.key;
          final option = entry.value;
          final isCorrect = i == question.answer;
          final isPicked = selected == i;
          final showCorrect = answered && isCorrect;
          final showWrong = answered && isPicked && !isCorrect;
          final border = showCorrect
              ? AppColors.green
              : showWrong
                  ? AppColors.rose
                  : isPicked
                      ? widget.lesson.color
                      : line(context);
          final fill = showCorrect
              ? AppColors.green.withValues(alpha: 0.10)
              : showWrong
                  ? AppColors.rose.withValues(alpha: 0.10)
                  : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: answered ? null : () => answer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border, width: isPicked ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      showCorrect
                          ? Icons.check_circle_rounded
                          : showWrong
                              ? Icons.cancel_rounded
                              : isPicked
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                      color: border,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(option)),
                  ],
                ),
              ),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 8),
          _InfoBox(
            icon: Icons.lightbulb_outline_rounded,
            text: question.explanation,
            color: AppColors.amber,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: next,
            icon: Icon(
              index + 1 == widget.lesson.questions.length
                  ? Icons.flag_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              index + 1 == widget.lesson.questions.length
                  ? 'Завершить'
                  : 'Следующий вопрос',
            ),
          ),
        ],
      ],
    );
  }

  void answer(int value) {
    final question = widget.lesson.questions[index];
    setState(() {
      selected = value;
      answered = true;
      if (value == question.answer) correct++;
    });
  }

  void next() {
    if (index + 1 == widget.lesson.questions.length) {
      setState(() => finished = true);
      widget.onFinish();
      return;
    }
    setState(() {
      index++;
      selected = null;
      answered = false;
    });
  }
}

class _LessonNotesTab extends StatefulWidget {
  final Lesson lesson;

  const _LessonNotesTab({required this.lesson});

  @override
  State<_LessonNotesTab> createState() => _LessonNotesTabState();
}

class _LessonNotesTabState extends State<_LessonNotesTab> {
  late final TextEditingController controller;
  bool saved = true;

  String get key => 'codementor_note_${widget.lesson.id}';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    var note = prefs.getString(key) ?? '';
    final user =
        Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .doc(widget.lesson.id)
            .get();
        final cloudNote = snapshot.data()?['text'] as String?;
        if (cloudNote != null && cloudNote.trim().isNotEmpty) {
          note = cloudNote;
          await prefs.setString(key, cloudNote);
        }
      } catch (_) {}
    }
    if (!mounted) return;
    controller.text = note;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: pagePadding(context),
      children: [
        _InfoBox(
          icon: Icons.edit_note_rounded,
          text:
              'Запиши своими словами правило, частую ошибку и пример. Такие заметки хорошо смотрятся в дипломном прототипе и реально помогают учиться.',
          color: widget.lesson.color,
        ),
        const SizedBox(height: 14),
        TextField(
          controller: controller,
          minLines: 10,
          maxLines: 16,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Мои заметки по уроку',
            hintText: 'Например: чем отличается = от ==, где нужен отступ...',
          ),
          onChanged: (_) => setState(() => saved = false),
        ),
        const SizedBox(height: 12),
        _ButtonGrid(
          children: [
            FilledButton.icon(
              onPressed: save,
              icon: Icon(saved ? Icons.check_rounded : Icons.save_rounded),
              label: Text(saved ? 'Сохранено' : 'Сохранить'),
            ),
            OutlinedButton.icon(
              onPressed: copySummary,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Скопировать план'),
            ),
          ],
        ),
      ],
    );
  }

  void save() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, controller.text.trim());
    });
    final user =
        Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(widget.lesson.id)
          .set({
        'lessonId': widget.lesson.id,
        'lessonTitle': widget.lesson.title,
        'text': controller.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    setState(() => saved = true);
    showAppSnack(
        context,
        user == null
            ? 'Заметка сохранена локально'
            : 'Заметка сохранена в аккаунте');
  }

  void copySummary() {
    final text =
        'Урок: ${widget.lesson.title}\nТема: ${widget.lesson.track}\nЧто запомнить:\n${controller.text.trim()}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заметка скопирована')),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  final VoidCallback onCorrect;

  const PracticeScreen({super.key, required this.onCorrect});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final controller = TextEditingController();
  final random = Random();
  int index = 0;
  int correctSession = 0;
  int mistakesSession = 0;
  String selectedTopic = 'Все';
  bool hint = false;
  bool showAnswer = false;
  bool rewarded = false;
  String? result;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = ['Все', ...practiceTasks.map((task) => task.topic).toSet()];
    final filteredTasks = selectedTopic == 'Все'
        ? practiceTasks
        : practiceTasks.where((task) => task.topic == selectedTopic).toList();
    if (index >= filteredTasks.length) index = 0;
    final task = filteredTasks[index];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
        children: [
          Text('Практика', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Читай код, прогнозируй результат и проверяй себя.',
            style: TextStyle(color: muted(context)),
          ),
          const SizedBox(height: 12),
          _PracticeStatsCard(
            correct: correctSession,
            mistakes: mistakesSession,
            total: correctSession + mistakesSession,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final topic = topics[i];
                return ChoiceChip(
                  label: Text(topic),
                  selected: topic == selectedTopic,
                  onSelected: (_) {
                    setState(() {
                      selectedTopic = topic;
                      index = 0;
                      _resetTaskUi();
                    });
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: topics.length,
            ),
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: (index + 1) / filteredTasks.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: task.color,
            backgroundColor: task.color.withValues(alpha: 0.14),
          ),
          const SizedBox(height: 10),
          _PracticeCard(task: task, index: index),
          const SizedBox(height: 12),
          _CodeBox(task.code),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Ответ',
              prefixIcon: Icon(Icons.edit_rounded),
            ),
            onSubmitted: (_) => check(task),
          ),
          const SizedBox(height: 10),
          _ButtonGrid(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => hint = !hint),
                icon: const Icon(Icons.lightbulb_outline_rounded),
                label: const Text('Подсказка'),
              ),
              FilledButton.icon(
                onPressed: () => check(task),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Проверить'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ButtonGrid(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => showAnswer = !showAnswer),
                icon: Icon(showAnswer
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
                label: Text(showAnswer ? 'Скрыть' : 'Ответ'),
              ),
              OutlinedButton.icon(
                onPressed: randomTask,
                icon: const Icon(Icons.shuffle_rounded),
                label: const Text('Случайная'),
              ),
              OutlinedButton.icon(
                onPressed: retryTask,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Повторить'),
              ),
              OutlinedButton.icon(
                onPressed: nextTask,
                icon: const Icon(Icons.skip_next_rounded),
                label: const Text('Дальше'),
              ),
            ],
          ),
          if (hint) ...[
            const SizedBox(height: 12),
            _InfoBox(
                icon: Icons.tips_and_updates_rounded,
                text: task.hint,
                color: task.color),
          ],
          if (showAnswer) ...[
            const SizedBox(height: 12),
            _InfoBox(
              icon: Icons.fact_check_rounded,
              text: 'Правильный ответ: ${task.answer}',
              color: AppColors.primary,
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: 12),
            _InfoBox(
              icon: result == 'ok'
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              text: result == 'ok'
                  ? 'Верно. Начислено 10 XP за практику.'
                  : 'Пока не совпало. Проверь смысл вывода и лишние пробелы.',
              color: result == 'ok' ? AppColors.green : AppColors.rose,
            ),
          ],
          const SizedBox(height: 20),
          const _SectionTitle(title: 'ИИ-подсказки для самопроверки'),
          const SizedBox(height: 10),
          const _HintCard(
            icon: Icons.psychology_alt_rounded,
            color: AppColors.violet,
            title: 'Объяснить ошибку',
            text:
                'Открой ИИ-наставник и попроси: "Найди ошибку, объясни причину и дай похожее упражнение".',
          ),
          const SizedBox(height: 10),
          const _HintCard(
            icon: Icons.cleaning_services_rounded,
            color: AppColors.cyan,
            title: 'Сделать код чище',
            text:
                'Попроси ИИ предложить понятные имена переменных и убрать дублирование.',
          ),
        ],
      ),
    );
  }

  void check(PracticeTask task) {
    final ok = _normalize(controller.text) == _normalize(task.answer);
    setState(() {
      result = ok ? 'ok' : 'bad';
      if (ok && !rewarded) {
        correctSession++;
      } else if (!ok) {
        mistakesSession++;
      }
    });
    if (ok && !rewarded) {
      rewarded = true;
      widget.onCorrect();
    }
    if (ok) {
      Future<void>.delayed(const Duration(milliseconds: 550), () {
        if (!mounted) return;
        nextTask();
      });
    }
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void nextTask() {
    final filteredLength = selectedTopic == 'Все'
        ? practiceTasks.length
        : practiceTasks.where((task) => task.topic == selectedTopic).length;
    setState(() {
      index = (index + 1) % filteredLength;
      _resetTaskUi();
    });
  }

  void randomTask() {
    final filteredLength = selectedTopic == 'Все'
        ? practiceTasks.length
        : practiceTasks.where((task) => task.topic == selectedTopic).length;
    setState(() {
      if (filteredLength > 1) {
        var next = random.nextInt(filteredLength);
        while (next == index) {
          next = random.nextInt(filteredLength);
        }
        index = next;
      }
      _resetTaskUi();
    });
  }

  void retryTask() {
    setState(_resetTaskUi);
  }

  void _resetTaskUi() {
    controller.clear();
    hint = false;
    showAnswer = false;
    rewarded = false;
    result = null;
  }
}

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  static const favoritesKey = 'codementor_reference_favorites';

  final search = TextEditingController();
  String query = '';
  String category = 'Все';
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    var savedFavorites = (prefs.getStringList(favoritesKey) ?? []).toSet();
    final user =
        Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final cloudFavorites = (snapshot.data()?['favorites'] as List?)
            ?.whereType<String>()
            .toSet();
        if (cloudFavorites != null) {
          savedFavorites = {...savedFavorites, ...cloudFavorites};
          await prefs.setStringList(favoritesKey, savedFavorites.toList());
        }
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() => favorites = savedFavorites);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Все',
      'Избранное',
      ...terms.map((term) => term.category).toSet()
    ];
    final termOfDay = terms[DateTime.now().day % terms.length];
    final filtered = terms.where((term) {
      final q = query.toLowerCase();
      final byQuery = q.isEmpty ||
          term.title.toLowerCase().contains(q) ||
          term.category.toLowerCase().contains(q) ||
          term.description.toLowerCase().contains(q) ||
          term.syntax.toLowerCase().contains(q) ||
          term.example.toLowerCase().contains(q);
      final byCategory = category == 'Все' ||
          (category == 'Избранное' && favorites.contains(term.title)) ||
          term.category == category;
      return byQuery && byCategory;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Справочник',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                _Pill(
                  label: '${terms.length} термин',
                  color: AppColors.primary,
                  icon: Icons.library_books_rounded,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: _TermOfDayCard(
              term: termOfDay,
              favorite: favorites.contains(termOfDay.title),
              onFavorite: () => toggleFavorite(termOfDay),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: TextField(
              controller: search,
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Найти термин, синтаксис или ошибку',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          search.clear();
                          setState(() => query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: _ReferenceStats(
              visible: filtered.length,
              total: terms.length,
              categories: categories.length - 1,
              category: category,
            ),
          ),
          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final item = categories[index];
                return ChoiceChip(
                  label: Text(item),
                  selected: item == category,
                  onSelected: (_) => setState(() => category = item),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyReferenceState(
                    onReset: () {
                      search.clear();
                      setState(() {
                        query = '';
                        category = 'Все';
                      });
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                    itemBuilder: (_, index) {
                      final term = filtered[index];
                      return _TermCard(
                        term: term,
                        favorite: favorites.contains(term.title),
                        onFavorite: () => toggleFavorite(term),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: filtered.length,
                  ),
          ),
        ],
      ),
    );
  }

  void toggleFavorite(Term term) {
    final willAdd = !favorites.contains(term.title);
    setState(() {
      favorites = !willAdd
          ? (favorites..remove(term.title)).toSet()
          : {...favorites, term.title};
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList(favoritesKey, favorites.toList());
    });
    final user =
        Firebase.apps.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'favorites': favorites.toList()..sort(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    showAppSnack(
      context,
      willAdd ? 'Добавлено в избранное' : 'Убрано из избранного',
    );
  }
}

class AiMentorScreen extends StatefulWidget {
  const AiMentorScreen({super.key});

  @override
  State<AiMentorScreen> createState() => _AiMentorScreenState();
}

class _AiMentorScreenState extends State<AiMentorScreen> {
  static const geminiKeyPrefs = 'codementor_gemini_api_key';
  static const geminiModel = 'gemini-2.5-flash';

  final input = TextEditingController();
  final apiKeyController = TextEditingController();
  String geminiApiKey = '';
  bool aiLoading = false;
  String mode = 'Наставник';
  final messages = <ChatMessage>[
    const ChatMessage(
      fromUser: false,
      text:
          'Я ИИ-наставник CodeMentor. Вставь код, ошибку или тему: разберу причину, предложу исправление и дам тренировку.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (!mounted) return;
      setState(() {
        geminiApiKey = prefs.getString(geminiKeyPrefs) ?? '';
        apiKeyController.text = geminiApiKey;
      });
    });
  }

  @override
  void dispose() {
    input.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const modes = ['Наставник', 'Отладчик', 'Ревьюер', 'Тренер'];
    const prompts = [
      'Разбери мой код',
      'Почему NameError?',
      'Составь план на неделю',
      'Дай задачу с проверкой',
      'Объясни простыми словами',
    ];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.violet.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.violet),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ИИ-наставник',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        'Локальная AI-имитация для дипломного прототипа',
                        style: TextStyle(color: muted(context), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _Pill(
                  label: geminiApiKey.isEmpty ? 'API key' : geminiModel,
                  color: AppColors.violet,
                  icon: geminiApiKey.isEmpty
                      ? Icons.key_off_rounded
                      : Icons.cloud_done_rounded,
                ),
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  onPressed: showApiKeySheet,
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final item = modes[index];
                return ChoiceChip(
                  avatar: Icon(
                    _modeIcon(item),
                    size: 17,
                    color: item == mode ? AppColors.primary : null,
                  ),
                  label: Text(item),
                  selected: item == mode,
                  onSelected: (_) => setState(() => mode = item),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: modes.length,
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => ActionChip(
                avatar: const Icon(Icons.bolt_rounded, size: 16),
                label: Text(prompts[index]),
                onPressed: () => send(prompts[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: prompts.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: _MentorInsightPanel(
              mode: mode,
              messageCount: messages.length,
            ),
          ),
          if (aiLoading)
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final message = messages.reversed.toList()[index];
                return _ChatBubble(message: message);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                18, 0, 18, MediaQuery.of(context).padding.bottom + 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Спроси про код, ошибку или тему',
                    ),
                    onSubmitted: send,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: aiLoading ? null : () => send(input.text),
                  icon: Icon(
                    aiLoading
                        ? Icons.hourglass_top_rounded
                        : Icons.send_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || aiLoading) return;
    setState(() {
      messages.add(ChatMessage(fromUser: true, text: text));
      input.clear();
      aiLoading = true;
    });
    final answer = await smartReply(text, mode);
    if (!mounted) return;
    setState(() {
      messages.add(ChatMessage(fromUser: false, text: answer));
      aiLoading = false;
    });
  }

  Future<String> smartReply(String text, String activeMode) async {
    if (geminiApiKey.trim().isEmpty) {
      return 'Чтобы я отвечал как настоящий AI, нажми шестеренку сверху и вставь Gemini API key. Пока ключ не добавлен, отвечаю локальной подсказкой:\n\n${reply(text, activeMode)}';
    }

    try {
      return await askGemini(text, activeMode);
    } catch (error) {
      return 'Не получилось получить ответ от Gemini.\n\nПроверь интернет, API key и доступность бесплатного лимита. Деталь: $error\n\nЛокальная подсказка на этот запрос:\n${reply(text, activeMode)}';
    }
  }

  Future<String> askGemini(String text, String activeMode) async {
    final history = messages
        .where((message) => message.text.trim().isNotEmpty)
        .toList()
        .reversed
        .take(8)
        .toList()
        .reversed
        .map((message) {
      final role = message.fromUser ? 'user' : 'model';
      return {
        'role': role,
        'parts': [
          {'text': message.text}
        ],
      };
    }).toList();

    final prompt = '''
Ты CodeMentor AI, русскоязычный наставник по программированию для учебного Flutter-приложения.
Режим: $activeMode.
Отвечай понятно, дружелюбно и практически. Если пользователь прислал код, найди ошибку, объясни причину и предложи исправление. Если просит тему, дай короткое объяснение, пример и мини-задание.
Не выдумывай запуск кода, если не выполнял его.

Запрос пользователя:
$text
''';

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$geminiModel:generateContent',
    );
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': geminiApiKey.trim(),
          },
          body: jsonEncode({
            'contents': [
              ...history,
              {
                'role': 'user',
                'parts': [
                  {'text': prompt}
                ],
              },
            ],
            'generationConfig': {
              'temperature': 0.65,
              'maxOutputTokens': 900,
            },
          }),
        )
        .timeout(const Duration(seconds: 45));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = data['error'];
      if (error is Map && error['message'] != null) {
        throw Exception(error['message']);
      }
      throw Exception('HTTP ${response.statusCode}');
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw Exception('Gemini вернул пустой ответ');
    }
    final content = candidates.first['content'];
    final parts = content is Map ? content['parts'] : null;
    if (parts is! List) {
      throw Exception('Не удалось прочитать ответ Gemini');
    }
    final answer = parts
        .whereType<Map>()
        .map((part) => part['text'])
        .whereType<String>()
        .join('\n')
        .trim();
    if (answer.isEmpty) {
      throw Exception('Gemini не прислал текст');
    }
    return answer;
  }

  void showApiKeySheet() {
    apiKeyController.text = geminiApiKey;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            18,
            4,
            18,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Настройка Gemini',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Получить бесплатный ключ можно в Google AI Studio. Ключ хранится только на этом устройстве.',
                style: TextStyle(color: muted(context)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: apiKeyController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Gemini API key',
                  hintText: 'AIza...',
                  prefixIcon: Icon(Icons.key_rounded),
                ),
              ),
              const SizedBox(height: 12),
              const _InfoBox(
                icon: Icons.cloud_rounded,
                text:
                    'Модель: $geminiModel. Для работы нужен интернет. Если лимит бесплатного тарифа закончится, приложение покажет ошибку и локальную подсказку.',
                color: AppColors.violet,
              ),
              const SizedBox(height: 14),
              _ButtonGrid(
                children: [
                  FilledButton.icon(
                    onPressed: saveApiKey,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Сохранить'),
                  ),
                  OutlinedButton.icon(
                    onPressed: clearApiKey,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Удалить ключ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveApiKey() {
    final value = apiKeyController.text.trim();
    setState(() => geminiApiKey = value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(geminiKeyPrefs, value);
    });
    Navigator.pop(context);
    showAppSnack(
        context, value.isEmpty ? 'Ключ очищен' : 'Gemini API key сохранен');
  }

  void clearApiKey() {
    apiKeyController.clear();
    setState(() => geminiApiKey = '');
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(geminiKeyPrefs);
    });
    Navigator.pop(context);
    showAppSnack(context, 'Gemini API key удален');
  }

  IconData _modeIcon(String value) {
    switch (value) {
      case 'Отладчик':
        return Icons.bug_report_rounded;
      case 'Ревьюер':
        return Icons.rate_review_rounded;
      case 'Тренер':
        return Icons.fitness_center_rounded;
      default:
        return Icons.psychology_alt_rounded;
    }
  }

  String reply(String value, String activeMode) {
    final q = value.toLowerCase();
    if (_looksLikeCode(value)) return _reviewCode(value, activeMode);
    final term = _findTerm(q);
    if (term != null) return _termReply(term);
    if (activeMode == 'Отладчик') return _debugReply(q);
    if (activeMode == 'Ревьюер') return _reviewReply(q);
    if (activeMode == 'Тренер') return _coachReply(q);

    if (q.contains('nameerror') || q.contains('ошиб')) {
      return _debugReply(q);
    }
    if (q.contains('for') || q.contains('цикл')) {
      return 'Цикл for перебирает элементы коллекции или диапазона.\n\nШаблон:\nfor item in items:\n    действие\n\nКак думать: Python берет первый элемент, выполняет блок с отступом, затем переходит к следующему. Мини-задача: выведи числа от 1 до 5 и отдельно посчитай их сумму.';
    }
    if (q.contains('if') || q.contains('услов')) {
      return 'if проверяет выражение, которое дает True или False. Если True - выполняется блок if, если False - Python смотрит elif или else.\n\nПроверь себя: какие ветки сработают при score = 68, 80 и 95?';
    }
    if (q.contains('задач')) {
      return _coachReply(q);
    }
    if (q.contains('python') || q.contains('учить')) {
      return _studyPlan();
    }
    return 'Разложим задачу на 3 части:\n1. Входные данные: что уже известно?\n2. Логика: какие условия, циклы или функции нужны?\n3. Результат: что должно быть напечатано или возвращено?\n\nПришли код или текст ошибки, и я дам точечный разбор.';
  }

  bool _looksLikeCode(String value) {
    final q = value.toLowerCase();
    return value.contains('\n') ||
        q.contains('print(') ||
        q.contains('def ') ||
        q.contains('for ') ||
        q.contains('if ') ||
        q.contains('while ') ||
        q.contains('traceback') ||
        q.contains('error:');
  }

  Term? _findTerm(String query) {
    final normalized = query
        .replaceAll('что такое', '')
        .replaceAll('объясни', '')
        .replaceAll('расскажи про', '')
        .trim();
    if (normalized.length < 2) return null;
    for (final term in terms) {
      final title = term.title.toLowerCase();
      if (normalized == title || normalized.contains(title)) return term;
    }
    return null;
  }

  String _termReply(Term term) {
    return '${term.title}\n\n${term.description}\n\nСинтаксис: ${term.syntax}\nПример: ${term.example}\n\nКак запомнить: сначала пойми, какие данные входят, потом где этот термин влияет на результат программы.';
  }

  String _reviewCode(String code, String activeMode) {
    final lines =
        code.split('\n').where((line) => line.trim().isNotEmpty).length;
    final lower = code.toLowerCase();
    final hints = <String>[];

    if (lower.contains('nameerror') || lower.contains('not defined')) {
      hints.add(
          'Похоже на NameError: сравни имя при создании переменной и имя в месте использования.');
    }
    if (lower.contains('for ') &&
        !lower.contains('range') &&
        !lower.contains(' in ')) {
      hints.add('У цикла for в Python обычно есть форма: for item in items:.');
    }
    if (lower.contains('if ') && !code.contains(':')) {
      hints.add('После условия if нужен двоеточие и блок с отступом.');
    }
    if (lower.contains('print') && !lower.contains('print(')) {
      hints.add('В Python 3 print вызывается как функция: print(value).');
    }
    if (lower.contains('=') &&
        lower.contains('==') == false &&
        lower.contains('if ')) {
      hints.add(
          'В условии для сравнения нужен ==, а один = используется для присваивания.');
    }
    if (hints.isEmpty) {
      hints.add(
          'Код выглядит как хорошая заготовка. Проверь имена переменных, отступы и ожидаемый вывод.');
    }

    final role = activeMode == 'Ревьюер'
        ? 'Ревью кода'
        : activeMode == 'Отладчик'
            ? 'Диагностика'
            : 'Разбор';
    return '$role:\n\nСтрок кода: $lines.\n\nЧто проверить:\n- ${hints.join('\n- ')}\n\nСледующий шаг: запусти код на маленьком примере и сравни фактический вывод с ожидаемым. Если вывод отличается, пришли его сюда.';
  }

  String _debugReply(String q) {
    if (q.contains('nameerror')) {
      return 'NameError почти всегда означает, что Python не нашел имя.\n\nЧеклист:\n1. Проверь опечатку: score и scroe - разные имена.\n2. Убедись, что переменная создана выше строки с ошибкой.\n3. Проверь область видимости: переменная внутри функции не видна снаружи.\n\nМини-фикс: найди имя в последней строке ошибки и сравни его с объявлением.';
    }
    if (q.contains('typeerror')) {
      return 'TypeError говорит, что операция применена к неподходящему типу данных. Частый пример: строка + число.\n\nИсправление: явно преобразуй тип: int(value), str(value), float(value) или поменяй логику операции.';
    }
    if (q.contains('indexerror')) {
      return 'IndexError означает выход за границы списка. Если длина списка 3, допустимые индексы: 0, 1, 2.\n\nПроверь len(list), цикл range и место, где берешь элемент по индексу.';
    }
    return 'Отладка без паники:\n1. Прочитай последнюю строку ошибки.\n2. Найди тип ошибки: NameError, TypeError, IndexError, SyntaxError.\n3. Проверь строку, на которую указывает traceback.\n4. Сделай минимальный пример из 3-5 строк и проверь гипотезу.';
  }

  String _reviewReply(String q) {
    if (q.contains('улучш') || q.contains('чище') || q.contains('рефактор')) {
      return 'Ревью-фокус:\n- Дай переменным имена по смыслу: total_score лучше, чем x.\n- Убери повторяющийся код в функцию.\n- Раздели ввод, вычисление и вывод.\n- Добавь один тестовый пример для обычного случая и один для края.\n\nПришли фрагмент, и я отмечу конкретные строки.';
    }
    return 'Как я буду ревьюить код:\n1. Корректность: дает ли он нужный результат.\n2. Читаемость: понятные имена и простая структура.\n3. Надежность: что будет на пустых данных, нуле, неверном вводе.\n4. Практика: маленький тест, который доказывает поведение.';
  }

  String _coachReply(String q) {
    if (q.contains('план') || q.contains('недел')) return _studyPlan();
    return 'Задание с самопроверкой:\n\nНапиши функцию grade(score), которая возвращает:\n- "excellent", если score >= 90\n- "passed", если score >= 70\n- "practice", если меньше 70\n\nПроверь на 95, 72 и 40. Бонус: добавь проверку, что score не меньше 0.';
  }

  String _studyPlan() {
    return 'План на 7 дней:\n1. День 1: print, переменные, 5 коротких выводов.\n2. День 2: типы данных и преобразования.\n3. День 3: if/elif/else, 5 задач на ветвления.\n4. День 4: for и range, суммы и счетчики.\n5. День 5: функции и return.\n6. День 6: списки и индексы.\n7. День 7: мини-проект и разбор ошибок через ИИ-наставника.';
  }
}

class ChatMessage {
  final bool fromUser;
  final String text;

  const ChatMessage({required this.fromUser, required this.text});
}

class _AccountCard extends StatelessWidget {
  final User? user;
  final bool authBusy;
  final bool cloudBusy;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;

  const _AccountCard({
    required this.user,
    required this.authBusy,
    required this.cloudBusy,
    required this.onSignIn,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final signedIn = user != null;
    final title = signedIn
        ? (user!.displayName?.trim().isNotEmpty == true
            ? user!.displayName!
            : 'Google аккаунт')
        : 'Вход через Google';
    final subtitle = signedIn
        ? '${user!.email ?? 'Аккаунт подключен'} • ${cloudBusy ? 'синхронизация...' : 'прогресс сохраняется'}'
        : 'Войди, чтобы XP, уроки, заметки и избранное сохранялись в аккаунте.';
    return _AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage: signedIn && user!.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: signedIn && user!.photoURL != null
                ? null
                : Icon(
                    signedIn
                        ? Icons.verified_user_rounded
                        : Icons.login_rounded,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted(context), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          authBusy
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                )
              : IconButton.filledTonal(
                  tooltip: signedIn ? 'Выйти' : 'Войти через Google',
                  onPressed: signedIn ? onSignOut : onSignIn,
                  icon: Icon(
                    signedIn ? Icons.logout_rounded : Icons.login_rounded,
                  ),
                ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final double progress;
  final int completed;
  final int xp;
  final int streak;
  final VoidCallback onStart;

  const _HeroPanel({
    required this.progress,
    required this.completed,
    required this.xp,
    required this.streak,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF163B8F), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Персональный маршрут',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'От первых команд до ИИ-помощника.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 9,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.white.withValues(alpha: 0.20),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${(progress * 100).round()}% курса',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '$completed/${lessons.length} уроков',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _LightStat(icon: Icons.bolt_rounded, value: '$xp XP')),
              const SizedBox(width: 10),
              Expanded(
                child: _LightStat(
                  icon: Icons.local_fire_department_rounded,
                  value: '$streak дней',
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonalIcon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Начать'),
                style: FilledButton.styleFrom(
                  foregroundColor: AppColors.text,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LightStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _LightStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final int xp;
  final int nextLevelXp;
  final double progress;
  final double courseProgress;

  const _LevelCard({
    required this.level,
    required this.xp,
    required this.nextLevelXp,
    required this.progress,
    required this.courseProgress,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.military_tech_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Уровень $level',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _MiniTag(
                  '${(courseProgress * 100).round()}% курса', AppColors.teal),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 8),
          Text(
            '$xp XP собрано. До следующего уровня: ${nextLevelXp - xp} XP.',
            style: TextStyle(color: muted(context), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DailyCoachCard extends StatelessWidget {
  final Lesson nextLesson;
  final int streak;
  final VoidCallback onPractice;
  final VoidCallback onMentor;

  const _DailyCoachCard({
    required this.nextLesson,
    required this.streak,
    required this.onPractice,
    required this.onMentor,
  });

  @override
  Widget build(BuildContext context) {
    final goal = streak >= 3
        ? 'Удержи серию: реши одну задачу и задай ИИ вопрос по ошибке.'
        : 'Собери темп: пройди следующий урок и закрепи практикой.';
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.today_rounded, color: AppColors.cyan),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Цель на сегодня',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(goal, style: TextStyle(color: muted(context))),
                    const SizedBox(height: 6),
                    Text(
                      'Фокус: ${nextLesson.title}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPractice,
                  icon: const Icon(Icons.integration_instructions_rounded),
                  label: const Text('Практика'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onMentor,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('ИИ-разбор'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementStrip extends StatelessWidget {
  final List<Achievement> achievements;

  const _AchievementStrip({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) =>
            _AchievementBadge(achievement: achievements[index]),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: achievements.length,
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final color = achievement.unlocked ? achievement.color : muted(context);
    final progress = achievement.total == 0
        ? 0.0
        : (achievement.progress / achievement.total).clamp(0.0, 1.0);
    return SizedBox(
      width: 168,
      child: _AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(achievement.icon, color: color),
                const Spacer(),
                Icon(
                  achievement.unlocked
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  color: color,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              achievement.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              achievement.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: muted(context), fontSize: 12),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              borderRadius: BorderRadius.circular(8),
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: muted(context), fontSize: 12)),
        ],
      ),
    );
  }
}

class _NextLessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const _NextLessonCard({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: lesson.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(lesson.icon, color: lesson.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.track,
                    style: TextStyle(color: muted(context), fontSize: 12)),
                const SizedBox(height: 3),
                Text(lesson.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  lesson.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted(context), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filledTonal(
              onPressed: onTap, icon: const Icon(Icons.arrow_forward_rounded)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 27),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted(context), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool done;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: lesson.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(lesson.icon, color: lesson.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: lesson.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                        Icon(
                          done
                              ? Icons.check_circle_rounded
                              : Icons.chevron_right_rounded,
                          color: done ? AppColors.green : muted(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: muted(context), fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _MiniTag(lesson.track, lesson.color),
                        _MiniTag(lesson.level, AppColors.muted),
                        _MiniTag(lesson.duration, AppColors.cyan),
                        _MiniTag('${lesson.xp} XP', AppColors.amber),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  final Lesson lesson;

  const _LessonHeader({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: lesson.color.withValues(alpha: 0.10),
        border: Border.all(color: lesson.color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(lesson.icon, color: lesson.color, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.description,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _MiniTag(lesson.track, lesson.color),
                    _MiniTag(lesson.level, AppColors.muted),
                    _MiniTag(lesson.duration, AppColors.cyan),
                    _MiniTag('${lesson.xp} XP', AppColors.amber),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TheoryCard extends StatelessWidget {
  final int number;
  final String text;
  final Color color;

  const _TheoryCard({
    required this.number,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.12),
            foregroundColor: color,
            child: Text('$number',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: muted(context), height: 1.45))),
        ],
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  final CodeSample sample;
  final Color color;

  const _CodeSampleCard({required this.sample, required this.color});

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code_rounded, color: color),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(sample.title,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
            ],
          ),
          const SizedBox(height: 10),
          _CodeBox(sample.code),
          const SizedBox(height: 10),
          _OutputBox(sample.output),
          const SizedBox(height: 10),
          Text(sample.note, style: TextStyle(color: muted(context))),
        ],
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final PracticeTask task;
  final int index;

  const _PracticeCard({required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: task.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.task_alt_rounded, color: task.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(task.prompt,
                    style: TextStyle(color: muted(context), fontSize: 13)),
              ],
            ),
          ),
          _Pill(
            label: '${index + 1}/${practiceTasks.length}',
            color: task.color,
            icon: Icons.route_rounded,
          ),
        ],
      ),
    );
  }
}

class _ReferenceStats extends StatelessWidget {
  final int visible;
  final int total;
  final int categories;
  final String category;

  const _ReferenceStats({
    required this.visible,
    required this.total,
    required this.categories,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.manage_search_rounded,
                color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == 'Все' ? 'База знаний' : 'Раздел: $category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  'Показано $visible из $total. Категорий: $categories.',
                  style: TextStyle(color: muted(context), fontSize: 13),
                ),
              ],
            ),
          ),
          const _MiniTag('50+ новых', AppColors.green),
        ],
      ),
    );
  }
}

class _EmptyReferenceState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyReferenceState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: muted(context), size: 54),
            const SizedBox(height: 12),
            Text('Ничего не найдено',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Попробуй искать по слову, категории, синтаксису или примеру.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted(context)),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Сбросить поиск'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  final Term term;
  final bool favorite;
  final VoidCallback? onFavorite;

  const _TermCard({
    required this.term,
    this.favorite = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(term.title,
                      style: Theme.of(context).textTheme.titleMedium)),
              IconButton(
                tooltip: favorite ? 'Убрать из избранного' : 'В избранное',
                onPressed: onFavorite,
                icon: Icon(
                  favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: favorite ? AppColors.amber : muted(context),
                ),
              ),
              _MiniTag(term.category, AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(term.description, style: TextStyle(color: muted(context))),
          const SizedBox(height: 10),
          _InlineCode(term.syntax),
          const SizedBox(height: 8),
          Text(term.example,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
        ],
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;

  const _HintCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(text, style: TextStyle(color: muted(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorInsightPanel extends StatelessWidget {
  final String mode;
  final int messageCount;

  const _MentorInsightPanel({
    required this.mode,
    required this.messageCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (mode) {
      'Отладчик' => AppColors.rose,
      'Ревьюер' => AppColors.cyan,
      'Тренер' => AppColors.green,
      _ => AppColors.violet,
    };
    final text = switch (mode) {
      'Отладчик' => 'Ищу тип ошибки, строку причины и минимальный фикс.',
      'Ревьюер' => 'Проверяю читаемость, имена, края и тестируемость.',
      'Тренер' => 'Даю задачу, критерии проверки и следующий уровень.',
      _ => 'Объясняю тему простыми шагами и закрепляю примером.',
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: muted(context), fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          _MiniTag('${messageCount ~/ 2} диалогов', color),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final user = message.fromUser;
    final color =
        user ? AppColors.primary : Theme.of(context).colorScheme.surface;
    final textColor = user
        ? Colors.white
        : Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkText
            : AppColors.text;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: user ? null : Border.all(color: line(context)),
        ),
        child: Text(message.text,
            style: TextStyle(color: textColor, height: 1.45)),
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  final String code;

  const _CodeBox(this.code);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Color(0xFFE5E7EB),
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.45,
        ),
      ),
    );
  }
}

class _OutputBox extends StatelessWidget {
  final String output;

  const _OutputBox(this.output);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.output_rounded, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              output,
              style: const TextStyle(
                  fontFamily: 'monospace', fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoBox({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _InlineCode extends StatelessWidget {
  final String text;

  const _InlineCode(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'monospace',
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StudyPulseCard extends StatelessWidget {
  final int xp;
  final int streak;
  final int completed;
  final int dailyGoal;

  const _StudyPulseCard({
    required this.xp,
    required this.streak,
    required this.completed,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (completed * 14 + xp ~/ 6 + streak * 3).clamp(0, 240);
    final progress = (minutes / dailyGoal).clamp(0.0, 1.0);
    final mood = progress >= 1
        ? 'Цель закрыта'
        : progress >= .55
            ? 'Хороший темп'
            : 'Разгоняемся';
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_rounded, color: AppColors.rose),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Пульс обучения',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _MiniTag(mood, AppColors.rose),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.rose,
            backgroundColor: AppColors.rose.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 8),
          Text(
            '$minutes из $dailyGoal минут учебной активности. XP, серия и уроки превращаются в понятную дневную норму.',
            style: TextStyle(color: muted(context), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _FocusTimerCard extends StatefulWidget {
  final int dailyGoal;

  const _FocusTimerCard({required this.dailyGoal});

  @override
  State<_FocusTimerCard> createState() => _FocusTimerCardState();
}

class _FocusTimerCardState extends State<_FocusTimerCard> {
  Timer? timer;
  int secondsLeft = 15 * 60;
  bool running = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return _AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.timer_rounded, color: AppColors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$minutes:$seconds',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                  'Фокус-сессия для дневной цели ${widget.dailyGoal} минут',
                  style: TextStyle(color: muted(context), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: running ? pause : start,
            icon:
                Icon(running ? Icons.pause_rounded : Icons.play_arrow_rounded),
          ),
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
    );
  }

  void start() {
    if (running) return;
    setState(() => running = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (secondsLeft <= 1) {
        timer?.cancel();
        setState(() {
          secondsLeft = 0;
          running = false;
        });
        return;
      }
      setState(() => secondsLeft--);
    });
  }

  void pause() {
    timer?.cancel();
    setState(() => running = false);
  }

  void reset() {
    timer?.cancel();
    setState(() {
      secondsLeft = 15 * 60;
      running = false;
    });
  }
}

class _StudyPlanStrip extends StatelessWidget {
  const _StudyPlanStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => _StudyPlanTile(item: studyPlan[index]),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: studyPlan.length,
      ),
    );
  }
}

class _StudyPlanTile extends StatelessWidget {
  final StudyPlanItem item;

  const _StudyPlanTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: _AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item.icon, color: item.color),
                const Spacer(),
                _MiniTag(item.day, item.color),
              ],
            ),
            const SizedBox(height: 10),
            Text(item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(
              item.focus,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: muted(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillMapCard extends StatelessWidget {
  final Set<String> completed;

  const _SkillMapCard({required this.completed});

  @override
  Widget build(BuildContext context) {
    final tracks = lessons.map((lesson) => lesson.track).toSet().toList();
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Карта навыков',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              _MiniTag('${tracks.length} веток', AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          ...tracks.map((track) {
            final trackLessons =
                lessons.where((lesson) => lesson.track == track).toList();
            final done = trackLessons
                .where((lesson) => completed.contains(lesson.id))
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SkillRow(
                title: track,
                done: done,
                total: trackLessons.length,
                color: trackLessons.first.color,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  final Color color;

  const _SkillRow({
    required this.title,
    required this.done,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            Text('$done/$total',
                style: TextStyle(color: muted(context), fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          minHeight: 7,
          borderRadius: BorderRadius.circular(8),
          color: color,
          backgroundColor: color.withValues(alpha: 0.12),
        ),
      ],
    );
  }
}

class _DailyGoalSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _DailyGoalSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes_rounded, color: AppColors.green),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Цель на день',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              _MiniTag('$value мин', AppColors.green),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 10,
            max: 90,
            divisions: 8,
            label: '$value минут',
            onChanged: (next) => onChanged(next.round()),
          ),
        ],
      ),
    );
  }
}

class _DefenseChecklistCard extends StatefulWidget {
  const _DefenseChecklistCard();

  @override
  State<_DefenseChecklistCard> createState() => _DefenseChecklistCardState();
}

class _DefenseChecklistCardState extends State<_DefenseChecklistCard> {
  final checked = <int>{};

  static const items = [
    'Показать главный экран и прогресс',
    'Открыть урок, тест и заметки',
    'Решить задачу в практике',
    'Показать справочник и избранное',
    'Спросить AI-наставника про ошибку',
  ];

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fact_check_rounded, color: AppColors.violet),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Чеклист защиты',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              _MiniTag('${checked.length}/${items.length}', AppColors.violet),
            ],
          ),
          const SizedBox(height: 8),
          ...items.asMap().entries.map((entry) {
            final done = checked.contains(entry.key);
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: done,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(entry.value),
              onChanged: (_) {
                setState(() {
                  done ? checked.remove(entry.key) : checked.add(entry.key);
                });
              },
            );
          }),
        ],
      ),
    );
  }
}

class _PracticeStatsCard extends StatelessWidget {
  final int correct;
  final int mistakes;
  final int total;

  const _PracticeStatsCard({
    required this.correct,
    required this.mistakes,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = total == 0 ? 0 : (correct / total * 100).round();
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.check_circle_rounded,
            value: '$correct',
            label: 'Верно',
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.error_outline_rounded,
            value: '$mistakes',
            label: 'Ошибки',
            color: AppColors.rose,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.percent_rounded,
            value: '$accuracy%',
            label: 'Точность',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _TermOfDayCard extends StatelessWidget {
  final Term term;
  final bool favorite;
  final VoidCallback onFavorite;

  const _TermOfDayCard({
    required this.term,
    required this.favorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.today_rounded, color: AppColors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Термин дня',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    IconButton(
                      tooltip:
                          favorite ? 'Убрать из избранного' : 'В избранное',
                      onPressed: onFavorite,
                      icon: Icon(
                        favorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: favorite ? AppColors.amber : muted(context),
                      ),
                    ),
                  ],
                ),
                Text(term.title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  term.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted(context), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Оформление', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.phone_android_rounded),
                  label: Text('Авто'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_rounded),
                  label: Text('Светлая'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_rounded),
                  label: Text('Темная'),
                ),
              ],
              selected: {value},
              onSelectionChanged: (values) => onChanged(values.first),
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonGrid extends StatelessWidget {
  final List<Widget> children;

  const _ButtonGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final columns = isCompact(context) ? 2 : children.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(
                width: width,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final String action;
  final VoidCallback onAction;

  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: muted(context), size: 44),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: muted(context)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(action),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: padding, child: child));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionTitle({
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Pill({
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniTag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}

Color muted(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.muted;

Color line(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkLine
        : AppColors.line;

void showAppSnack(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 430;

EdgeInsets pagePadding(BuildContext context) {
  final bottom = MediaQuery.paddingOf(context).bottom;
  final horizontal = isCompact(context) ? 14.0 : 22.0;
  return EdgeInsets.fromLTRB(horizontal, 14, horizontal, bottom + 24);
}
