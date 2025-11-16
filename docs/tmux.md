# tmux Cheat Sheet (NovaStream Edition)

**Prefix key:** `Ctrl + a`

---

## 🔮 Legend

- **Prefix** = `Ctrl + a`
- `Ctrl + a` → **something** = Press prefix, release, then press next key
- Windows = tabs
- Panes = splits

---

## 🔷 Basics

| Action                          | Keys             |
| ------------------------------- | ---------------- |
| **Start tmux**                  | `tmux`           |
| **Attach to last session**      | `tmux a`         |
| **List sessions**               | `tmux ls`        |
| **Detach (leave tmux running)** | `Ctrl + a` → `d` |
| **Reload config**               | `Ctrl + a` → `r` |
| **Kill current pane/window**    | run `exit`       |

---

## 🔶 Windows (Tabs)

| Action                 | Keys               |
| ---------------------- | ------------------ |
| **New window**         | `Ctrl + a` → `c`   |
| **Next window**        | `Ctrl + a` → `n`   |
| **Previous window**    | `Ctrl + a` → `p`   |
| **Switch to window #** | `Ctrl + a` → `0–9` |
| **Rename window**      | `Ctrl + a` → `,`   |

---

## 🔹 Panes (Splits)

| Action                 | Keys                          |
| ---------------------- | ----------------------------- |
| **Split horizontally** | `Ctrl + a` → `-`              |
| **Split vertically**   | `Ctrl + a` → `\|`             |
| **Move pane focus**    | `Ctrl + a` → `h/j/k/l`        |
| **Resize pane**        | `Ctrl + a` → `Ctrl + h/j/k/l` |
| **Swap panes**         | `Ctrl + a` → `{` or `}`       |
| **Toggle pane zoom**   | `Ctrl + a` → `z`              |

---

## 🔸 Copy Mode (vi-style)

Enter copy mode:

```
Ctrl + a  →  [
```

Movement:

| Move                  | Keys                    |
| --------------------- | ----------------------- |
| Up/Down               | `k` / `j`               |
| Left/Right            | `h` / `l`               |
| Page up/down          | `Ctrl + u` / `Ctrl + d` |
| Beginning/End of line | `0` / `$`               |

Selection & copy:

| Action              | Keys             |
| ------------------- | ---------------- |
| **Start selection** | `v`              |
| **Copy selection**  | `y`              |
| **Paste**           | `Ctrl + a` → `]` |

Exit copy mode:

```
q
```

---

## 🔷 Session Management

| Action              | Keys                        |
| ------------------- | --------------------------- |
| **New session**     | `tmux new -s name`          |
| **Attach**          | `tmux attach -t name`       |
| **Switch sessions** | `Ctrl + a` → `(` or `)`     |
| **Rename session**  | `Ctrl + a` → `$`            |
| **Kill a session**  | `tmux kill-session -t name` |

---

## 🔹 Common tmux Commands (CLI)

```
tmux ls
tmux new -s name
tmux attach -t name
tmux kill-session -t name
tmux switch -t name
tmux rename-session -t old new
```
