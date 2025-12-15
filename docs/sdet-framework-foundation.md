# 🏗️ Building Solid SDET Framework Foundations

## 📝 Why NOT Take Shortcuts at the Beginning?

> Real-world lessons from experience - A standard framework is "solid foundation for the fortress"

---

## 🌍 ENGLISH VERSION

### 1. 💡 Introduction: Luck or Painful Lesson?

### My Personal Experience:

I started my career with **good fortune** by working with pre-built Frameworks that were designed according to proper SDET (Software Development Engineer in Test) standards:

- **Playwright** as the core testing framework
- **POM (Page Object Model)** + **Client Model** for API
- **Allure Reporting** built-in
- **CI/CD Pipeline** with GitHub Actions

### Immediate Benefits:

✅ **Enhanced understanding of standard architecture** - Seeing the "skeleton" of a professional Framework

✅ **Easy maintenance** - When UI changes, fix only 1 place instead of dozens

✅ **Easy debugging** - Detailed logs, screenshot on fail, full trace

✅ **Easy expansion/advanced features deployment** - Visual Testing, Data-driven testing, Automatic notifications integration in just days

### 🎯 Key Point:

**Building a proper Framework from the beginning is "solid foundation for the fortress" later on.**

It's not "overcomplicating", but **early investment for long-term harvest**.

---

### 2. 🤯 Junior's Dilemma: "Why Complicate Things?"

### Harsh Reality:

Most Juniors when starting have the same thought: **"Write simple code first, optimize later"**

I was like that too. Below are the most common doubts:

### ❓ Wait/Sync Problem: "Why wait for load state or selector when I just need click()?"

**🎯 Answer (Concise):** Fight Flaky Tests

```typescript
// ❌ WRONG: Click immediately
await page.click('#submit-btn');

// ✅ RIGHT: Ensure element is ready
await page.waitForSelector('#submit-btn', { state: 'visible' });
await page.click('#submit-btn');
```

**Why?** Your Framework will be stable when running parallel (parallel execution) on CI/CD.

### ❓ Logging Problem: "Why log for time waste and full data?"

**🎯 Answer (Concise):** Debug/Traceability

```typescript
// ❌ WRONG: No logging at all
it('Login test', async () => {
  await page.fill('#username', 'user');
  await page.click('#login-btn');
});

// ✅ RIGHT: Full logging
it('Login test', async () => {
  console.log('Starting login test...');
  await page.fill('#username', 'user');
  console.log('Username filled');

  await page.click('#login-btn');
  console.log('Login button clicked');

  await page.waitForURL('**/dashboard');
  console.log('Login successful');
});
```

**Why?** Without logs, it's almost **impossible to find error causes** when tests run on CI/CD server.

### ❓ POM Problem: "Is writing logic directly in test steps faster and easier?"

**🎯 Answer (Concise):** Maintainability & Reusability

```typescript
// ❌ WRONG: Direct logic in test
it('Login and check dashboard', async () => {
  await page.goto('/login');
  await page.fill('[data-testid="username"]', 'user');
  await page.fill('[data-testid="password"]', 'pass');
  await page.click('[data-testid="login-btn"]');

  await expect(page.locator('text=Welcome')).toBeVisible();
});

// ✅ RIGHT: Using POM
it('Login and check dashboard', async () => {
  const loginPage = new LoginPage(page);
  await loginPage.login('user', 'pass');

  const dashboardPage = new DashboardPage(page);
  await expect(dashboardPage.welcomeMessage).toBeVisible();
});
```

**Why?** If UI changes (selector changes), you fix only **1 POM file** instead of dozens of test files.

---

### 3. 💥 Painful Lesson: "Then You See the Real Picture"

### This is the most important part - Consequences of "taking shortcuts"

### Typical Scenario:

**Step 1:** Junior excitedly builds "simple" Framework
- Write all logic in test files
- No POM, no wait, no log
- "If it runs, it's OK, optimize later"

**Step 2:** Framework works well... in local environment
- Tests run fast, all pass
- Boss praises: "Great job, deploy to production!"

**Step 3:** Deploy to CI/CD - "Hell" begins

### 🔥 Consequences when scaling (actually happens):

#### 🚨 UI operations change:
```typescript
// Locator duplicated in 20 test files
await page.click('#old-submit-btn'); // Must fix 20 places
// Instead of fixing only 1 POM file
```

