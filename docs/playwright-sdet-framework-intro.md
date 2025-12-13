# 🚀 Introducing the Playwright SDET Framework: From Basics to Advanced Architecture

> A comprehensive guide to understanding and implementing a professional SDET testing framework

---

## 📚 Framework Repository

**GitHub Repository:** [vanvo19870515/playwright-sdet-framework](https://github.com/vanvo19870515/playwright-sdet-framework)

**Clone for Learning:**
```bash
git clone https://github.com/vanvo19870515/playwright-sdet-framework.git
cd playwright-sdet-framework
npm install
npx playwright install --with-deps
TEST_ENV=dev npm run demo:with-report
```

---

## 🌍 ENGLISH VERSION

### I. 🎯 Who is This Framework For? (Target Audience)

**QAs Transitioning from Manual to Automation:**
This serves as a standardized stepping stone to learn the best design patterns (POM, Service Model) right from the start.

**SDETs / Senior QAs:**
Those looking to set up a scalable and robust testing environment by unifying API and UI under a single runner (Mocha) and reporting tool (Allure).

**Dev/Testers:**
Individuals who want to integrate Hybrid Testing (using the API for data setup, using the UI for flow confirmation) to reduce flakiness and increase test speed.

### II. 🎯 Framework Goals & Stack

#### Core Goals:
- **TypeScript Stack**: Modern, type-safe development
- **UI**: Playwright + Page Object Model (POM)
- **API**: Axios clients with models/validators
- **Tests**: Mocha (parallel execution), Allure reports
- **Hybrid**: API + UI integration, optional visual testing
- **Environment**: Multi-env support via `.env.<env>`
- **Anti-Flaky**: Retries, stable locators, no shared browser/page

#### Tech Stack Summary:
- **Language**: TypeScript
- **UI Testing**: Playwright + POM
- **API Testing**: Axios client with models
- **Test Runner**: Mocha (parallel)
- **Reporting**: Allure reports
- **Logging**: Pino logger
- **CI/CD**: GitHub Actions ready

#### What This Framework IS For:
- QA moving from Manual to Automation
- SDET/Senior QA needing unified API+UI runner
- Teams wanting Allure reporting with grep/tag friendly Mocha

#### What This Framework is NOT:
- Load/performance testing replacement
- Low-code/no-code solution
- Wrapper of Playwright Test runner (uses Mocha by design)

### III. 🏗️ Detailed Architecture & Project Structure

#### Project Structure Overview:
```
playwright-sdet-framework/
├── src/
│   ├── api/
│   │   ├── clients/        # API clients (user.api.ts)
│   │   ├── models/         # Data models (user.model.ts)
│   │   ├── validators/     # API validators
│   │   └── waits/          # API wait helpers
│   │
│   ├── ui/
│   │   ├── pages/          # POM pages (BasePage.ts, BasicFormPage.ts)
│   │   ├── actions/        # UI actions library
│   │   ├── components/     # Complex widget placeholders
│   │   └── waits/          # Navigation/visual waits
│   │
│   ├── tests/
│   │   ├── api/            # API-only tests
│   │   ├── ui/             # UI-only tests
│   │   └── hybrid/         # Hybrid API+UI tests
│   │
│   ├── utils/              # Shared utilities
│   │   ├── config.ts       # Configuration
│   │   ├── env.ts          # Environment handling
│   │   ├── retry.ts        # Retry mechanisms
│   │   └── logger.ts       # Pino logger
│   │
│   ├── reporting/          # Allure helpers
│   └── fixtures/           # testContext (per-test browser/page)
│
├── docs/architecture.md   # Architecture documentation
├── playwright.config.ts   # Playwright configuration
├── .github/workflows/ci.yml # CI/CD pipeline
├── .env.dev/.env.staging/.env.prod  # Environment configs
└── package.json
```

#### A. The Golden Rule: Separation of Concerns (SoC)

This architecture promotes maintainability and clarity.

| Layer (Folder) | Role in Testing | Benefit for Beginners |
|----------------|-----------------|----------------------|
| **src/ui/** | UI Actions Library (Page Object Model - POM) | You only need to focus on the ACTION (e.g., `loginPage.enterEmail()`) without worrying about complex locators. Easy to maintain. |
| **src/api/** | API Communication Library (Service Model) | Used to quickly create or clean up data via API. No need to go through the UI, saving time. |
| **src/tests/** | Business Scenarios (Test Scenarios) | This is where you tell the story of the test (`it(...)`). Focus only on the business flow and confirming results (`expect(...)`). |
| **src/utils/** | Shared Toolbox | Contains common utilities like the Logger (Pino) and environment Config. Keeps the code clean and manageable. |

#### B. Decoding the Tools (For the Absolute Beginner)

We use simplified analogies to eliminate the fear of complex technical terms:

| Concept/Tool | Role (Analogy) | Simplest Explanation |
|--------------|----------------|---------------------|
| **Mocha** | The Project Manager | The main tool that decides which test runs, when it stops, and when the Report (Allure) is generated. |
| **Pino** | The Log Secretary | The library that records every important action (Log): what the API sent, where the UI clicked, and if there were any errors. Purpose: When a Test fails on the CI system, Pino helps you review every step. |
| **testContext.ts / Fixtures** | The Independent Workstation | This is where the Framework prepares everything needed before a Test starts (e.g., creating a new Browser Page, initializing the API Client). Crucial: It ensures every Test has a clean, isolated "workstation." |
| **Models & Validators** | The Data Blueprint (Schema) | Model is the data blueprint (e.g., a User must have a name, email, id). Validator checks: "Does the API data conform to this blueprint?" |

#### C. Anti-Flaky Philosophy (Anti-Flaky & Robustness)

These principles are core to understanding why the architecture is designed this way:

| Anti-Flaky |  We implement 3 golden rules for stable tests |
|--------------|------------------------------------|
| **Stable Locators** | Use reliable selectors (`getByRole`, `data-testid`) that don't break easily. |
| **Controlled Retries** | Smart retry mechanisms (`this.retries(2)`) for flaky operations. |
| **State-based Waits** |  Avoid `waitForTimeout()` — use `waitForLoadState('networkidle')` |
| **Parallel/Worker** | Run multiple tests simultaneously (Mocha `--parallel`) but never share the Page/Browser between workers to avoid random failures. |
| **Security/Performance Guardrail** | Not a load-test tool, but includes quick guardrails for Security Headers and basic Page Load Time to catch issues early. |

### IV. ⚡ Scripts & Quick Start Guide

#### Available Scripts:
- `npm test` : Run all Mocha tests (parallel per file)
- `npm run test:ui` : UI tests only
- `npm run test:api` : API tests only
- `npm run test:hybrid` : Hybrid API+UI tests
- `npm run test:allure` : Run tests + generate Allure results
- `npm run allure:serve` : Open Allure report
- `npm run demo:with-report` : Complete demo (signup API + security + perf + Allure auto-open)

#### Quick Start (Local Development):
```bash
# Clone the repository
git clone https://github.com/vanvo19870515/playwright-sdet-framework.git
cd playwright-sdet-framework

# Install dependencies
npm install

# Install Playwright browsers
npx playwright install --with-deps

# Run demo with full report
TEST_ENV=dev npm run demo:with-report
```

#### Demo Test Cases:

**🏆 Complete Demo (Recommended First Run):**
```bash
npm run demo:with-report
```
*Includes: API signup, security headers check, performance guardrail, Allure report auto-open*

**🔌 API Only:**
```bash
TEST_ENV=dev npm run test:api
```

**🖥️ UI Only:**
```bash
TEST_ENV=dev npm run test:ui
```

**🔀 Hybrid E2E:**
```bash
TEST_ENV=dev npm run test:hybrid
```

#### Environment Configuration:

**Example `.env.dev`:**
```bash
BASE_URL=https://testpages.eviltester.com
API_URL=https://thinking-tester-contact-list.herokuapp.com
LOG_LEVEL=info
VISUAL_ENABLED=false
```

**Environment Switching:**
- Set `TEST_ENV=dev|staging|prod`
- Variables loaded from `.env.<env>` file
- Supports different URLs and configs per environment

### III. ⌨️ Code Approach Guide (Advice for Juniors)

#### Step 1: Run and See
Start by running the command `npm run demo:with-report` to see how the Allure Report works.

#### Step 2: Analyze the Scenario
Open the `src/tests/ui/form.ui.spec.ts` file (or similar). Focus on reading the `describe/it` blocks to understand **What** the Test is doing.

#### Step 3: Trace the Action
When you see `loginPage.enterCredentials(...)`, jump to the Page Object file (`src/ui/pages/LoginPage.ts`) to see **How** that function is written.

**Mindset:** Always ask **"Why did they call this function here?"** Instead of trying to memorize syntax, focus on the flow of the system.

---

## 🇻🇳 PHIÊN BẢN TIẾNG VIỆT

### I. 🎯 Framework Này Dành Cho Ai? (Who Should Use This?)

**QA chuyển từ Manual sang Automation:**
Cần một bước đệm chuẩn chỉnh để học các mô hình thiết kế tốt nhất (POM, Service Model) ngay từ đầu.

**SDET / Senior QA:**
Muốn thiết lập một môi trường kiểm thử scalable (có thể mở rộng) và robust (ổn định) bằng cách thống nhất API và UI dưới cùng một runner (Mocha) và báo cáo (Allure).

**Dev/Tester:**
Muốn tích hợp kiểm thử Hybrid (dùng API để chuẩn bị dữ liệu, dùng UI để xác nhận flow) để giảm độ flaky và tăng tốc độ test.

### II. 🎯 Mục Tiêu & Tech Stack

#### Mục tiêu cốt lõi:
- **Ngôn ngữ**: TypeScript (type-safe, modern)
- **UI**: Playwright + Page Object Model (POM)
- **API**: Axios client với models/validators
- **Test Runner**: Mocha (parallel execution)
- **Reporting**: Allure reports
- **Hybrid**: API + UI integration, Visual testing optional
- **Environment**: Multi-env support qua `.env.<env>`
- **Anti-flaky**: Retry, locator stable, không share page/browser

#### Tech Stack tổng quan:
- **Language**: TypeScript
- **UI Testing**: Playwright + POM
- **API Testing**: Axios client với models
- **Test Runner**: Mocha (parallel)
- **Reporting**: Allure reports
- **Logging**: Pino logger
- **CI/CD**: GitHub Actions ready

#### Framework NÀY DÀNH CHO:
- QA chuyển từ Manual sang Automation
- SDET/Senior QA cần unified API+UI runner
- Teams muốn Allure reporting với grep/tag friendly

#### Framework NÀY KHÔNG PHẢI:
- Thay thế load/perf testing tools
- Low-code/no-code solution
- Wrapper của Playwright Test runner (dùng Mocha by design)

### III. 🏗️ Kiến Trúc Chi Tiết & Cấu Trúc Project

#### Cấu trúc Project Tổng quan:
```
playwright-sdet-framework/
├── src/
│   ├── api/
│   │   ├── clients/        # API clients (user.api.ts)
│   │   ├── models/         # Data models (user.model.ts)
│   │   ├── validators/     # API validators
│   │   └── waits/          # API wait helpers
│   │
│   ├── ui/
│   │   ├── pages/          # POM pages (BasePage.ts, BasicFormPage.ts)
│   │   ├── actions/        # UI actions library
│   │   ├── components/     # Complex widget placeholders
│   │   └── waits/          # Navigation/visual waits
│   │
│   ├── tests/
│   │   ├── api/            # API-only tests
│   │   ├── ui/             # UI-only tests
│   │   └── hybrid/         # Hybrid API+UI tests
│   │
│   ├── utils/              # Shared utilities
│   │   ├── config.ts       # Configuration
│   │   ├── env.ts          # Environment handling
│   │   ├── retry.ts        # Retry mechanisms
│   │   └── logger.ts       # Pino logger
│   │
│   ├── reporting/          # Allure helpers
│   └── fixtures/           # testContext (per-test browser/page)
│
├── docs/architecture.md   # Tài liệu architecture
├── playwright.config.ts   # Playwright configuration
├── .github/workflows/ci.yml # CI/CD pipeline
├── .env.dev/.env.staging/.env.prod  # Environment configs
└── package.json
```

#### A. Nguyên Tắc Vàng: Tách Biệt Trách Nhiệm (Separation of Concerns)

| Lớp (Folder) | Vai trò trong Kiểm thử | Lợi ích cho người mới |
|-------------|----------------------|----------------------|
| **src/ui/** | Thư Viện Thao Tác UI (Page Object Model - POM) | Bạn chỉ cần quan tâm đến HÀNH ĐỘNG (ví dụ: `loginPage.enterEmail()`) mà không cần lo lắng về locator phức tạp. Dễ bảo trì. |
| **src/api/** | Thư Viện Giao Tiếp API (Service Model) | Dùng để tạo hoặc dọn dẹp dữ liệu nhanh chóng qua API. Không cần qua UI, tiết kiệm thời gian. |
| **src/tests/** | Kịch Bản Nghiệp Vụ (Test Scenarios) | Đây là nơi bạn kể câu chuyện của bài test (`it(...)`). Chỉ tập trung vào flow nghiệp vụ và xác nhận kết quả (`expect(...)`). |
| **src/utils/** | Hộp Đồ Dùng Chung | Nơi chứa các công cụ dùng chung như Logger (Pino), Config môi trường. Giúp code gọn gàng, dễ quản lý. |

#### B. Giải Mã Công Cụ (Dành cho Người mới toanh)

Sử dụng bảng giải mã đơn giản hóa để loại bỏ sự sợ hãi về thuật ngữ:

| Khái niệm/Công cụ | Vai trò (Hình ảnh hóa) | Giải thích Đơn giản nhất |
|------------------|----------------------|-------------------------|
| **Mocha** | Người Quản Lý Dự Án | Quyết định Test nào chạy, dừng, và tạo báo cáo. |
| **Pino** | Thư Ký Ghi Chép | Ghi lại mọi hành động và lỗi, giúp bạn debug dễ dàng trên CI. |
| **testContext.ts / Fixtures** | Bàn Làm Việc Độc Lập | Chuẩn bị mọi thứ (Browser, Page, API Client) cho mỗi bài test, đảm bảo chúng không ảnh hưởng lẫn nhau. |
| **Models & Validators** | Bản Thiết Kế Dữ liệu | Đảm bảo dữ liệu (API) trả về đúng khuôn mẫu mong đợi. |

#### C. Tư Duy Chống Lỗi (Anti-Flaky & Robustness)

Những điểm này là cốt lõi để người mới hiểu tại sao họ phải làm "phức tạp":

| Anti-Flaky |  Chúng tôi áp dụng 3 nguyên tắc vàng để test luôn ổn định: |
|--------------|------------------------------------|
| **Locator ổn định** | Sử dụng selectors (`getByRole`, `data-testid`) đáng tin cậy, không dễ vỡ. |
| **Retry có kiểm soát** | Cơ chế retry thông minh (`this.retries(2)`) cho operations flaky. |
| **Wait theo trạng thái** | Tránh `waitForTimeout()` — dùng `waitForLoadState('networkidle')` |
| **Parallel/Worker** | Framework chạy nhiều test cùng lúc (Mocha `--parallel`) nhưng tuyệt đối không chia sẻ Page/Browser giữa các Worker để tránh lỗi ngẫu nhiên. |
| **Mở rộng Bảo mật/Hiệu năng (Guardrail)l** | Framework không thay thế công cụ Load Test, nhưng có guardrail kiểm tra nhanh Security Headers và thời gian tải trang cơ bản để phát hiện lỗi sớm. |

### IV. ⚡ Scripts & Hướng Dẫn Quick Start

#### Các Scripts có sẵn:
- `npm test` : Chạy tất cả Mocha tests (song song theo file)
- `npm run test:ui` : UI tests only
- `npm run test:api` : API tests only
- `npm run test:hybrid` : Hybrid API+UI tests
- `npm run test:allure` : Chạy tests + generate Allure results
- `npm run allure:serve` : Mở Allure report
- `npm run demo:with-report` : Demo hoàn chỉnh (signup API + security + perf + Allure auto-open)

#### Quick Start (Local Development):
```bash
# Clone repository
git clone https://github.com/vanvo19870515/playwright-sdet-framework.git
cd playwright-sdet-framework

# Cài đặt dependencies
npm install

# Cài đặt Playwright browsers
npx playwright install --with-deps

# Chạy demo với full report
TEST_ENV=dev npm run demo:with-report
```

#### Demo Test Cases:

**🏆 Demo Hoàn Chỉnh (Khuyến nghị chạy đầu tiên):**
```bash
npm run demo:with-report
```
*Bao gồm: API signup, security headers check, performance guardrail, Allure report auto-open*

**🔌 API Only:**
```bash
TEST_ENV=dev npm run test:api
```

**🖥️ UI Only:**
```bash
TEST_ENV=dev npm run test:ui
```

**🔀 Hybrid E2E:**
```bash
TEST_ENV=dev npm run test:hybrid
```

#### Cấu hình Environment:

**Ví dụ `.env.dev`:**
```bash
BASE_URL=https://testpages.eviltester.com
API_URL=https://thinking-tester-contact-list.herokuapp.com
LOG_LEVEL=info
VISUAL_ENABLED=false
```

**Environment Switching:**
- Set `TEST_ENV=dev|staging|prod`
- Biến được load từ file `.env.<env>`
- Hỗ trợ URLs và configs khác nhau cho từng environment

### III. ⌨️ Hướng Dẫn Tiếp Cận Code (Lời khuyên cho Junior)

#### Bước 1: Chạy Thử
Bắt đầu bằng việc chạy lệnh `npm run demo:with-report` để xem Báo cáo Allure hoạt động như thế nào.

#### Bước 2: Phân tích Kịch bản
Mở file `src/tests/ui/form.ui.spec.ts` (hoặc tương tự). Tập trung đọc phần `describe/it` để hiểu Test đang làm gì.

#### Bước 3: Truy ngược Hành động
Khi thấy `loginPage.enterCredentials(...)`, hãy nhảy sang file Page Object (`src/ui/pages/LoginPage.ts`) để xem cách hàm đó được viết.

**Tư duy:** Hãy luôn hỏi **"Tại sao họ lại gọi hàm này?"** Thay vì cố gắng học thuộc cú pháp, hãy tập trung vào flow của hệ thống.

---

## 🎯 FRAMEWORK OVERVIEW SUMMARY

### 🏗️ **Architecture at a Glance**
```
src/
├── ui/          # 🎨 Page Objects & UI Actions
├── api/         # 🔌 API Clients & Data Models
├── tests/       # 🧪 Test Scenarios & Assertions
└── utils/       # 🛠️ Shared Utilities & Config
```

### 🚀 **Key Benefits**
- **Scalable:** Easy to add new tests and features
- **Maintainable:** Clear separation reduces complexity
- **Robust:** Anti-flaky mechanisms ensure stability
- **Professional:** Follows SDET industry standards

### 📚 **Learning Path for Beginners**
1. **Run the Framework** → See it in action
2. **Read Test Scenarios** → Understand the "what"
3. **Explore Page Objects** → Learn the "how"
4. **Study Architecture** → Master the "why"

### 🎓 **Who Should Study This?**
- **Manual QAs** learning automation
- **Junior Automators** wanting standards
- **Mid-level Testers** seeking advancement
- **Anyone** wanting professional testing skills

---

*This framework introduction serves as both a learning guide and implementation reference for aspiring SDETs!* 🎯
