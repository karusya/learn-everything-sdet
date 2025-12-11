# Playwright Test Framework - Complete Guide

## 📖 Introduction

Playwright Test is a modern end-to-end testing framework that bundles test runner, assertions, isolation, parallelization, and rich tooling. It supports Chromium, Firefox, and WebKit browsers on Windows, Linux, and macOS, with native mobile emulation.

**Key Features:**
- Cross-browser testing (Chrome, Firefox, Safari)
- Headless and headed modes
- Parallel test execution
- Auto-waiting and resilient assertions
- Rich debugging tools
- Mobile emulation
- CI/CD integration

---

## 🚀 Installation & Setup

### System Requirements
- **Node.js**: Latest 20.x, 22.x, or 24.x
- **OS**: Windows 11+, macOS 14+, Debian 12/13, Ubuntu 22.04/24.04

### Quick Installation

```bash
# Initialize new project or add to existing
npm init playwright@latest
```

**Configuration Options:**
- ✅ TypeScript or JavaScript
- ✅ Tests folder name (default: `tests` or `e2e`)
- ✅ GitHub Actions workflow (recommended for CI)
- ✅ Install browser binaries

### Alternative Installation Methods

**Using VS Code Extension:**
1. Install "Playwright Test for VS Code" extension
2. Run `Test: Install Playwright` from Command Palette
3. Select browsers and configuration

**Manual Installation:**
```bash
npm install -D @playwright/test
npx playwright install --with-deps
```

### What's Installed
```
playwright.config.ts    # Test configuration
package.json           # Dependencies
tests/                 # Test files
  example.spec.ts      # Sample test
```

---

## ✍️ Writing Your First Tests

### Basic Test Structure

```typescript
import { test, expect } from '@playwright/test';

test('has title', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  await expect(page).toHaveTitle(/Playwright/);
});

test('get started link', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  await page.getByRole('link', { name: 'Get started' }).click();
  await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
});
```

### Core Concepts

#### 🔍 Actions
Playwright automatically waits for elements to be actionable:

```typescript
// Navigation
await page.goto('https://example.com');

// Interactions
await page.getByRole('link', { name: 'Get started' }).click();
await page.locator('#username').fill('user@example.com');
await page.locator('#password').fill('password');
await page.locator('#submit').click();
```

**Common Actions:**
- `locator.click()` - Click element
- `locator.fill(text)` - Fill input field
- `locator.check()` / `locator.uncheck()` - Checkboxes
- `locator.selectOption(value)` - Dropdown selection
- `locator.hover()` - Mouse hover
- `locator.press(key)` - Keyboard input

#### ✅ Assertions
Playwright includes async matchers that wait for conditions:

```typescript
// Page assertions
await expect(page).toHaveTitle(/Playwright/);
await expect(page).toHaveURL('https://playwright.dev/');

// Element assertions
await expect(locator).toBeVisible();
await expect(locator).toContainText('Welcome');
await expect(locator).toHaveValue('expected value');
await expect(locator).toBeChecked();
await expect(locator).toHaveCount(3);
```

#### 🧩 Test Isolation
Each test runs in its own browser context (isolated profile):

```typescript
test('test 1', async ({ page }) => {
  // Fresh browser context
});

test('test 2', async ({ page }) => {
  // Completely isolated from test 1
});
```

#### 🎣 Test Hooks
Organize tests with hooks:

```typescript
test.describe('User Authentication', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://example.com/login');
  });

  test('login with valid credentials', async ({ page }) => {
    // Test implementation
  });

  test('login with invalid credentials', async ({ page }) => {
    // Test implementation
  });
});
```

---

## ▶️ Running & Debugging Tests

### Basic Commands

```bash
# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/example.spec.ts

# Run tests matching pattern
npx playwright test -g "login test"

# Run on specific browser
npx playwright test --project chromium

# Run in headed mode (visible browser)
npx playwright test --headed

# Run failed tests only
npx playwright test --last-failed
```

### UI Mode (Recommended for Development)
Interactive testing interface with step-by-step debugging:

```bash
npx playwright test --ui
```

**Features:**
- Step-by-step test execution
- Live locator picker
- Watch mode
- Visual debugging
- Time travel debugging

### Debugging Options

#### Playwright Inspector
```bash
# Debug all tests
npx playwright test --debug

# Debug specific test
npx playwright test tests/example.spec.ts --debug
```

#### VS Code Debugging
1. Set breakpoint in test
2. Right-click test → "Debug Test"
3. Use live debugging features

### HTML Test Reports
```bash
# Show latest report
npx playwright show-report
```

**Features:**
- Filter by browser, status, duration
- Detailed error information
- Test execution timeline
- Export and sharing options