#### 🚨 Logic duplication:
```typescript
// Same Login operation written repeatedly
// In 15 different test files
await page.fill('#username', 'user');
await page.fill('#password', 'pass');
await page.click('#login-btn');
```

#### 🚨 Parallel execution:
```typescript
// Flaky tests everywhere
// Random errors appear
// "Why pass locally but fail CI?"
```

#### 🚨 Refactor: Must spend 5-10x time
```typescript
// Feeling "whole world of pain"
// Must refactor from scratch
// Deadline burning
// Boss asks: "Why so slow?"
```

### 🎯 Painful Conclusion:

**"Initial shortcut = Save 1-2 weeks"**
**"Later fixing = Cost 2-3 months + stress + lost credibility"**

---

### 4. 🧭 Guidance for New Juniors: Learn Standard Framework

### You won't regret the initial time investment!

### 4.1. Standard Structure = Separation (Separation of Concerns)

A good Framework = Framework with **clear layer separation**:

| Layer | Core Function | Main Goal | Example |
|-------|---------------|-----------|---------|
| **Test Layer**<br>`src/tests/` | Contains scenarios (Test Steps) and Assertions | **Orchestration, Clarity** | `expect()`, business flow |
| **UI Abstraction**<br>`src/ui/` | Page Objects, Locators, UI Actions | **Maintainability** | POM classes, selectors |
| **API Abstraction**<br>`src/api/` | API Clients, Endpoints, Data Models | **Reusability** | HTTP methods, DTOs |
| **Utility Layer**<br>`src/utils/` | Logging, Config, Retry Mechanism | **Robustness, Debugging** | Logger, env config |

### 📁 Standard Directory Structure:

```
src/
├── tests/                    # 🧪 Test Layer
│   ├── ui/                   # UI Tests
│   ├── api/                  # API Tests
│   └── e2e/                  # End-to-End Tests
│
├── ui/                       # 🎨 UI Abstraction
│   ├── pages/                # Page Objects
│   └── components/           # Reusable Components
│
├── api/                      # 🔌 API Abstraction
│   ├── clients/              # API Clients
│   ├── models/               # Data Models
│   └── helpers/              # API Utilities
│
├── utils/                    # 🛠️ Utility Layer
│   ├── config/               # Configuration
│   ├── logger/               # Logging
│   └── helpers/              # Common Helpers
│
└── types/                    # 📝 Type Definitions
    └── index.ts
```

### 4.2. Why Standard SDET?

✅ **Solid foundation** makes adopting new tools easier:
- Visual Testing integration (Applitools)
- CI/CD Pipeline (GitHub Actions, Jenkins)
- Data-driven testing (CSV, JSON)
- Cross-browser testing (BrowserStack)
- Performance testing (Lighthouse)

✅ **Helps you achieve SDET standards**:
- Not just QA Automation running scripts
- But engineers capable of building testing systems

✅ **Easy to scale and maintain**:
- Team 5 people → Team 50 people still works
- Small project → Enterprise project still runs

---

### 5. 🎯 Core Principles a Junior Must Master When Building a Framework

### These are foundational knowledge - focus on "why to do", not just "how to do"

### 1. 🏗️ Principles of Layering and Separation of Concerns (SoC)

A good Framework must be divided into clear responsibility layers. Junior must understand this principle primarily because it directly addresses maintenance issues.

| Principle to Understand | Key Details to Master |
|-------------------|----------------|
| **Page Object Model (POM)** | Separate: Element finding logic (Locator) and Actions from Test Assertions.<br>**Goal:** When UI changes, modify only the single Page Object file |
| **API Client/Service Model** | Similar to POM for APIs. Separate: Endpoints and API calling methods from Test Logic.<br>**Goal:** Use API for Data Setup or Data Verification without UI interaction |
| **Test Layer** | Contains only: Business logic (Test Flow) and Result Assertions.<br>**Goal:** This is the only layer allowed to use `expect()` or `assert()` |
| **Importance of utils** | Place all shared, common functions (Config, Logger, Helper Data) into utils to prevent code duplication |

### 2. 🛡️ Anti-Flaky Mechanisms (Ensuring Robustness)

Flaky tests (tests that pass sometimes and fail sometimes) are the biggest enemy of automation. A Junior needs to know how to prevent them from the start.

