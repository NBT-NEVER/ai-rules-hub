#!/usr/bin/env python3
"""Generate a Chinese, human-readable literature download report.

The script reads common CSV logs produced by this skill and writes:
- 下载报告.html
- README_先看我.md
- 下载报告.pdf when Edge/Chrome/Chromium is available

If `journal_metrics.csv` exists in the run folder, the report will show
impact factor/quartile/source fields. Metrics must be verified by the agent
or user before use; the script does not invent impact factors.
"""

from __future__ import annotations

import argparse
import csv
import html
import shutil
import shutil
import subprocess
import sys
from pathlib import Path


STATUS_ZH = {
    "success_pdf": "已下载 PDF",
    "success_html": "已保存网页全文",
    "success_xml": "已保存 XML 全文",
    "metadata_only": "只找到题录",
    "inaccessible": "平台限制",
    "broken_link": "链接失效",
    "rate_limited": "被限流",
    "excluded": "已排除",
    "failed": "尝试失败",
}


REASON_ZH = {
    "http_401": "需要登录或机构权限",
    "http_402": "需要付费或订阅",
    "http_403": "平台拒绝直连下载，建议学校库/VPN/馆际互借",
    "http_404": "链接不存在或已变更",
    "http_410": "链接已失效",
    "paywall_or_login_detected": "检测到登录页或付费墙",
    "no_candidate_url": "没有找到可尝试的全文链接",
    "HTTPError": "网页请求失败，需要人工复查入口",
    "html_stub_not_fulltext": "只拿到跳转页/占位页，不是真正全文",
}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return [dict(row) for row in csv.DictReader(handle)]


def choose_log(run_root: Path) -> tuple[Path | None, list[dict[str, str]]]:
    candidates = [
        run_root / "总下载日志.csv",
        run_root / "combined_download_log.csv",
        run_root / "下载日志.csv",
        run_root / "download_log.csv",
        run_root / "download_logs" / "下载日志.csv",
        run_root / "download_logs" / "download_log.csv",
    ]
    for path in candidates:
        rows = read_csv(path)
        if rows:
            return path, rows
    return None, []


def choose_candidate_rows(run_root: Path) -> list[dict[str, str]]:
    for path in [run_root / "candidate_table.csv", run_root / "候选文献总表.csv"]:
        rows = read_csv(path)
        if rows:
            return rows
    return []


def normalize_key(value: object) -> str:
    return " ".join(str(value or "").casefold().strip().split())


def normalize_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    best: dict[str, dict[str, str]] = {}
    for index, row in enumerate(rows, start=1):
        row_id = row.get("id") or row.get("record_id") or str(index)
        row["id"] = row_id
        old = best.get(row_id)
        row_status = status(row)
        old_status = status(old) if old else ""
        if old is None or (not old_status.startswith("success") and row_status.startswith("success")):
            best[row_id] = row
    return [best[key] for key in sorted(best, key=lambda value: int(value) if value.isdigit() else 999999)]


