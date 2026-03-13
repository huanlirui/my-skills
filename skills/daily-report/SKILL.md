---
name: daily-report
description: 根据指定日期读取当前 git 用户提交，输出中文 Git 日报（模块、改动与完成事项）。
---

# daily-report

根据指定日期生成 Git 提交日报，并用中文说明：

- 在什么模块改动
- 修改了什么
- 做了什么

## 使用方法

```bash
/daily-report [日期]
```

如果不提供日期参数，默认生成今天的日报。

日期格式示例：

- `today`：今天
- `yesterday`：昨天
- `2026-03-13`：指定日期

## 技能描述

当用户调用此技能时，按以下步骤执行：

1. **解析日期参数**

   - 若参数为 `today` 或缺省：使用今天的日期
   - 若参数为 `yesterday`：使用昨天日期
   - 若参数为 `YYYY-MM-DD`：直接使用该日期
   - 生成查询窗口：`YYYY-MM-DD 00:00:00` 到 `YYYY-MM-DD 23:59:59`

2. **获取 Git 用户信息**

   - 使用 `git config user.name` 与 `git config user.email`
   - 若未配置，提示用户先执行：

     ```bash
     git config user.name "Your Name"
     git config user.email "your.email@example.com"
     ```

3. **读取当日提交日志（仅当前用户，排除 merge）**

   - 执行查询：

     ```bash
     git log \
       --author="$(git config user.name)" \
       --since="YYYY-MM-DD 00:00:00" \
       --until="YYYY-MM-DD 23:59:59" \
       --no-merges \
       --pretty=format:"__COMMIT__%n%H%n%h%n%an%n%ae%n%ad%n%s%n%b" \
       --date=iso \
       --numstat
     ```

   - 从日志提取：
     - 提交基本信息：hash、时间、标题、正文
     - 文件级改动：新增/删除行数、文件路径

4. **识别“模块-改动-工作内容”**

   - 模块识别规则（按顺序）：
     - 优先使用提交标题范围标识，如 `feat(auth): ...` 的 `auth`
     - 否则使用文件路径首段或业务目录，如 `src/auth/*` -> `auth`，`packages/ui/*` -> `ui`
     - 若无法识别，归类为 `misc`
   - “修改了什么”：
     - 基于 `--numstat` 与文件路径，概括文件层面的变更（新增功能、修复、重构、测试、文档、配置）
   - “做了什么”：
     - 综合提交标题/正文与文件改动，提炼成人可读工作项（中文短句）

5. **生成“日报主体”**

   - 无提交时：输出 `当天无提交记录`
   - 有提交时至少输出：
     - 当日提交数
     - 当日涉及模块（去重）
     - 当日主要工作（3-6 条）
     - 关键提交明细（可精简）
     - 修改了什么（按文件或目录归纳）

6. **输出格式（中文 Markdown）**

   输出格式如下：

   ```markdown
   # Git 提交日报 - YYYY-MM-DD

   **提交者**: 用户名 <邮箱>
   **统计**: X 个提交
   **涉及模块**: auth, ui, misc

   ## 今日进展

   ### 做了什么
   - ...
   - ...

   ### 修改了什么
   - src/auth/login.ts: 修复登录状态校验并补充异常处理
   - packages/ui/Button.vue: 重构按钮样式变量并统一尺寸行为

   ### 关键提交
   - `a1b2c3d` feat(auth): 支持短信验证码登录
   - `e4f5g6h` refactor(ui): 提取按钮公共样式逻辑

   ## 今日总结
   - 完成 ...（1-3 条）
   - 风险/阻塞 ...（若可识别）
   - 明日建议跟进 ...（1-2 条）
   ```

7. **异常处理**

   - 不在 Git 仓库：提示切换到仓库目录
   - 指定日期无提交：输出完整日报骨架，并标记 `当天无提交记录`
   - git 命令失败：提示用户检查仓库状态和权限

8. **输出要求**

   - 直接输出中文 Markdown 日报内容
   - 必须基于真实 git 提交，不得凭空编造

## 注意事项

- 输出必须是中文
- 仅统计当前 git 用户提交，排除 merge commits
- 优先体现“模块、改动、完成事项”，避免仅罗列 commit 标题
