# Code style rules

## Code quality

Write clean, well-named, modular functions and classes. Prefer small single-purpose functions over large multi-step ones.

## Guidance files

- **Style guide:** `style-guide/` is the source of truth for code conventions and overrides generic skill examples and general Angular guidance. Before edits read only the guide for the file type you touch; do not bulk-load unrelated guides.
  - [Angular baseline](style-guide/style-guide.md) – component and Angular coding conventions.
  - [TypeScript](style-guide/style-guide.ts.md) – `.ts` files and TypeScript patterns.
  - [HTML templates](style-guide/style-guide.html.md) – Angular templates and template accessibility.
  - [SCSS](style-guide/style-guide.scss.md) – component styles, selectors, tokens, and layout.
  - [Accessibility](style-guide/style-guide.a11y.md) – semantic HTML, keyboard behavior, ARIA, and WCAG checks.
  - [Security](style-guide/style-guide.security.md) – untrusted input, sanitization, CSP, and authorization.
  - [Testing](style-guide/style-guide.spec.md) – unit and e2e test conventions.
  - [NPM packages](style-guide/style-guide.npm.md) – dependency and package changes.
  - [Git](style-guide/style-guide.git.md) – branch, commit, and review workflow.
  - [Markdown](style-guide/style-guide.md.md) – documentation and Markdown edits.

## Verification & Commands

- **Lint:** run ESLint (`ng lint`) over the workspace. Zero errors and no new warnings before declaring a task done; do not rely on IDE hints alone. Read the lint summary as well as its exit status – warnings are findings even when the command succeeds.
- **Type-check:** lint does not type-check. After code changes run `ng build`; it is the only step that type-checks templates under the strict compiler options.
- **Dev server:** never start one (`npm start` / `ng serve`) without explicit approval. The app runs on `http://localhost:4200`. First check whether it is already running – `curl -s -o /dev/null -w '%{http_code}' http://localhost:4200` returning `200` means it is, so use it. Only if nothing answers may you ask for approval to start it; never start a second server on a port already in use. Whenever you serve anything, put a clickable link to the relevant page in the reply (e.g. `http://localhost:4200/register`) and say when you stop it again.
- **Ports are always links – hard rule:** every time a reply mentions a local port or server (`:4200`, "port 4200", "the server on 4200"), write it as a full clickable URL – `http://localhost:4200/register`, never a bare `:4200` or `4200`. This applies to every mention, not only the first one, and to reports, summaries and status lines as well as to code blocks. There is no exception for brevity.
- **Unit tests:** Vitest via `npm run test -- --watch=false` (`--watch=false` makes the run terminate instead of entering watch mode). Check for a Vitest setup first; if none is found, do not write or modify `.spec.ts` files.
- **E2E:** Playwright, when `playwright.config.ts` exists: `npm run test:e2e` runs against the user-started app on `http://localhost:4200`. Managed server startup (`PLAYWRIGHT_START_SERVER=1`) counts as starting a dev server and needs the same explicit approval. If no Playwright setup is found, do not write, use, or generate Playwright tests; if no Cypress setup is found, do not write, use, or generate Cypress tests.

## Angular & TypeScript – repo-specific rules

The style guides own the general conventions (strict TypeScript, no `any`, signals, `OnPush`, control flow, DI, forms, a11y). The rules below are the ones the guides do not cover:

- **No hardcoded layout values:** Never assume fixed pixel sizes for dynamically sized elements (chips, tags, badges, etc.). Always measure actual rendered dimensions via `offsetWidth`/`offsetHeight`/`getBoundingClientRect()` and account for CSS `gap`, `padding`, and `flex-shrink` behavior.
- **Attribute order in templates:** the category order in `style-guide/style-guide.html.md` is enforced as an ESLint error (`@angular-eslint/template/attributes-order`).
- **Templates:** no arrow functions in templates, and no globals such as `new Date()` – templates cannot see them; move the logic into the component class.