| Mechanism to Master | Why Essential |
|----------------|----------------|
| **Explicit Waits** | Strictly avoid `waitForTimeout()`. Only use conditional waits from Playwright (e.g., `waitForLoadState('networkidle')`, `page.waitForSelector()`) to ensure elements are ready |
| **Optimal Locators** | Prioritize Locators that are less likely to be changed by developers (e.g., `getByRole()`, `data-testid`, `data-qa`). Avoid brittle locators like long XPath or complex CSS |
| **Basic Retry** | Understand how to apply Retry mechanism (e.g., `this.retries(N)` in Mocha) to crucial tests to mitigate temporary environmental failure impacts |
| **No Shared Page/Context** | When running in parallel, every test (or worker) must have its own independent browser session (Page/Context) to avoid interference |

### 3. ⚙️ Environment and Configuration Management

A professional framework must run seamlessly across different environments.

| Aspect to Understand | Simple Implementation Method |
|------------------|----------------------|
| **External Configuration** | Avoid hard-coding URLs/keys in code. Use `.env` files (dotenv) to manage environment variables (`BASE_URL`, `API_URL`) |
| **Environment Switching** | Easily switch between Dev/Staging/Production by simply setting environment variable (e.g., `TEST_ENV=staging`) |
| **Logging Configuration** | Ability to easily enable/disable or adjust log level (debug, info, warn) via configuration file |

### 4. 📰 Logging and Reporting (Traceability)

A failed test without detailed information is useless.

| Tool/Concept to Understand | Importance for Debugging |
|----------------|----------------|
| **Structured Logging (Pino/Winston)** | Log critical steps of UI Actions (click, fill) and API Request/Response.<br>**Most Important:** Log detailed exceptions/errors to enable debugging on CI servers |
| **Allure/HTML Report** | Understand that Report is more than just PASS/FAIL. It must display Allure Steps, Screenshot on Fail, and Logs/Payloads so non-coders can easily understand the failure root cause |

---
## 6. 🎭 Flexibility - Adapting Frameworks Based on Project Requirements
### 6.1. Standard Frameworks Are "Principles", Not "Rigid Templates"
A common misconception among juniors is that all projects must have every layer (ui/, api/, utils/...). In reality, a skilled SDET knows when to simplify and when to expand.

***Examples of Flexibility:***

|**Project Type / Requirements**|	**How the Framework Can Be Adapted**|	**Why**|
|---|---|---|
|**MVP (Minimum Viable Product)**<br>Small, fast-changing, team of 1-2 people|	• Can combine pages/ and tests/ simply.<br>• Skip complex reporting (Allure), use basic HTML report.<br>• Prioritize simple POM over complex Component Model.|	***Speed is more important than perfection. Need to validate ideas quickly.***|
|**API-First Applications**<br>(Backend services, Microservices)|	• Focus on api/ layer, build Client Model thoroughly.<br>• ui/ layer can be minimal or nonexistent.<br>• Invest heavily in data-driven testing and contract testing.|	***Testing effort should focus on areas with highest risk and business logic.***|
**Legacy Applications**<br>Unstable UI, no data-testid available|	• May need wrapper functions to handle complex waits and retries.<br>• May accept using XPath if no better options exist.<br>• Prioritize capture screenshot and video recording for debugging.	|***Stability (anti-flaky) is top priority; some "clean code" principles can be sacrificed.***|
|**Large Enterprise Projects**<br>Team >10 people, multiple modules|	• Need clear, complete layer structure.<br>• Need Component Model (BasePage, BaseComponent) for maximum reuse.<br>• Must have configuration management and detailed reporting (Allure).|	***Scalability, maintainability, and team collaboration are most important.***|
|**Proof of Concept (POC) for New Tools**<br>(e.g., Visual Testing evaluation)	|• Can write standalone tests outside main framework.<br>• Focus on utils/ layer to integrate new tools.<br>• Minimal structure, easy to discard if POC fails.|	***Goal is tool evaluation, not building long-term systems.***|

### 6.2. Questions to Help You "Adapt" Your Framework Appropriately
***Before starting, ask yourself:***

>1. ***Project scale & lifespan? (2 months or 2 years?)***
>2. ***What's the testing focus? (UI, API, Performance, Security?)***
>3. ***Team size and experience? (Solo or team of 10? Junior or Senior?)***
>4. ***Product development speed? (Does UI change frequently?)***
>5. ***Reporting and integration requirements? (Need Allure for PM reports? Need Slack notifications?)***

**Real Example:**

