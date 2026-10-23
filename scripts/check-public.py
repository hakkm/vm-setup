#!/usr/bin/env python3
"""Fail closed if the publishable config differs from its reviewed allowlist."""
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]
allowed = set((root / "config-manifest.txt").read_text().splitlines())
actual = {str(p.relative_to(root)) for p in (root / "config").rglob("*") if p.is_file() or p.is_symlink()}
errors = []
for path in sorted(actual ^ allowed):
    errors.append(f"Config allowlist mismatch: {path}")
patterns = [
    r"-----BEGIN (?:RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----",
    r"(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,})",
    r"AKIA[0-9A-Z]{16}",
    r"\bsk-[A-Za-z0-9_-]{24,}",
    r"(?i)(?:password|api_key|access_token|client_secret)\s*[=:]\s*['\"][^'\"]+['\"]",
    r"(?i)(?:postgres(?:ql)?|mysql|mongodb(?:\+srv)?)://[^\s/]+:[^\s/@]+@",
]
for name in sorted(actual):
    path = root / name
    if path.is_symlink():
        errors.append(f"Symlink cannot be published: {name}")
        continue
    if any(re.search(r"(?i)(secret|history|\.env|\.git|\.zcompdump|db_ui)", part) for part in path.relative_to(root).parts):
        errors.append(f"Private/runtime path: {name}")
    text = path.read_text()
    if "/home/khabir" in text:
        errors.append(f"Workstation path: {name}")
    for pattern in patterns:
        if re.search(pattern, text):
            errors.append(f"Potential credential in {name} (value withheld)")
            break
if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
print(f"Public config check passed: {len(actual)} allowlisted files; no detected credentials.")
