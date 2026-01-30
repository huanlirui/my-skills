# my-skills

个人 Agent Skills 仓库，通用格式，可安装到 Cursor、Codex 等工具，便于版本控制和在多设备间同步。

## 目录结构

```
my-skills/
├── README.md           # 本说明
├── .gitignore
├── _template/          # 新建 skill 的模板
│   └── SKILL.md
└── skills/             # 所有 skills（通用）
    └── README.md
```

- **skills/**：所有 skill 放这里，每个 skill 一个子目录，内含 `SKILL.md`（可含 `reference.md`、`scripts/` 等）。
- **_template/**：新建 skill 时可复制此目录作为起点。

## 添加新 Skill

1. 在 `skills/` 下新建子目录，例如 `skills/my-new-skill/`。
2. 至少创建 `SKILL.md`，可参考 `_template/SKILL.md` 的 frontmatter 和结构。
3. 需要时可加入 `reference.md`、`examples.md` 或 `scripts/` 等。

## 安装到本地

把需要的 skill 目录复制或软链到目标工具的 skills 路径即可：

- **Cursor**：`~/.cursor/skills/`
- **Codex**：`$CODEX_HOME/skills/`（或对应子目录）

例如（软链单个 skill 到 Cursor）：

```bash
ln -s /path/to/my-skills/skills/my-skill ~/.cursor/skills/my-skill
```

一次性软链本仓库全部 skills 到 Cursor：

```bash
for d in /path/to/my-skills/skills/*/; do
  name=$(basename "$d")
  [ -f "$d/SKILL.md" ] && ln -sf "$d" ~/.cursor/skills/"$name"
done
```

## License

按需在仓库根目录或各 skill 目录下添加 LICENSE 文件。