>"My Project A was a small internal tool with only 5 screens, maintained by a single tester (myself). I chose a simplified version: still separating pages/ and tests/, but skipping the api/ layer (unneeded) and using simple console.log instead of complex Winston. The framework remained 'standard' in separation principles but was streamlined for context."

### 6.3. Advice: Start with Principles, Adapt to Reality

>>1. Always start with core principles: Separation of Concerns (SoC), Anti-Flakky, Configuration Management. These are **"non-negotiable hardware".**
>>2. Be flexible with implementation: Number of layers, POM complexity, logging/reporting tools can be **"adjustable software".**
>>3. Design for change: Your code should be modular so when the project grows, you can easily **"upgrade"** the framework (e.g., add Allure, separate Component Model) without rewriting.

#### 🎯 Key Takeaway for this section:
>***"A good framework isn't one that has everything, but one that BEST FITS the current needs of your project, and is DESIGNED TO ADAPT EASILY when those needs change."***

#### 🎯 Conclusion: Early Investment - Long-term Harvest
>Standard Framework = "Solid Foundation"
Initially: Seems "complicated" and "time-consuming"
Later: Saves hundreds of hours in maintenance and debugging
Result: Become a real SDET, not just "QA running scripts"

#### *****Final Advice for Juniors:*****
>**"Don't hesitate to invest 2-3 weeks initially to learn and apply standard principles. Be adaptable: Use these principles as a compass, not a rigid map. Adjust implementation to fit your project's scale, complexity, and goals. The best framework isn't the most complex one, but the one that fits best and remains sustainable in your specific context!"**

#### 🚀 Next Steps:
```text
1. Learn Theory: Master the principles above
2. Practice: Start with small project, apply each layer
3. Expand: Add advanced features gradually
```
*Standard Framework is not the destination - but the journey. Start today!* 🎯

---

## 🇻🇳 PHIÊN BẢN TIẾNG VIỆT

## 1. 💡 Lời mở đầu: May mắn hay Bài học đau thương?

### Kinh nghiệm cá nhân của tôi:

Tôi bắt đầu sự nghiệp với **may mắn** khi làm việc với các Framework có sẵn, được thiết kế chuẩn chỉnh theo quy tắc SDET (Software Development Engineer in Test):

- **Playwright** làm core testing framework
- **POM (Page Object Model)** + **Client Model** cho API
- **Allure Reporting** tích hợp sẵn
- **CI/CD Pipeline** với GitHub Actions

### Lợi ích ngay lập tức:

✅ **Nâng cao hiểu biết về kiến trúc chuẩn** - Thấy được "skeleton" của một Framework chuyên nghiệp

✅ **Dễ dàng bảo trì (Maintenance)** - Khi UI thay đổi, chỉ sửa 1 chỗ thay vì cả tá

✅ **Dễ dàng gỡ lỗi (Debug)** - Log chi tiết, screenshot on fail, trace đầy đủ

✅ **Mở rộng/Triển khai tính năng nâng cao** - Tích hợp Visual Testing, Data-driven testing, Notification tự động chỉ trong vài ngày

### 🎯 Điểm mấu chốt:

**Việc xây dựng một Framework chuẩn chỉnh ngay từ ban đầu là một "chân móng vững chắc cho thành quách" sau này.**

Không phải "phức tạp hóa", mà là **đầu tư sớm để gặt hái lâu dài**.

---

## 2. 🤯 Nỗi niềm của Junior: "Tại sao phải phức tạp hóa?"

### Thực tế phũ phàng:

Hầu hết Junior khi bắt đầu đều có chung một suy nghĩ: **"Viết code đơn giản trước, tối ưu sau"**

Tôi cũng từng như vậy. Dưới đây là những nghi vấn phổ biến nhất:

### ❓ Vấn đề Wait/Sync: "Tại sao phải wait for load state hay wait for selector khi mình chỉ cần click()?"

**🎯 Đáp án (Ngắn gọn):** Chống Flaky Test

```typescript
// ❌ SAI: Click ngay lập tức
await page.click('#submit-btn');

// ✅ ĐÚNG: Đảm bảo element sẵn sàng
await page.waitForSelector('#submit-btn', { state: 'visible' });
await page.click('#submit-btn');
```

**Tại sao?** Framework của bạn sẽ ổn định khi chạy song song (parallel execution) trên CI/CD.

