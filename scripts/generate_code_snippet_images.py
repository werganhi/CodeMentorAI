from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


OUT = Path("docs/_work/screens")
OUT.mkdir(parents=True, exist_ok=True)

FONT = ImageFont.truetype("C:/Windows/Fonts/consola.ttf", 18)
FONT_BOLD = ImageFont.truetype("C:/Windows/Fonts/consolab.ttf", 18)
TITLE_FONT = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", 18)

BG = (17, 24, 39)
PANEL = (15, 23, 42)
TEXT = (226, 232, 240)
MUTED = (148, 163, 184)
BLUE = (96, 165, 250)
GREEN = (52, 211, 153)
YELLOW = (251, 191, 36)
PINK = (244, 114, 182)


SNIPPETS = {
    "code_01_main.png": (
        "Инициализация Firebase",
        "lib/main.dart",
        [
            "void main() async {",
            "  WidgetsFlutterBinding.ensureInitialized();",
            "  try {",
            "    await Firebase.initializeApp();",
            "  } catch (_) {",
            "    // Web preview без FirebaseOptions",
            "  }",
            "  runApp(const CodeMentorApp());",
            "}",
        ],
    ),
    "code_02_model.png": (
        "Модель урока",
        "lib/app.dart",
        [
            "class Lesson {",
            "  final String id;",
            "  final String title;",
            "  final String track;",
            "  final int xp;",
            "  final List<String> theory;",
            "  final List<CodeExample> examples;",
            "}",
        ],
    ),
    "code_03_content.png": (
        "Учебный контент разных языков",
        "lib/app.dart",
        [
            "const languageReference = <ReferenceSeed>[",
            "  ReferenceSeed('Python', 'print()', ...),",
            "  ReferenceSeed('JavaScript', 'async/await', ...),",
            "  ReferenceSeed('SQL', 'SELECT', ...),",
            "  ReferenceSeed('Dart/Flutter', 'Widget', ...),",
            "];",
        ],
    ),
    "code_04_auth.png": (
        "Google-вход и Firebase Auth",
        "lib/app.dart",
        [
            "final googleUser =",
            "    await GoogleSignIn.instance.authenticate();",
            "final googleAuth = googleUser.authentication;",
            "final credential = GoogleAuthProvider.credential(",
            "  idToken: googleAuth.idToken,",
            ");",
            "await auth.signInWithCredential(credential);",
        ],
    ),
    "code_05_firestore.png": (
        "Сохранение прогресса в Firestore",
        "lib/app.dart",
        [
            "await firestore.collection('users').doc(user.uid).set({",
            "  'completed': completed.toList(),",
            "  'xp': xp,",
            "  'streak': streak,",
            "  'dailyGoal': dailyGoal,",
            "  'updatedAt': FieldValue.serverTimestamp(),",
            "}, SetOptions(merge: true));",
        ],
    ),
    "code_06_gemini.png": (
        "Запрос к Gemini API",
        "lib/app.dart",
        [
            "final uri = Uri.parse(",
            "  'https://generativelanguage.googleapis.com/'",
            "  'v1beta/models/$geminiModel:generateContent',",
            ");",
            "final response = await http.post(",
            "  uri,",
            "  headers: {'x-goog-api-key': geminiApiKey.trim()},",
            ");",
        ],
    ),
}


def color_for(line):
    stripped = line.strip()
    if stripped.startswith("class ") or stripped.startswith("void "):
        return GREEN
    if "await " in line or "final " in line:
        return BLUE
    if "'" in line or '"' in line:
        return YELLOW
    if stripped.startswith("//"):
        return MUTED
    return TEXT


def render(filename, title, source, lines):
    width = 860
    line_height = 28
    height = 92 + line_height * len(lines)
    image = Image.new("RGB", (width, height), BG)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((16, 16, width - 16, height - 16), 16, fill=PANEL, outline=(51, 65, 85), width=2)
    draw.ellipse((36, 36, 48, 48), fill=(248, 113, 113))
    draw.ellipse((58, 36, 70, 48), fill=(251, 191, 36))
    draw.ellipse((80, 36, 92, 48), fill=(52, 211, 153))
    draw.text((116, 29), title, font=TITLE_FONT, fill=TEXT)
    draw.text((width - 180, 31), source, font=FONT, fill=MUTED)

    y = 70
    for index, line in enumerate(lines, 1):
        draw.text((38, y), f"{index:02}", font=FONT, fill=(71, 85, 105))
        draw.text((82, y), line, font=FONT_BOLD if index == 1 else FONT, fill=color_for(line))
        y += line_height
    image.save(OUT / filename)


def main():
    for filename, (title, source, lines) in SNIPPETS.items():
        render(filename, title, source, lines)
    print(f"generated {len(SNIPPETS)} code snippet images")


if __name__ == "__main__":
    main()
