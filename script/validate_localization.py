#!/usr/bin/env python3
"""Check packaged localization keys and printf placeholders without dependencies."""
import collections
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
PAIR = re.compile(r'^("(?:[^"\\]|\\.)*") = ("(?:[^"\\]|\\.)*");$')


def load(language):
    result = {}
    for line in (ROOT / "Sources/AppBundle/Resources" / (language + ".lproj") / "Localizable.strings").read_text().splitlines():
        if line.startswith("/*") or not line.strip():
            continue
        match = PAIR.fullmatch(line)
        assert match, "Invalid .strings entry"
        key, value = map(json.loads, match.groups())
        assert key not in result, "Duplicate localization key"
        assert value.strip(), "Empty translation"
        result[key] = value
    return result


def main():
    en, ru = load("en"), load("ru")
    assert en.keys() == ru.keys(), "Language keys differ"
    for key in en:
        assert en[key] == key, "English fallback changed"
        placeholders = lambda s: re.findall(r'%(?:\d+\$)?[@d]', s)
        assert placeholders(en[key]) == placeholders(ru[key]), "Placeholder mismatch"
    used = set()
    for source in (ROOT / "Sources/AppBundle").rglob("*.swift"):
        for match in re.finditer(r'\bL(?:F)?\(("(?:[^"\\]|\\.)*")', source.read_text()):
            used.add(json.loads(match[1]))
    assert used <= en.keys(), "Untranslated source key"
    print(f"Localization verified: {len(en)} keys, {len(used)} referenced keys.")


if __name__ == "__main__":
    main()