def merge_candidate_and_log(candidate_rows: list[dict[str, str]], log_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    logs_by_id: dict[str, dict[str, str]] = {}
    logs_by_doi: dict[str, dict[str, str]] = {}
    for row in log_rows:
        row_id = row.get("id") or row.get("record_id") or ""
        doi = normalize_key(row.get("doi") or row.get("DOI"))
        if row_id:
            logs_by_id[row_id] = row
        if doi:
            logs_by_doi[doi] = row
    if not candidate_rows:
        return log_rows
    merged = []
    for index, row in enumerate(candidate_rows, start=1):
        row_id = row.get("record_id") or row.get("id") or row.get("序号") or str(index)
        doi = normalize_key(row.get("doi") or row.get("DOI"))
        log = logs_by_id.get(row_id) or logs_by_doi.get(doi) or {}
        item = dict(row)
        item["id"] = row_id
        for key in ["status", "download_status", "file", "final_path", "reason", "failure_reason"]:
            if log.get(key):
                item[key] = log[key]
        return_status = log.get("download_status") or log.get("status")
        if return_status:
            item["status"] = return_status
        if log.get("final_url") and not item.get("landing_page_url"):
            item["landing_page_url"] = log["final_url"]
        merged.append(item)
    return merged


def read_metrics(run_root: Path, explicit_path: str | None) -> dict[str, dict[str, str]]:
    paths = []
    if explicit_path:
        paths.append(Path(explicit_path))
    paths.append(run_root / "期刊指标.csv")
    paths.append(run_root / "journal_metrics.csv")
    metrics: dict[str, dict[str, str]] = {}
    for path in paths:
        for row in read_csv(path.expanduser()):
            for key_name in ["journal", "source", "venue"]:
                key = normalize_key(row.get(key_name))
                if key:
                    metrics[key] = row
    return metrics


def apply_metrics(rows: list[dict[str, str]], metrics: dict[str, dict[str, str]]) -> None:
    for row in rows:
        metric_row = metrics.get(normalize_key(row.get("journal"))) or {}
        for field in ["impact_factor", "jcr_quartile", "metric_year", "metric_source", "indexing", "venue_note"]:
            if not row.get(field) and metric_row.get(field):
                row[field] = metric_row[field]


def status(row: dict[str, str] | None) -> str:
    if not row:
        return ""
    return row.get("status") or row.get("download_status") or "metadata_only"


def file_name(row: dict[str, str]) -> str:
    value = row.get("file") or row.get("final_path") or ""
    return Path(value).name if value else ""


def reason(row: dict[str, str]) -> str:
    raw = row.get("reason") or row.get("failure_reason") or ""
    return REASON_ZH.get(raw, raw)


def title(row: dict[str, str]) -> str:
    return row.get("title") or row.get("paper") or "未命名文献"


def esc(value: object) -> str:
    return html.escape(str(value or ""), quote=True)


def metric_text(row: dict[str, str]) -> str:
    parts = []
    impact_factor = row.get("impact_factor") or row.get("if")
    if impact_factor:
        parts.append(f"IF {impact_factor}")
    if row.get("jcr_quartile"):
        parts.append(row["jcr_quartile"])
    if row.get("indexing"):
        parts.append(row["indexing"])
    if row.get("metric_year") or row.get("metric_source"):
        source = " / ".join(value for value in [row.get("metric_year"), row.get("metric_source")] if value)
        if source:
            parts.append(source)
    return "；".join(parts) if parts else "待核验"


def action_text(row: dict[str, str]) -> str:
    row_status = status(row)
    if row_status == "success_pdf":
        return "可直接阅读 PDF"
    if row_status in {"success_html", "success_xml"}:
        return "可先阅读全文页面，再人工追 PDF"
    if row_status == "inaccessible":
        return "用学校库/VPN；不行就馆际互借或联系作者"
    if row_status == "metadata_only":
        return "继续查作者主页、机构仓储、Unpaywall"
    if row_status == "broken_link":
        return "用 DOI 重新打开出版社页面"
    return reason(row) or "人工复查"


def status_class(row_status: str) -> str:
    if row_status == "success_pdf":
        return "ok"
    if row_status in {"success_html", "success_xml"}:
        return "warn"
    return "bad"


def browser_candidates() -> list[str]:
    names = ["msedge", "chrome", "chromium", "chromium-browser", "google-chrome"]
    found = [path for name in names if (path := shutil.which(name))]
    windows_paths = [
        r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
        r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    ]
    found.extend(path for path in windows_paths if Path(path).exists())
    return found


def print_pdf(html_path: Path, pdf_path: Path) -> str | None:
    for browser in browser_candidates():
        cmd = [
            browser,
            "--headless",
            "--disable-gpu",
            f"--print-to-pdf={pdf_path}",
            html_path.resolve().as_uri(),
        ]
        try:
            subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=90)
            if pdf_path.exists() and pdf_path.stat().st_size > 1000:
                return browser
        except Exception:
            continue
    return None