---

## 🛠️ Advanced Features

### Test Generation with Codegen

Record tests by interacting with your application:

```bash
npx playwright codegen demo.playwright.dev/todomvc
```

**Features:**
- Automatic locator generation
- Assertion recording
- Mobile emulation
- Authentication state preservation

### Trace Viewer

Visual debugging with execution traces:

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    trace: 'on-first-retry', // Record on failure
  },
});
```

```bash
# Force trace recording
npx playwright test --trace on

# View traces in HTML report
npx playwright show-report
```

**Trace Features:**
- Step-by-step execution timeline
- DOM snapshots at each step
- Network request monitoring
- Console logs and errors
- Browser DevTools integration

### CI/CD Setup

#### GitHub Actions Example

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests
on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-node@v5
        with:
          node-version: lts/*
      - name: Install dependencies
        run: npm ci
      - name: Install Playwright Browsers
        run: npx playwright install --with-deps
      - name: Run Playwright tests
        run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: ${{ !cancelled() }}
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

#### Publishing Reports to Azure Storage

```yaml
- name: Upload HTML report to Azure
  shell: bash
  run: |
    REPORT_DIR='run-${{ github.run_id }}-${{ github.run_attempt }}'
    azcopy cp --recursive "./playwright-report/*" "https://YOUR_STORAGE.blob.core.windows.net/\$web/$REPORT_DIR"
    echo "::notice title=HTML report url::https://YOUR_STORAGE.z1.web.core.windows.net/$REPORT_DIR/index.html"
  env:
    AZCOPY_AUTO_LOGIN_TYPE: SPN
    AZCOPY_SPA_APPLICATION_ID: '${{ secrets.AZCOPY_SPA_APPLICATION_ID }}'
    AZCOPY_SPA_CLIENT_SECRET: '${{ secrets.AZCOPY_SPA_CLIENT_SECRET }}'
    AZCOPY_TENANT_ID: '${{ secrets.AZCOPY_TENANT_ID }}'
```

---

## 💻 VS Code Integration

### Getting Started
1. Install "Playwright Test for VS Code" extension
2. Run `Test: Install Playwright` command
3. Select browsers and configuration

### Core Features

#### Test Execution
- Click ▶️ next to any test to run it
- View results in Test Explorer sidebar
- Run all tests or specific test files
- Multi-browser project selection

#### Debugging
- Set breakpoints directly in test code
- Live element highlighting
- AI-powered error suggestions (Copilot)
- Trace viewer integration

#### Test Generation
- **Record New Test**: Click "Record new" in sidebar
- **Record at Cursor**: Add actions to existing tests
- **Pick Locator**: Generate optimal locators

#### Advanced VS Code Features
- Project dependencies for setup tests
- Global setup/teardown management
- Multiple configuration file support
- Real-time test status updates

---

## 📋 Quick Reference

### CLI Commands
```bash
# Installation
npm init playwright@latest
npx playwright install --with-deps

# Running Tests
npx playwright test                           # All tests
npx playwright test --ui                      # UI mode
npx playwright test --headed                  # Headed mode
npx playwright test --project chromium        # Specific browser
npx playwright test -g "test name"            # Match test name
npx playwright test tests/file.spec.ts        # Specific file

# Debugging
npx playwright test --debug                   # Inspector mode
npx playwright test --trace on                # Force tracing

# Reports
npx playwright show-report                    # HTML report

# Code Generation
npx playwright codegen [url]                  # Record tests

# Utilities
npx playwright --version                      # Version info
```

### Configuration Options
```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  // Test directory
  testDir: './tests',

  // Timeout settings
  timeout: 30 * 1000,
  expect: { timeout: 5000 },

  // Browser projects
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],

  // Retry and tracing
  retries: process.env.CI ? 2 : 0,
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  // Reporters
  reporter: [
    ['html'],
    ['junit', { outputFile: 'results.xml' }]
  ],
});
```

### Best Practices
- Use semantic locators (`getByRole`, `getByLabel`)
- Leverage auto-waiting capabilities
- Keep tests isolated and independent
- Use descriptive test names
- Configure retries for CI environments
- Enable tracing for debugging
- Use page objects for complex applications
- Run tests in parallel when possible

---

## 🔗 Additional Resources

- [Official Documentation](https://playwright.dev/docs/intro)
- [API Reference](https://playwright.dev/docs/api/class-playwright)
- [Example Projects](https://github.com/microsoft/playwright-examples)
- [Community Discord](https://aka.ms/playwright/discord)
- [GitHub Repository](https://github.com/microsoft/playwright)

---

*This guide was reorganized from the official Playwright documentation for better readability and logical flow.*
