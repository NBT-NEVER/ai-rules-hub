# Project Grounding Rules

Use this reference whenever the final thesis must match the real software project.

## Sources Of Truth

Use, in order:

1. build/config files
2. SQL schema / migrations
3. entities / DTOs
4. controllers / services / repositories
5. project docs
6. the old draft, only after cross-checking

## Forbidden Fabrication

Do not invent:
- modules
- interfaces
- database tables / fields
- performance data
- throughput / latency / P95
- user scale
- deployment scale
- security certifications
- test screenshots or logs

## Conservative Writing Rules

- Downgrade unsupported "innovation" into engineering highlights.
- Do not claim production validation without evidence.
- If testing is manual, say so plainly.
- If no stress test exists, omit benchmark-style claims.

## Figure/Table Rules

- Redraw unsupported or colorful figures.
- Keep tables tied to actual schema, workflows, or verifiable test cases.
- Do not use diagrams that cannot be traced back to the project.