### ❓ Vấn đề Logging: "Log làm gì cho tốn thời gian và đầy data?"

**🎯 Đáp án (Ngắn gọn):** Debug/Traceability

```typescript
// ❌ SAI: Không log gì cả
it('Login test', async () => {
  await page.fill('#username', 'user');
  await page.click('#login-btn');
});

// ✅ ĐÚNG: Log đầy đủ
it('Login test', async () => {
  console.log('Starting login test...');
  await page.fill('#username', 'user');
  console.log('Username filled');

  await page.click('#login-btn');
  console.log('Login button clicked');

  await page.waitForURL('**/dashboard');
  console.log('Login successful');
});
```

**Tại sao?** Không có Log, gần như **không thể tìm ra nguyên nhân lỗi** khi test chạy trên CI/CD server.

### ❓ Vấn đề Page Object Model (POM): "Viết logic trực tiếp vào step test có phải nhanh và dễ hơn không?"

**🎯 Đáp án (Ngắn gọn):** Maintainability & Reusability

```typescript
// ❌ SAI: Logic trực tiếp trong test
it('Login and check dashboard', async () => {
  await page.goto('/login');
  await page.fill('[data-testid="username"]', 'user');
  await page.fill('[data-testid="password"]', 'pass');
  await page.click('[data-testid="login-btn"]');

  await expect(page.locator('text=Welcome')).toBeVisible();
});

// ✅ ĐÚNG: Sử dụng POM
it('Login and check dashboard', async () => {
  const loginPage = new LoginPage(page);
  await loginPage.login('user', 'pass');

  const dashboardPage = new DashboardPage(page);
  await expect(dashboardPage.welcomeMessage).toBeVisible();
});
```

**Tại sao?** Nếu UI thay đổi (selector đổi), bạn chỉ sửa **1 file POM** thay vì hàng chục file test.

---

## 3. 💥 Bài học đau thương: "Rồi mới thấy cái cảnh"

### Đây là phần quan trọng nhất - Hậu quả của việc "đi tắt"

### Tình huống điển hình:

**Bước 1:** Junior hào hứng xây dựng Framework "đơn giản"
- Viết tất cả logic vào file test
- Không có POM, không có wait, không có log
- "Chạy được là OK, tối ưu sau"

**Bước 2:** Framework hoạt động tốt... trong local environment
- Test chạy nhanh, pass hết
- Sếp khen: "Giỏi quá, deploy lên production đi!"

**Bước 3:** Deploy lên CI/CD - "Cái địa ngục" bắt đầu

### 🔥 Hệ quả khi mở rộng (thực tế xảy ra):

#### 🚨 Thao tác UI thay đổi:
```typescript
// Locator bị trùng lặp ở 20 file test
await page.click('#old-submit-btn'); // Phải sửa 20 chỗ
// Thay vì chỉ sửa 1 file POM
```

#### 🚨 Logic bị lặp:
```typescript
// Cùng một thao tác Login viết đi viết lại
// Ở 15 file test khác nhau
await page.fill('#username', 'user');
await page.fill('#password', 'pass');
await page.click('#login-btn');
```

#### 🚨 Chạy song song (Parallel):
```typescript
// Test flaky tràn lan
// Lỗi ngẫu nhiên xuất hiện
// "Tại sao test pass local mà fail CI?"
```

#### 🚨 Refactor: Phải bỏ thời gian gấp 5-10 lần
```typescript
// Cảm giác "cả một trời đau thương"
// Phải refactor từ đầu
// Deadline cháy đầu
// Sếp hỏi: "Tại sao chậm thế?"
```

### 🎯 Kết luận đau thương:

**"Đi tắt" ban đầu = Tiết kiệm 1-2 tuần**
**"Sửa chữa" sau này = Tốn 2-3 tháng + stress + mất uy tín**

---

## 4. 🧭 Định hướng cho Tân Junior: Hãy học Framework Chuẩn

### Bạn sẽ không hối tiếc khi đầu tư thời gian ban đầu!

### 4.1. Cấu trúc Chuẩn = Tách biệt (Separation of Concerns)

Một Framework tốt = Framework **phân chia rõ ràng các lớp trách nhiệm (Layer)**:

