#!/usr/bin/env python3
"""Passwordless commands must work even when sudo credential validation fails."""
from pathlib import Path
import os
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="vm-sudo-test-") as directory:
    temp = Path(directory)
    for name, body in {
        "id": '#!/bin/sh\nprintf "1000\\n"\n',
        "sudo": '''#!/bin/sh
printf '%s\n' "$*" >> "$SUDO_TEST_LOG"
case "$*" in
  '-n true') exit 0 ;;
  '-n -v'|'-v') exit 1 ;;
  *) exit 77 ;;
esac
''',
    }.items():
        path = temp / name
        path.write_text(body)
        path.chmod(0o755)
    log = temp / "calls"
    env = dict(os.environ, PATH=f"{temp}:{os.environ['PATH']}", SUDO_TEST_LOG=str(log))
    result = subprocess.run(["sh", str(root / "install.sh")], env=env, capture_output=True, text=True)
    calls = log.read_text().splitlines()
    assert len(calls) == 2 and calls[0] == "-n true", calls
    assert calls[1].split()[0] in {"apt-get", "dnf", "pacman", "zypper", "apk"}, calls
    assert result.returncode == 77, result.stderr
print("Passwordless sudo reaches package installation without credential validation.")
