# my-skills

个人 Agent Skills 仓库（GitHub: `huanlirui/my-skills`）。

支持使用 `skills` CLI 一键安装到支持的 Agent 客户端（例如 Codex / Cursor）。

## 安装到 Claude（个人全局）

一键安装到 `~/.claude/skills`：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/huanlirui/my-skills/main/scripts/install.sh) -- --target claude
```

## 一键安装（推荐）

先查看仓库可安装的 skills：

```bash
npx skills add huanlirui/my-skills --list
```

安装单个 skill（示例）：

```bash
npx skills add huanlirui/my-skills --skill daily-report
npx skills add huanlirui/my-skills --skill weekly-report
```

安装后按客户端提示重启即可生效。

## 兼容安装方式（脚本）

如果你不使用 `skills` CLI，可用仓库内脚本：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/huanlirui/my-skills/main/scripts/install.sh) -- --target codex
```

或：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/huanlirui/my-skills/main/scripts/install.sh) -- --target cursor
```

安装到 Claude：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/huanlirui/my-skills/main/scripts/install.sh) -- --target claude
```

## 仓库结构

```text
my-skills/
├── README.md
├── _template/               # 新建 skill 模板
├── scripts/
│   └── install.sh           # 兼容安装脚本
└── skills/
    ├── daily-report/
    │   └── SKILL.md
    └── weekly-report/
        └── SKILL.md
```

## 开发说明

- 每个 skill 一个目录，至少包含 `SKILL.md`
- `SKILL.md` 建议包含 frontmatter：
  - `name`
  - `description`