def make_html(rows: list[dict[str, str]], title_text: str, source_log: Path | None) -> str:
    total = len(rows)
    pdf_count = sum(1 for row in rows if status(row) == "success_pdf")
    html_count = sum(1 for row in rows if status(row) in {"success_html", "success_xml"})
    failed_count = sum(1 for row in rows if not status(row).startswith("success"))
    metric_count = sum(1 for row in rows if metric_text(row) != "待核验")
    cards = [
        ("尝试文献", total),
        ("已下载 PDF", pdf_count),
        ("网页/XML 全文", html_count),
        ("需后续处理", failed_count),
        ("已标注指标", metric_count),
    ]
    card_html = "\n".join(
        f"<div class='card'><div class='num'>{number}</div><div class='label'>{label}</div></div>"
        for label, number in cards
    )
    success_rows = [row for row in rows if status(row).startswith("success")]
    failed_rows = [row for row in rows if not status(row).startswith("success")]

    def table(section_rows: list[dict[str, str]], unresolved: bool) -> str:
        body = []
        for row in section_rows:
            row_status = status(row)
            status_text = STATUS_ZH.get(row_status, row_status)
            note = action_text(row) if unresolved else file_name(row)
            body.append(
                "<tr>"
                f"<td class='idx'>{esc(row.get('id'))}</td>"
                f"<td>{esc(row.get('year'))}</td>"
                f"<td><div class='paper-title'>{esc(title(row))}</div><div class='doi'>{esc(row.get('doi'))}</div></td>"
f"<td>{esc(row.get('journal'))}</td>"
f"<td>{esc(metric_text(row))}</td>"
                f"<td><span class='badge {status_class(row_status)}'>{esc(status_text)}</span></td>"
                f"<td>{esc(note)}</td>"
                "</tr>"
            )
        return "\n".join(body) or "<tr><td colspan='7'>无</td></tr>"

    return f"""<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<title>{esc(title_text)}</title>
<style>
body {{ font-family: "Microsoft YaHei", "Noto Sans CJK SC", Arial, sans-serif; margin: 34px; color: #172033; line-height: 1.55; background: #ffffff; }}
h1 {{ font-size: 30px; margin: 0 0 6px; letter-spacing: 0; }}
h2 {{ margin-top: 30px; border-bottom: 2px solid #e5e7eb; padding-bottom: 7px; font-size: 20px; }}
.sub {{ color: #667085; margin-bottom: 20px; }}
.cards {{ display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; margin: 18px 0 22px; }}
.card {{ border: 1px solid #d7dee8; border-radius: 8px; padding: 13px; background: #f8fafc; }}
.num {{ font-size: 26px; font-weight: 800; color: #0f766e; }}
.label {{ color: #475467; font-size: 13px; }}
.note {{ background: #fff7ed; border: 1px solid #fdba74; padding: 12px 14px; border-radius: 8px; margin: 14px 0; }}
.tip {{ background: #ecfdf5; border: 1px solid #86efac; padding: 12px 14px; border-radius: 8px; margin: 14px 0; }}
table {{ width: 100%; border-collapse: collapse; font-size: 11.5px; table-layout: fixed; }}
th, td {{ border: 1px solid #d7dee8; padding: 7px; vertical-align: top; overflow-wrap: anywhere; }}
th {{ background: #eef2f7; text-align: left; color: #344054; }}
.idx {{ width: 32px; text-align: center; font-weight: 700; }}
.paper-title {{ font-weight: 700; color: #111827; }}
.doi {{ color: #667085; margin-top: 4px; font-size: 10.5px; }}
.badge {{ display: inline-block; border-radius: 999px; padding: 2px 7px; font-size: 11px; font-weight: 700; white-space: nowrap; }}
.ok {{ background: #dcfce7; color: #166534; }}
.warn {{ background: #fef3c7; color: #92400e; }}
.bad {{ background: #fee2e2; color: #991b1b; }}
code {{ background: #f3f4f6; padding: 2px 5px; border-radius: 4px; }}
@media print {{
  body {{ margin: 14mm; }}
  .cards {{ grid-template-columns: repeat(5, 1fr); }}
  table {{ font-size: 9.5px; }}
  h2 {{ break-after: avoid; }}
  tr {{ break-inside: avoid; }}
}}
</style>
</head>
<body>
<h1>{esc(title_text)}</h1>
<div class="sub">来源日志：{esc(source_log) if source_log else "未找到日志"}。本报告只统计合法直连下载结果。</div>
<div class="cards">{card_html}</div>
<div class="tip">阅读顺序：先看“已经拿到的全文”，再处理“需要后续处理”。影响因子/分区仅在已核验来源时显示；没有核验时显示“待核验”。</div>
<div class="note">没下成通常不是程序坏了，而是出版社或数据库限制自动直连下载。遇到 403、登录页、订阅页时，应使用学校图书馆/VPN、馆际互借、机构仓储或联系作者。</div>

<h2>已经拿到的全文</h2>
<table>
<thead><tr><th style="width:32px">#</th><th style="width:42px">年份</th><th>题名 / DOI</th><th style="width:115px">期刊/来源</th><th style="width:105px">影响因子/分区</th><th style="width:70px">状态</th><th>文件/动作</th></tr></thead>
<tbody>{table(success_rows, False)}</tbody>
</table>

<h2>需要后续处理的文献</h2>
<table>
<thead><tr><th style="width:32px">#</th><th style="width:42px">年份</th><th>题名 / DOI</th><th style="width:115px">期刊/来源</th><th style="width:105px">影响因子/分区</th><th style="width:70px">状态</th><th>建议</th></tr></thead>
<tbody>{table(failed_rows, True)}</tbody>
</table>

<h2>给学生的下一步</h2>
<ol>
<li>先读已下载 PDF 中和课题最贴近的 5-8 篇，边读边做笔记。</li>
<li>影响因子/分区只用于初筛，不要代替论文质量判断；重点看方法、数据、结论和可复现性。</li>
<li>对未下载成功但很重要的文献，用 DOI 走学校图书馆、机构 VPN 或馆际互借。</li>
<li>CSV 日志只用于追溯，不需要普通阅读时打开。</li>
<li>需要打开原文网页时，看 <code>文章地址总表.csv</code>。</li>
</ol>
</body>
</html>
"""