| Layer | Chức năng cốt lõi | Mục tiêu chính | Ví dụ |
|-------|-------------------|----------------|-------|
| **Test Layer**<br>`src/tests/` | Chứa kịch bản (Test Steps) và Assertions | **Orchestration, Clarity** | `expect()`, business flow |
| **UI Abstraction**<br>`src/ui/` | Page Objects, Locators, UI Actions | **Maintainability** | POM classes, selectors |
| **API Abstraction**<br>`src/api/` | API Clients, Endpoints, Data Models | **Reusability** | HTTP methods, DTOs |
| **Utility Layer**<br>`src/utils/` | Logging, Config, Retry Mechanism | **Robustness, Debugging** | Logger, env config |

### 📁 Cấu trúc thư mục chuẩn:

```
src/
├── tests/                    # 🧪 Test Layer
│   ├── ui/                   # UI Tests
│   ├── api/                  # API Tests
│   └── e2e/                  # End-to-End Tests
│
├── ui/                       # 🎨 UI Abstraction
│   ├── pages/                # Page Objects
│   └── components/           # Reusable Components
│
├── api/                      # 🔌 API Abstraction
│   ├── clients/              # API Clients
│   ├── models/               # Data Models
│   └── helpers/              # API Utilities
│
├── utils/                    # 🛠️ Utility Layer
│   ├── config/               # Configuration
│   ├── logger/               # Logging
│   └── helpers/              # Common Helpers
│
└── types/                    # 📝 Type Definitions
    └── index.ts
```

### 4.2. Tại sao lại là Chuẩn SDET?

✅ **Nền tảng vững chắc** giúp vận dụng tool/cái gì đó mới dễ dàng hơn:
- Tích hợp Visual Testing (Applitools)
- CI/CD Pipeline (GitHub Actions, Jenkins)
- Data-driven testing (CSV, JSON)
- Cross-browser testing (BrowserStack)
- Performance testing (Lighthouse)

✅ **Giúp bạn đạt được tiêu chuẩn của một SDET**:
- Không chỉ là QA Automation chạy script
- Mà là kỹ sư có khả năng xây dựng hệ thống testing

✅ **Dễ dàng scale và maintain**:
- Team 5 người → Team 50 người vẫn ổn
- Project nhỏ → Project enterprise vẫn chạy

---

## 5. 🎯 Core Principles a Junior Must Master When Building a Framework

### Đây là những kiến thức nền tảng - tập trung vào "tại sao phải làm", không chỉ "làm thế nào"

### 1. 🏗️ Nguyên tắc Tách biệt và Lớp hóa (Layering & Separation of Concerns)

Một Framework tốt phải được chia thành các lớp trách nhiệm rõ ràng. Junior cần hiểu rằng việc này giúp giải quyết vấn đề bảo trì.

| Nguyên tắc cần hiểu | Chi tiết cần nắm |
|-------------------|----------------|
| **Page Object Model (POM)** | Tách: Logic tìm kiếm phần tử (Locator) và Thao tác (Action) ra khỏi bài Test (Assertion).<br>**Mục tiêu:** Khi UI thay đổi, chỉ cần sửa 1 file Page Object |
| **API Client/Service Model** | Tương tự POM cho API. Tách: Endpoint và Method gọi API ra khỏi bài Test.<br>**Mục tiêu:** Sử dụng API để Setup dữ liệu hoặc Verify dữ liệu mà không cần qua UI |
| **Tầng Test (Test Layer)** | Chỉ chứa: Logic nghiệp vụ (Business Flow) và Xác nhận kết quả (Assertion).<br>**Mục tiêu:** Layer này là nơi duy nhất được phép sử dụng `expect()` hoặc `assert()` |
| **Tầm quan trọng của utils** | Đặt các hàm dùng chung (Config, Logger, Helper Data) vào utils để tránh lặp code |

### 2. 🛡️ Khả năng Chống Lỗi Ngẫu nhiên (Anti-Flaky Mechanisms)

Flaky Test (Test chạy lúc đúng lúc sai) là "kẻ thù" lớn nhất của Automation. Junior cần hiểu cách chống đỡ nó từ đầu.

