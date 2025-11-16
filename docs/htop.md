# htop Cheat Sheet

A quick reference for using **htop** efficiently on servers.

---

## 🔷 Basic Controls

```
F1     Help
F2     Setup / Preferences
F3     Search processes
F4     Filter by name
F5     Toggle Tree view
F6     Sort by column
F7     Increase nice (lower priority)
F8     Decrease nice (raise priority)
F9     Kill process
F10    Quit htop
```

```
Arrow keys: Navigate  
Space: Mark process  
u: Show only your user’s processes  
i: Invert sort order  
H: Toggle kernel threads  
t: Tree view  
c: Toggle CPU meters  
m: Toggle Memory meters  
+: Expand tree  
-: Collapse tree
```

---

## 🔶 Process Management

| Action                       | Keys        |
| ---------------------------- | ----------- |
| **Search for a process**     | `F3`        |
| **Filter by string**         | `F4`        |
| **Sort by CPU / MEM / TIME** | `F6`        |
| **Kill selected process**    | `F9`        |
| **Renice process**           | `F7` / `F8` |
| **Tree mode**                | `F5` or `t` |

---

## 🔹 Display Toggles

| Toggle                     | Keys        |
| -------------------------- | ----------- |
| **Kernel threads**         | `H`         |
| **Userland threads**       | `Shift + H` |
| **Command / full path**    | `c`         |
| **Memory modes**           | `m`         |
| **CPU modes**              | `c`         |
| **Tree view**              | `t`         |
| **Expand / collapse tree** | `+` / `-`   |

---

## 🔸 Useful Information

- **Tree view** shows parent/child relationships
- **Renice** adjusts process scheduling priority
- **TERM signal (default)** is usually enough to stop a task
- **KILL signal** (`9`) is forceful — use only when necessary
- Use filtering (`F4`) to isolate noisy processes on busy servers

---

## 🔮 Tips

### Show full command lines by default

Setup → Display Options → Enable  
✔ _Show program path_  
✔ _Command line_

### Keep meters useful

Meters are configured in Setup → Meters.

Recommended for servers:

Left: `CPU`, `Memory`, `Swap`  
Right: `DiskIO`, `NetworkIO`, `LoadAverage`

### Increase scrollback

In Setup → Display Options:  
✔ _Increase history size (scrollback)_