def make_readme(run_root: Path, title_text: str, pdf_path: Path, html_path: Path, rows: list[dict[str, str]]) -> str:
    pdf_count = sum(1 for row in rows if status(row) == "success_pdf")
    html_count = sum(1 for row in rows if status(row) in {"success_html", "success_xml"})
    failed_count = sum(1 for row in rows if not status(row).startswith("success"))
    metric_count = sum(1 for row in rows if metric_text(row) != "待核验")
    return "\n".join(
        [
            f"# {title_text}",
            "",
            "先看这个：",
            "",
            f"- PDF 报告：`{pdf_path}`" if pdf_path.exists() else f"- HTML 报告：`{html_path}`",
            f"- 文献目录：`{run_root}`",
            f"- 总下载日志：`{run_root / '总下载日志.csv'}`",
            f"- 已下载 PDF：`{pdf_count}`",
            f"- 已保存网页/XML 全文：`{html_count}`",
            f"- 需要后续处理：`{failed_count}`",
            f"- 已标注影响因子/分区：`{metric_count}`",
            "",
            "说明：没有直接下载成功的文献，多数是出版社或数据库限制自动直连下载。建议用学校图书馆、机构 VPN、馆际互借或联系作者继续获取。",
            "",
        ]
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="生成普通人能看懂的中文文献下载报告。")
    parser.add_argument("--run-root", required=True, help="文献下载任务目录。")
    parser.add_argument("--title", default="文献下载报告")
    parser.add_argument("--metrics-csv", help="可选：包含 journal,impact_factor,jcr_quartile,metric_year,metric_source,indexing 的 CSV。")
    parser.add_argument("--pdf", action="store_true", help="尝试用 Edge/Chrome/Chromium 导出 PDF。")
    args = parser.parse_args()

    run_root = Path(args.run_root).expanduser().resolve()
    source_log, rows = choose_log(run_root)
    if not rows:
        print(f"没有找到可用下载日志：{run_root}", file=sys.stderr)
        return 2
    rows = normalize_rows(merge_candidate_and_log(choose_candidate_rows(run_root), rows))
    apply_metrics(rows, read_metrics(run_root, args.metrics_csv))

    html_path = run_root / "下载报告.html"
    pdf_path = run_root / "下载报告.pdf"
    readme_path = run_root / "README_先看我.md"

    html_path.write_text(make_html(rows, args.title, source_log), encoding="utf-8")
    browser = print_pdf(html_path, pdf_path) if args.pdf else None
    readme_path.write_text(make_readme(run_root, args.title, pdf_path, html_path, rows), encoding="utf-8")

    if source_log and source_log.resolve() != (run_root / "总下载日志.csv").resolve():
        shutil.copyfile(source_log, run_root / "总下载日志.csv")

    print(f"HTML: {html_path}")
    if browser:
        print(f"PDF: {pdf_path}")
        print(f"PDF browser: {browser}")
    elif args.pdf:
        print("PDF: 未生成，本机没有可用的 Edge/Chrome/Chromium 无头打印命令")
    print(f"README: {readme_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