| Cơ chế cần hiểu | Tại sao phải dùng |
|----------------|----------------|
| **Explicit Wait (Chờ rõ ràng)** | Tuyệt đối tránh `waitForTimeout()`. Chỉ sử dụng các lệnh wait có điều kiện của Playwright (ví dụ: `waitForLoadState('networkidle')`, `page.waitForSelector()`) để đảm bảo phần tử đã sẵn sàng |
| **Locator Tối ưu** | Ưu tiên dùng các Locator ít bị thay đổi bởi Dev (ví dụ: `getByRole()`, `data-testid`, `data-qa`). Tránh các locator dễ vỡ như XPath/CSS quá dài |
| **Retry Cơ bản** | Hiểu cách sử dụng Retry (ví dụ: `this.retries(N)` trong Mocha) cho các bài Test quan trọng để giảm thiểu ảnh hưởng của các lỗi môi trường tạm thời |
| **Không share Page/Context** | Khi chạy song song (Parallel), mỗi Test cần có một phiên làm việc (Page/Browser Context) độc lập để không bị ảnh hưởng bởi nhau |

### 3. ⚙️ Thiết lập Môi trường và Cấu hình (Configuration & Environment)

Một Framework chuyên nghiệp cần chạy được trên nhiều môi trường khác nhau.

| Khía cạnh cần hiểu | Cách triển khai đơn giản |
|------------------|----------------------|
| **External Configuration** | Không để Hard-coded URL/Key trong code. Sử dụng file `.env` (dotenv) để quản lý các biến môi trường (`BASE_URL`, `API_URL`) |
| **Environment Switching** | Dễ dàng chuyển đổi giữa Dev/Staging/Production bằng cách chỉ định biến môi trường (ví dụ: `TEST_ENV=staging`) |
| **Cấu hình Logging** | Khả năng bật/tắt hoặc điều chỉnh mức độ log (debug, info, warn) qua file cấu hình |

### 4. 📰 Ghi nhận và Báo cáo (Logging & Reporting)

Test thất bại mà không có thông tin chi tiết là vô dụng.

| Công cụ cần hiểu | Tầm quan trọng |
|----------------|----------------|
| **Structured Logging (Pino/Winston)** | Ghi lại các bước quan trọng của UI Action (click, fill) và API Request/Response.<br>**Quan trọng nhất:** Ghi lại các ngoại lệ/lỗi một cách chi tiết để debug trên CI |
| **Allure/HTML Report** | Hiểu rằng Report không chỉ là PASS/FAIL, mà là nơi hiển thị Allure Step, Screenshot on Fail, và Log/Payload để người không biết code cũng hiểu chuyện gì đã xảy ra |

---
**"Trước khi kết thúc, có một góc nhìn tinh tế mà các bạn Junior nên cân nhắc. Xây dựng một framework 'chuẩn' không có nghĩa là áp dụng cứng nhắc một khuôn mẫu. Một kỹ năng quan trọng của SDET là biết điều chỉnh và thích ứng framework dựa trên yêu cầu thực tế của từng dự án. Phần dưới đây sẽ giúp bạn hiểu khi nào cần đơn giản hóa và khi nào cần mở rộng"**

## 6. 🎭 Tính Linh Hoạt - Điều Chỉnh Framework Theo Yêu Cầu Dự Án
### 6.1. Framework Chuẩn Là "Nguyên Tắc", Không Phải "Khuôn Mẫu" Cứng Nhắc
Một hiểu lầm phổ biến của Junior là nghĩ rằng tất cả dự án đều phải có đầy đủ mọi layer (ui/, api/, utils/...). Thực tế, một SDET giỏi biết khi nào cần đơn giản hóa và khi nào cần mở rộng.

***Ví dụ về sự linh hoạt:**

