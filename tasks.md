# Implementation tasks

## Phase 1: project foundation

> **Goal**: scaffold project, define types, build core app modules with tests.

- [x] T001: Initialize Angular, Node server, and SQLite database (delivery_record, error_log). Configure Vitest, ESLint, Prettier, tsconfig strict mode. See [plan.md](plan.md) for the project structure.
- [x] T002: Define TypeScript interfaces and union types (status, channel)
- [x] T003: Implement Postmark logic (REQ-001, REQ-002)

### === Checkpoint 1 ===

#### What to test:

- pnpm run test
- pnpm run build
- pnpm run lint

#### What you'll see:

- No UI and auth yet - this is pure logic verification
- Outbound email message works