# Playwright Agents & Test Automation Guide

## Canary releases

Playwright publishes daily canary builds under the `@next` npm dist tag. This lets you try upcoming features ahead of stable release and send early feedback.  
```
npm install -D @playwright/test@next
```
Learn more at [Playwright docs](https://playwright.dev/) (press Shift five times to view next docs).

## Playwright Test Agents

Three agents power the agentic loop:

- **🎭 planner** explores the app and builds a Markdown test plan (`specs/basic-operations.md`).
- **🎭 generator** turns the plan into executable tests (written to `tests/`).
- **🎭 healer** repairs failing tests automatically by replaying steps, updating locators, and rerunning until success.

### Getting started

1. Run `npx playwright init-agents --loop=vscode` (requires VS Code 1.105+).  
2. Use your preferred AI tool to prompt the planner/generator/healer sequentially.  
3. Store specs and generated tests under the recommended folder structure:

```
repo/
├── specs/
│   └── basic-operations.md
├── tests/
│   └── seed.spec.ts
│   └── tests/create/add-valid-todo.spec.ts
├── playwright.config.ts
└── .github/
    └── agent definitions
```

## Annotations & tags

Built-in annotations:

- `test.skip()` – test is ignored.  
- `test.fail()` – test must fail.  
- `test.fixme()` – skipped due to known issue.  
- `test.slow()` – triples timeout.  

Apply annotations/tags per test or describe block:

```ts
test('login @fast', { tag: '@fast' }, async ({ page }) => { ... });

test.describe('report', { annotation: { type: 'issue', description: 'https://github.com/microsoft/playwright/issues/23180' } }, () => {
  test('header', async () => { ... });
});
```

Use `--grep`/`--grep-invert` on CLI to filter by tags.

## Test execution basics

- `npx playwright test` – run all projects.  
- `--project=<name>` – run selected project.  
- `--headed`, `--debug`, `--ui` – interact with browsers.  
- `--workers=1` – disable parallelism.

Use `test.describe.configure({ mode: 'parallel' })` to run tests inside a file concurrently.  
Focus tests with `test.only` or skip them with `test.skip` (supports conditional predicates).

## Playwright CLI cheatsheet

| Command | Description |
| --- | --- |
| `npx playwright test` | Run tests |
| `npx playwright install --with-deps` | Install browsers + deps |
| `npx playwright codegen <url>` | Record flows |
| `npx playwright test --ui` | Launch interactive UI mode |
| `npx playwright show-report` | View last HTML report |
| `npx playwright merge-reports path` | Merge blob reports |

## Advanced topics

### Parallelism & sharding

- `test.describe.configure({ mode: 'serial' })` prevents parallelism inside a file.  
- Run `npx playwright test --shard=1/4` (etc.) to split suites across machines.  
- Use `blob` reporter on CI and merge reports via `npx playwright merge-reports`.

### Fixtures & configuration

- Fixtures represent shared setup/state (`page`, `context`, `request`).  
- Extend `test` via `test.extend` for custom fixtures.  
- Use automatic fixtures (`{ auto: true }`) for global hooks.

### Global setup/teardown

- Prefer project dependencies for global setup (adds traces).  
- Alternatively configure `globalSetup`/`globalTeardown` in `playwright.config.ts`.

### Configuration options

Examples:

```ts
export default defineConfig({
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    viewport: { width: 1280, height: 720 },
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
  ],
});
```

### Environment & secrets

Pass secrets via env vars:
```
USER_NAME=me PASSWORD=secret npx playwright test
```
Use `.env` files with `dotenv` for easier management.

### Reporters

- `html`: default interactive report.  
- `blob`: CI-friendly artifacts for merging.  
- `json`, `junit`, `dot`, `line` etc.  
- `github` reporter adds annotations on GitHub Actions.

### Retries & timeouts

- Configure `retries` globally or per describe/test.  
- `test.setTimeout(120000)` adjusts per test.  
- `expect(..., { timeout: 10000 })` sets assertion timeouts.  
- `globalTimeout` caps whole suite.

### Additional resources

- Use fixtures to share user data (see worker-scoped fixtures).  
- Use `parallel`/`serial` describe to control execution order.  
- Use `testInfo` inside tests/fixtures to inspect retries or annotations.

