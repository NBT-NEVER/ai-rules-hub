# 贡献指南

感谢你愿意改进 Literature Downloader Skill。

## 项目原则

所有贡献都必须遵守：

- 只支持合法可访问的全文获取
- 不绕过付费墙、登录、DRM 或访问控制
- 不接入或推荐盗版论文来源
- 不提交个人下载结果、论文 PDF、账号信息、Cookie、token、API key
- 面向中文用户，输出要清楚、易懂、可复现

## 推荐贡献方向

- 改进中文报告和 CSV 表格可读性
- 增加新的合法数据库检索流程
- 优化 DOI、PMID、PMCID、arXiv ID 解析
- 改进 HTML 跳转页、登录页、付费墙识别
- 增加期刊指标核验来源说明
- 改进 Windows/macOS/Linux 兼容性
- 增加最小化、可复现的测试样例

## 提交前检查

请至少运行：

```bash
python -m py_compile scripts/*.py
```

如果你在 Codex skill 环境中开发，也请运行 skill 校验器：

```bash
python <skill-creator>/scripts/quick_validate.py .
```

提交前请扫描敏感信息，例如：

```bash
git grep -n -I -E "<本机路径>|<凭据>|<账号>|<下载结果>"
```

不要提交运行生成的目录或文件，例如：

```text
已下载全文/
内部数据_一般不用打开/
下载报告.pdf
下载日志.csv
文章地址总表.csv
```

这些已在 `.gitignore` 中排除。

## Pull Request 建议

PR 描述中请写清楚：

- 解决了什么问题
- 改了哪些文件
- 如何验证
- 是否涉及下载、网络访问或第三方平台规则
- 是否新增任何可能涉及版权或隐私的行为

如果改动可能影响合规边界，请优先在 issue 中讨论。
