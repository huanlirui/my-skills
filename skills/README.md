# Skills

所有 skill 放此目录，通用格式，可安装到 Cursor、Codex 等工具。

每个 skill 一个子目录，至少包含 `SKILL.md`：

```
skills/
├── my-skill-a/
│   └── SKILL.md
└── my-skill-b/
    ├── SKILL.md
    ├── reference.md    # 可选
    └── scripts/        # 可选
```

安装时把对应 skill 目录复制或软链到目标工具的 skills 路径即可（如 Cursor: `~/.cursor/skills/`，Codex: `$CODEX_HOME/skills/`）。
