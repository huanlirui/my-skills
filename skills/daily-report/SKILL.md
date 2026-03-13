---
name: daily-report
description: 根据指定日期读取当前 git 用户提交，生成中文 Git 提交日报（提交明细与当日总结）。
---

# daily-report

根据指定日期生成 Git 提交日报。

## 使用方法

```
/daily-report [日期]
```

如果不提供日期参数，默认生成今天的日报。

日期格式示例：

- `2026-01-29`
- `today` (今天)
- `yesterday` (昨天)

## 技能描述

当用户调用此技能时，按照以下步骤生成日报：

1. **解析日期参数**

   - 如果用户提供了日期参数（如 `2026-01-29`），使用该日期
   - 如果参数为 `today`，使用今天的日期
   - 如果参数为 `yesterday`，使用昨天的日期
   - 如果没有提供参数，默认使用今天的日期
   - 将日期转换为 Git 所需的格式：`YYYY-MM-DD`

2. **获取 Git 用户信息**

   - 首先使用 `git config user.name` 获取当前用户名
   - 使用 `git config user.email` 获取当前用户邮箱
   - 如果获取失败，提示用户配置 git 用户信息：

     ```bash
     git config user.name "Your Name"
     git config user.email "your.email@example.com"
     ```

3. **获取 Git 提交记录**

   - 使用 `git log` 命令查询指定日期的提交记录
   - 使用从 git config 获取的用户名作为作者过滤条件
   - 命令格式：

     ```bash
     git log --author="$(git config user.name)" --since="YYYY-MM-DD 00:00:00" --until="YYYY-MM-DD 23:59:59" --pretty=format:"%h - %s (%ci)" --no-merges
     ```

   - 如果需要查看详细变更，可以使用：

     ```bash
     git log --author="$(git config user.name)" --since="YYYY-MM-DD 00:00:00" --until="YYYY-MM-DD 23:59:59" --pretty=format:"%h - %s%n%b" --stat --no-merges
     ```

4. **格式化日报内容**
   生成以下格式的日报：

   ```markdown
   # Git 提交日报 - YYYY-MM-DD

   **提交者**: [从 git config 获取的用户名] <[从 git config 获取的邮箱]>
   **统计**: X 个提交

   ## 提交记录

   ### [commit-hash] 提交标题

   **时间**: HH:MM:SS
   **变更文件**: X files changed, Y insertions(+), Z deletions(-)

   提交详细说明（如果有）

   主要变更的文件：

   - 文件路径 1
   - 文件路径 2

   ---

   ### [commit-hash] 提交标题

   ...

   ## 总结

   今日共完成 X 个提交，主要工作内容包括：

   - 根据提交信息总结的工作内容
   ```

5. **处理特殊情况**

   - 如果 git config 中没有配置用户信息，提示用户先配置
   - 如果指定日期没有提交记录，输出：`该日期 (YYYY-MM-DD) 没有找到提交记录。`
   - 如果 git 命令执行失败，提示用户检查是否在 git 仓库目录下

6. **输出日报**
   - 直接在终端输出格式化后的日报内容
   - 询问用户是否需要将日报保存为文件（如 `daily-report-YYYY-MM-DD.md`）

## 示例

用户输入：`/daily-report 2026-01-29`

输出：

```markdown
# Git 提交日报 - 2026-01-29

**提交者**: John Doe <john@example.com>
**统计**: 3 个提交

## 提交记录

### [dfb65f1c] refactor: 优化 saveChangeResource 方法，简化参数构建逻辑并增强代码可读性；更新 MetaTableMgV2 组件以支持更多发布状态

**时间**: 14:30:25
**变更文件**: 2 files changed, 45 insertions(+), 30 deletions(-)

主要变更的文件：

- src/api/resource.ts
- src/components/MetaTableMgV2.vue

---

...
```

## 注意事项

- 确保在 git 仓库目录下执行
- 确保 git config 已配置用户信息（user.name 和 user.email）
- 日期格式必须正确（YYYY-MM-DD）
- 只统计当前 git 用户的提交
- 不包含 merge commits
