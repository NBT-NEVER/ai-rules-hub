#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""从 Git 提交消息中移除自动添加的 Co-Authored-By trailer"""
import sys, re
msg = sys.stdin.read()
cleaned = re.sub(
    r'\n*Co-Authored-By: .*?[ \t]*\n?',
    '',
    msg,
    flags=re.IGNORECASE
)
sys.stdout.write(cleaned)
