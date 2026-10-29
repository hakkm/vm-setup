#!/usr/bin/env python3
"""Exercise the real ZLE shortcut with a ranger stub requiring terminal input."""
import os
from pathlib import Path
import pty
import select
import signal
import sys
import tempfile
import time

config = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / 'config/zsh/keymaps.zsh'
for mode in ('viins', 'vicmd', 'emacs'):
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        ranger = root / 'ranger'
        ranger.write_text('#!/bin/sh\nif test -t 0; then echo tty; else echo no-tty; fi > "$VM_RANGER_RESULT"\n')
        ranger.chmod(0o755)
        pid, terminal = pty.fork()
        if pid == 0:
            os.environ.update(PATH=f'{root}:{os.environ["PATH"]}',
                              VM_RANGER_RESULT=str(root / 'result'),
                              VM_BUFFER_RESULT=str(root / 'buffer'), VM_READY=str(root / 'ready'),
                              VM_KEYMAP_CONFIG=str(config), TERM='xterm')
            os.execvp('zsh', ['zsh', '-f'])
        output = bytearray()

        def wait_for(predicate):
            deadline = time.monotonic() + 10
            while time.monotonic() < deadline:
                if select.select([terminal], [], [], 0.05)[0]:
                    output.extend(os.read(terminal, 65536))
                if predicate():
                    return
            raise AssertionError(f'{mode}: timed out: {output.decode(errors="replace")}')

        try:
            setup = (f'bindkey -{"e" if mode == "emacs" else "v"}; EDITOR=vim; source "$VM_KEYMAP_CONFIG"; '
                     f'zle-line-init() {{ zle -K {mode}; print ready > "$VM_READY"; }}; '
                     'zle -N zle-line-init; PS1="READY> "\n')
            os.write(terminal, setup.encode())
            wait_for(lambda: (root / 'ready').exists())
            # Leave input unfinished while ranger runs; complete it on return.
            prefix = 'i' if mode == 'vicmd' else ''
            os.write(terminal, (prefix + 'print -r -- pre').encode())
            if mode == 'vicmd':
                os.write(terminal, b'\x1b')
            os.write(terminal, b'\x0f')
            wait_for(lambda: (root / 'result').exists())
            assert (root / 'result').read_text().strip() == 'tty', f'{mode}: ranger stdin is not a terminal'
            if mode == 'vicmd':
                os.write(terminal, b'A')
            os.write(terminal, b'served > "$VM_BUFFER_RESULT"\n')
            wait_for(lambda: (root / 'buffer').exists())
            assert (root / 'buffer').read_text().strip() == 'preserved'
        finally:
            os.kill(pid, signal.SIGKILL)
            os.waitpid(pid, 0)
            os.close(terminal)
print('Ranger shortcut passed: terminal input and command preservation in all keymaps.')
