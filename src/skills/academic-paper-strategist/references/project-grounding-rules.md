# Project Grounding Rules

Use this reference whenever the thesis must be based on a real software project.

## Sources Of Truth

Prefer evidence in this order:

1. Build/config files
2. SQL schema / migration files
3. Domain entities / DTOs
4. Controllers / services / repositories
5. Project docs written for this repo
6. Existing draft thesis

The existing draft is not a source of truth unless its content can be tied back to the codebase or project docs.

## Never Invent

Do not fabricate:
- features or modules not present in the repository
- APIs or endpoints not present in controllers / docs
- database tables or fields not present in SQL/entities
- stress-test data
- throughput, latency, P95, QPS
- deployment scale
- user count or production usage
- security certifications
- screenshots or logs not actually available

## Wording Rules

- Replace "创新点" with conservative wording such as:
  - engineering highlight
  - implementation characteristic
  - integration advantage
  - maintainability improvement
  - consistency/safety design
- If the project only demonstrates implementation, say "designed and implemented" rather than "proved", "validated at scale", or "significantly improved".
- If testing evidence is manual, say "manual functional verification" or "scenario-based testing", not "large-scale performance validation".

## Testing Chapter Rules

Allowed evidence:
- unit/integration test files that actually exist
- manual test scenarios tied to functions in the system
- screenshots or observable results from the local system
- schema checks and workflow walkthroughs

Forbidden inferences:
- unsupported benchmark tables
- fabricated concurrency numbers
- cloud deployment reliability claims
- claims about "online users" without evidence

## Figure/Table Rules

- Redraw any figure that is decorative, colorful, or unsupported by the repository.
- Every figure caption should correspond to a real chapter purpose.
- Database tables in the thesis should be derived from actual SQL/entity definitions.

## Chapter Mapping Guidance

- Background and significance can cite real domain context, but system capabilities must come from the project.
- Requirements analysis should reflect real roles, workflows, and constraints.
- Overall design should reflect actual architecture and package/module organization.
- Detailed implementation should cite real mechanisms such as authentication, validation, locking, caching, signing, export, or storage.
- Testing should describe what was actually checked, not what would ideally be checked in a full production rollout.
