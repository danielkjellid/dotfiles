---
name: prepare-pr
description: Get the current branch ready for a pull request. Explore the diff in depth, have independent subagents review it for correctness, compatibility, patterns, DRY, drift, performance and N+1 queries, then have more subagents look for simplifications and review again.
disable-model-invocation: true
argument-hint: "[base branch, optional]"
---

# Prepare a pull request

Get the current branch ready to open or merge as a pull request. Don't commit, push or open anything unless the user asks: this skill reviews and fixes, and the user decides when it ships.

## 1. Find the diff

- The base is `$ARGUMENTS` if one was given. Otherwise use the open PR's base (`gh pr view --json baseRefName -q .baseRefName`). Failing that, use the repo's default branch.
- Collect `git diff <base>...HEAD`, the list of commits, and any uncommitted changes. Include the uncommitted changes in the review and say that you did.
- Read the project's `CLAUDE.md` and any contributing guide. Repo rules win over the defaults below. For example, a repo that says "no backwards compatibility" changes what the compatibility check is looking for.

## 2. Explore the branch thoroughly

Read every changed file in full, not only the hunks, and read the code that calls it and the code it calls. Before judging anything, build a picture of:

- what the branch sets out to do, and whether it does that
- every public surface it touches: APIs, function signatures, exports, URLs, database schema, config, CLI flags, events, serialized formats
- who consumes those surfaces, both inside the repo and, as far as you can tell, outside it

## 3. What to review against

**Backwards compatibility.** Explore this in depth. For each public surface that changed, say whether existing callers, stored data, links, migrations and clients keep working. Look for renamed or removed exports, changed defaults, reordered or retyped parameters, changed response shapes, and migrations that can't run against live data or can't be rolled back. If a break is intended, check that every call site was updated and that the break is stated.

**Correctness.** Edge cases, empty and missing values, error paths, concurrency and ordering, time zones, off-by-one errors, security (injection, auth checks, leaking data), and tests that actually prove the behaviour.

**Performance.** No N+1 queries: look for a query, request or expensive call inside a loop, a template or a serializer, and for lazy relations read per row. Also check for unbounded queries, missing indexes on new filters, needless work on hot paths, and blocking calls inside async code.

**Established patterns.** Use the framework's idioms and well-known computer science patterns instead of clever one-offs. Match how the surrounding code already solves the same problem.

**DRY and drift.** Look for duplicated logic, and for brittle couplings that will fall out of sync as the code changes: the same constant or string spelled out in two places, regexes or AST parsing of code, behaviour keyed off names, parallel lists that must be kept in step.

**Readability.** Readable code beats a clever fix. Where a fix is subtle, the code should say why, and a simpler version that is nearly as good is better.

**Consolidation.** Keep code together where it reads better that way; not everything needs its own function. Split code out only when common sense calls for it. As a rule of thumb, a helper earns its place when at least three call sites use it independently for the same logic. Being called from three places is not the same as a natural boundary: a split that only exists to be reused is not justified by the call count alone.

**Production readiness.** Logging and errors that someone on call can act on, safe failure modes, feature flags or rollout concerns, and nothing left over from debugging.

**React (js, jsx, ts, tsx).** Declarative and simple. Reuse existing components and hooks before writing new ones. Treat every `useEffect` as suspect: state derived during render, event handlers, keys and data-fetching libraries usually replace it. Avoid barrel exports (`index.ts` files that re-export other modules) where possible: import from the source file, and don't add new entries to an existing barrel.

**Tailwind and CSS.** Utility classes, not complicated custom CSS that works against Tailwind: no deep selector chains, no `!important` wars, no arbitrary values where a theme token exists, and no long conditional class soup where a helper or a variant would do.

**Documentation.** Run any prose written for people through the `humanizer:humanizer` skill: docstrings and doc blocks, READMEs and docs, and the PR description. One-line and inline comments are exempt.

## 4. Review with subagents

Launch at least two review subagents in parallel, in one message, each from a fresh context. Give each one a different focus so they don't duplicate each other:

- **Reviewer A:** backwards compatibility, correctness and performance, including N+1 queries.
- **Reviewer B:** established patterns, DRY and drift, readability, and the React and Tailwind rules where they apply.

Give each one the base branch, the diff command, the repo's rules, and the matching part of section 3. Ask each for findings with a file and line, a concrete failure scenario, a severity, and a suggested fix. Ask them to say "approved" explicitly when they find nothing.

Before reporting, check each finding yourself against the code and drop the ones that don't hold up. **Tell the user about every confirmed problem**, most severe first, and say which ones you intend to fix. Stop and ask before any fix that changes behaviour, a public API or a design decision. Fix the rest, then rerun the reviewers on the new diff. Repeat until both approve.

## 5. Simplify

Before anything else in this step, run the `ponytail:ponytail` skill with the Skill tool, so its rules guide the simplifiers and the changes you apply. Subagents don't inherit loaded skills, so paste ponytail's rules into each simplifier's prompt.

Once the reviewers approve, launch at least two more subagents in parallel to look for simplifications:

- **Simplifier A:** structure. Abstractions that don't earn their keep, indirection, over-general code, and anything that could reuse something that already exists.
- **Simplifier B:** surface. Dead code, unused parameters and exports, redundant tests, comments that repeat the code, and a public API that could be smaller.

A simplification has to keep behaviour identical and make the code easier to read. Show the user the ones worth doing, apply them (asking first where one changes behaviour or an API), then **run the review in section 4 again** on the simplified diff.

## 6. Verify and report

- Run the project's lint, type checks and tests, and its build if it has one. Judge each by its exit status, not by grepping the output. If a cache could hide a failure, run from a cold cache.
- Finish with a short report: what the branch does, compatibility (what breaks, if anything, and for whom), what the reviewers found and what you fixed, what you simplified, what is still open, and the verification results.
- If asked for a PR description, draft it from that report and run it through the humanizer.