|**Loại Dự Án / Yêu Cầu**|	**Framework Có Thể Được Điều Chỉnh Thế Nào?**|	**Lý Do**|
|---|---|---|
|**MVP (Sản phẩm thử nghiệm)**<br>Nhỏ, thay đổi nhanh, team 1-2 người	| - Có thể gộp pages và tests/ đơn giản.<br>- Tạm bỏ qua complex reporting (Allure), dùng HTML report cơ bản.<br>- Ưu tiên POM đơn giản hơn là Component Model phức tạp.|	***Tốc độ quan trọng hơn sự hoàn hảo. Cần validate ý tưởng nhanh***|
|**Ứng dụng chủ yếu là AP**<br>(Backend service, Microservices)|	- Tập trung vào api/ layer, xây dựng Client Model kỹ.<br>- ui/ layer có thể rất nhỏ hoặc không có.<br>- Đầu tư mạnh vào data-driven testing và contract testing.| ***Testing effort nên tập trung vào nơi có rủi ro và logic nghiệp vụ chính.***|
|**Ứng dụng Legacy (Cũ)**<br>UI không ổn định, không có **data-testid**|-	Có thể cần Wrapper functions để handle wait và retry phức tạp hơn.<br>- Có thể chấp nhận dùng XPath nếu không còn lựa chọn nào khác.<br>- Ưu tiên capture screenshot và video recording để debug.	| ***Tính ổn định (anti-flaky) là ưu tiên số 1, có thể hy sinh một phần tính "clean code".***| 
|**Dự án Enterprise Lớn**<br> Team >10 người, nhiều module|- Cần cấu trúc rõ ràng, đầy đủ các layer.<br>- Cần Component Model (BasePage, BaseComponent) để tái sử dụng tối đa.<br>- Bắt buộc có Configuration management và Detailed Reporting (Allure).| ***Khả năng mở rộng, bảo trì và hợp tác trong team là quan trọng nhất.***|
|**Proof of Concept (POC) cho Tool mới**<br>(VD: thử nghiệm Visual Testing)	| - Có thể viết test độc lập, ngoài framework chính.<br>- Tập trung layer utils/ để tích hợp tool mới.<br>- Cấu trúc tối giản, dễ dàng bỏ đi nếu POC thất bại.|	***Mục tiêu là đánh giá tool, không phải xây dựng hệ thống lâu dài.***|

### 6.2. Các Câu Hỏi Giúp Bạn "Điều Chỉnh" Framework Phù Hợp
***Trước khi bắt đầu, hãy tự hỏi:***
```yaml
- Quy mô & Thời gian sống của dự án? (2 tháng hay 2 năm?)
- Đâu là trọng tâm testing? (UI, API, Performance, Security?)
- Team size và kinh nghiệm? (Một mình hay team 10 người? Junior hay Senior?)
- Tốc độ phát triển sản phẩm? (UI có hay thay đổi không?)
- Yêu cầu về báo cáo và tích hợp? (Cần Allure để report cho PM? Cần tích hợp Slack notification?)
```
***Ví dụ thực tế:***

*****"Dự án A của tôi là một internal tool nhỏ, chỉ có 5 màn hình, chạy bởi 1 tester duy nhất (chính tôi). Tôi đã chọn một phiên bản đơn giản: vẫn có pages/ và tests/ tách biệt, nhưng bỏ qua api/ layer (vì không cần) và dùng console.log đơn giản thay vì Winston phức tạp. Framework vẫn 'chuẩn' ở nguyên tắc tách biệt, nhưng được tinh gọn cho phù hợp bối cảnh."*****
|---|

### 6.3. Lời Khuyên: Bắt Đầu Từ Nguyên Tắc, Điều Chỉnh Theo Thực Tế

1. ***Luôn bắt đầu với các nguyên tắc cốt lõi: Tách biệt (SoC), Chống Flaky, Quản lý cấu hình. Đây là "phần cứng" không nên thỏa hiệp.***
2. ***Linh hoạt với việc triển khai (implementation): Số lượng layer, độ phức tạp của POM, công cụ logging/reporting có thể là "phần mềm" để điều chỉnh.***
3. ***Thiết kế để dễ thay đổi: Code của bạn nên được module hóa để khi dự án phát triển, bạn có thể dễ dàng "nâng cấp" framework (ví dụ: thêm Allure, tách Component Model) mà không phải viết lại.***

#### 🎯 Key Takeaway cho phần này:
***"Một Framework tốt không phải là Framework có mọi thứ, mà là Framework PHÙ HỢP NHẤT với nhu cầu hiện tại của dự án, và được THIẾT KẾ ĐỂ DỄ DÀNG THÍCH ỨNG khi nhu cầu đó thay đổi."***

|*****"Final Advice for Juniors:*****|
|----|
|1. *****Đừng ngại đầu tư 2-3 tuần ban đầu để học và áp dụng các nguyên tắc chuẩn.*****<br>2. *****Hãy linh hoạt: Sử dụng các nguyên tắc đó như một la bàn, không phải một bản đồ cứng nhắc. Điều chỉnh việc triển khai cho phù hợp với quy mô, độ phức tạp và mục tiêu của dự án bạn đang làm.*****<br>3. *****Framework tốt nhất không phải là framework phức tạp nhất, mà là framework phù hợp nhất và bền vững nhất cho hoàn cảnh của bạn."*****

---

*Framework chuẩn không phải là đích đến - mà là hành trình. Hãy bắt đầu ngay hôm nay!* 🎯
