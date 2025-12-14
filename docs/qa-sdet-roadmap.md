# 🚀 QA/SDET Transition Roadmap (3–6 Months)

A dual-language, step-by-step plan for transitioning into QA Engineer / Automation Tester / SDET roles. Designed for backgrounds in Coding, Technical Writing, and IT Support.

---

## 🌍 English Version

### 🎯 End Goal (3–6 Months)
- **Role:** QA Engineer / Automation Tester / SDET (Junior–Mid).
- **Portfolio:** Real project on GitHub, strong CV, clear QA mindset.

### 🧠 QA Mindset (Before You Start)
| Principle | Why it matters |
|-----------|----------------|
| Automation is the shortest path | Coding background accelerates SDET roles (higher pay, better growth). |
| Great testers think in risks | Not “clickers”; they model systems, find risks, and design logical tests. |
| Documentation is a superpower | Clear test cases and bug reports make Dev/PM trust you. |

---

## 🥇 Phase 1: Foundations & Stack Choice (Weeks 1–4)

### 1) Core Theory (Weeks 1–2)
| Concept | Plain meaning |
|---------|----------------|
| SDLC | Software delivery lifecycle |
| STLC | Test plan → test case → execution → report |
| Models | Agile/Scrum (most common) |
| Test levels | Unit → Integration → System → UAT |
| Test types | Functional; Non-functional (Performance, Security); Regression |
| Bug reporting | Title, Steps, Expected/Actual, Severity vs Priority |

### 2) Pick ONE Automation Stack (Weeks 3–4)
**Rule: avoid scatter. Master 1 language + 1 framework.**

| Option | Language + Framework | Why for SDET |
|--------|----------------------|---------------|
| Recommended | TypeScript + Playwright | Modern, fast, multi-browser, SDET-friendly. |
| If Python | Python + Pytest/Playwright | Easy syntax, big community. |
| If Java | Java + Selenium/RestAssured | Stable, enterprise adoption. |

_Assumption for this roadmap: Playwright + TypeScript (or Python)._ 

---

## 🥈 Phase 2: Build the Automation Framework (Weeks 5–10)
Goal: From simple scripts to a professional GitHub project.

### 3) Web Automation Basics (Week 5)
- Flow: Open browser → Navigate → Locate → Act (click/fill) → Assert.
- **Locators:** Prefer Role/Text/TestID; avoid fragile XPath.
- **Practice:** First login tests (success + failure).

### 4) Apply QA Thinking (Week 6)
- **Test design techniques:**
  - Equivalence Partitioning (EP)
  - Boundary Value Analysis (BVA)
- **Negative coverage:** empty username, short password, bad email format, etc.

### 5) Build a Proper Framework (Weeks 7–8)
- **Project structure (sample):**
```
automation-project/
├── pages/       # POM
├── tests/       # test cases
├── utils/       # data/helpers
└── playwright.config.ts
```
- **POM:** separate UI actions from test logic.
- **Data-driven:** separate test data from code.
- **API bonus:** test 1–2 APIs (GET/POST) via Playwright request or requests/axios.

### 6) Reporting, CI/CD, Finishing (Weeks 9–10)
- **Reporting:** Allure or HTML report.
- **Debug:** screenshots on fail, retries.
- **CI/CD:** GitHub Actions to run on every push.
- Goal: show you can build a test system, not just scripts.

---

## 🥉 Phase 3: Manual Strength & Documentation (Weeks 11–12)

### 7) Write QA-Grade Manual Test Cases
- Include Preconditions, Steps, Expected, Test Data.
- Practice on 1–2 complex features (checkout, complex forms).

### 8) Professional Bug Reports
- Make it easy to **understand** and **reproduce**.
- Structure: Title; Steps; Expected/Actual; Severity/Priority.
- Keep 1–2 excellent examples in your portfolio.

---

## 🧭 Phase 4: Career Positioning & Interviews (Weeks 13–16)

### 9) Portfolio & CV
- GitHub repo with README (setup, tech, how to run).
- CV highlights: automation framework, EP/BVA test design, strong bug reports.
- Impact statement: “Reduced regression time by X% via automation.”

### 10) Interview Readiness
- **Why Dev → Tester?**
  - “I enjoy coding, but I’m passionate about quality risk control. Coding helps me build strong automation to make teams faster.”
- **Case study:** Requirement analysis → test design (EP/BVA) → automation → bug report → improvement.

### 📅 Timeline Snapshot
| Time | Outcome |
|------|---------|
| Weeks 1–4 | Solid QA theory, chosen automation stack |
| Weeks 5–10 | Automation project on GitHub (POM, CI/CD, reporting) |
| Weeks 11–12 | Strong manual test cases and bug reports (EP/BVA) |
| Weeks 13–16 | CV + portfolio ready; confident interviews |

### 🎁 Free Learning Resources
- **Courses:** Test Automation University (free), Guru99 (manual).
- **YouTube:** “Automation Step by Step” (Raghav Pal), “The Testing Academy”.
- **Practice Sites:**
  - Web: saucedemo.com, demoqa.com, the-internet.herokuapp.com
  - API: restful-api.dev, reqres.in

---

## 🇻🇳 Phiên bản Tiếng Việt

### 🎯 Mục Tiêu Cuối (3–6 Tháng)
- **Vị trí:** QA Engineer / Automation Tester / SDET (Junior–Middle).
- **Hồ sơ:** Dự án thật trên GitHub, CV mạnh, tư duy QA rõ ràng.

### 🧠 Tư Duy QA (Trước Khi Bắt Đầu)
| Quan điểm | Lý do |
|-----------|-------|
| Automation là đường ngắn nhất | Nền tảng code giúp vào SDET nhanh (lương và cơ hội tốt). |
| Tester giỏi là người tư duy rủi ro | Không phải “click nhiều”; hiểu hệ thống, dự báo rủi ro, thiết kế test có logic. |
| Documentation là lợi thế | Test case & bug report rõ ràng làm Dev/PM tin tưởng. |

---

## 🥇 Giai Đoạn 1: Xây Nền & Chọn Stack (Tuần 1–4)

### 1) Lý Thuyết Cốt Lõi (Tuần 1–2)
| Khái niệm | Hiểu đơn giản |
|-----------|---------------|
| SDLC | Vòng đời phát triển phần mềm |
| STLC | Test Plan → Test Case → Execution → Report |
| Mô hình | Agile/Scrum (phổ biến) |
| Mức độ test | Unit → Integration → System → UAT |
| Loại test | Functional; Non-Functional (Performance, Security); Regression |
| Bug reporting | Title, Steps, Expected/Actual, Severity vs Priority |

### 2) Chọn 1 Stack Automation (Tuần 3–4)
**Quy tắc: Không lan man. 1 ngôn ngữ + 1 framework.**

| Lựa chọn | Ngôn ngữ + Framework | Vì sao hợp SDET |
|----------|----------------------|-----------------|
| Khuyến nghị | TypeScript + Playwright | Hiện đại, nhanh, đa trình duyệt, thân thiện SDET. |
| Nếu quen Python | Python + Pytest/Playwright | Dễ học, cộng đồng lớn. |
| Nếu quen Java | Java + Selenium/RestAssured | Ổn định, nhiều doanh nghiệp dùng. |

_Giả định roadmap: Playwright + TypeScript (hoặc Python)._ 

---

## 🥈 Giai Đoạn 2: Xây Framework Automation (Tuần 5–10)
Mục tiêu: Từ script cơ bản → Dự án chuyên nghiệp trên GitHub.

### 3) Automation Web Cơ Bản (Tuần 5)
- Quy trình: Mở browser → Điều hướng → Locator → Action (click/fill) → Assert.
- **Locator:** Ưu tiên Role/Text/TestID; hạn chế XPath mong manh.
- **Thực hành:** Viết login pass/fail đầu tiên.

### 4) Áp dụng Tư Duy QA (Tuần 6)
- **Kỹ thuật thiết kế test:**
  - EP (Equivalence Partitioning)
  - BVA (Boundary Value Analysis)
- **Phủ định (Negative):** username trống, password ngắn, email sai format, v.v.

### 5) Viết Framework CHUẨN (Tuần 7–8)
- **Cấu trúc mẫu:**
```
automation-project/
├── pages/       # POM
├── tests/       # test cases
├── utils/       # data/helpers
└── playwright.config.ts
```
- **POM:** Tách tương tác UI khỏi logic test.
- **Data-driven:** Tách test data khỏi code.
- **Bonus API:** Test 1–2 API (GET/POST) bằng Playwright request hoặc requests/axios.

### 6) Báo Cáo, CI/CD, Hoàn Thiện (Tuần 9–10)
- **Báo cáo:** Allure hoặc HTML report.
- **Debug:** Screenshot on fail, retry.
- **CI/CD:** GitHub Actions chạy mỗi lần push.
- Mục tiêu: Chứng minh bạn biết xây hệ thống test, không chỉ viết script.

---

## 🥉 Giai Đoạn 3: Manual & Documentation (Tuần 11–12)

### 7) Viết Test Case Chuẩn QA
- Có Preconditions, Steps, Expected, Test Data.
- Thực hành 1–2 tính năng phức tạp (checkout, form phức tạp).

### 8) Bug Report Chuẩn Chỉnh
- Dễ hiểu & dễ tái hiện.
- Cấu trúc: Title; Steps; Expected/Actual; Severity/Priority.
- Lưu 1–2 bug report mẫu tốt vào portfolio.

---

## 🧭 Giai Đoạn 4: Định Vị & Phỏng Vấn (Tuần 13–16)

### 9) Portfolio & CV
- GitHub repo với README (cách chạy, tech sử dụng).
- CV nhấn mạnh: framework automation, thiết kế test EP/BVA, bug report chất lượng.
- Impact: “Giảm X% thời gian regression nhờ automation.”

### 10) Chuẩn Bị Phỏng Vấn
- **Vì sao Dev → Tester?**
  - “Tôi thích code, nhưng đam mê kiểm soát chất lượng và rủi ro. Code giúp tôi xây automation mạnh cho team.”
- **Case study:** Phân tích yêu cầu → thiết kế test (EP/BVA) → automation → bug report → cải tiến.

### 📅 Timeline Tóm tắt
| Thời gian | Kết quả |
|-----------|---------|
| Tuần 1–4 | Vững lý thuyết QA, chọn stack |
| Tuần 5–10 | Dự án automation trên GitHub (POM, CI/CD, reporting) |
| Tuần 11–12 | Bộ test case & bug report chuẩn (EP/BVA) |
| Tuần 13–16 | CV, portfolio sẵn; tự tin phỏng vấn |

### 🎁 Tài Nguyên Miễn Phí
- **Khóa học:** Test Automation University (free), Guru99 (manual).
- **YouTube:** “Automation Step by Step” (Raghav Pal), “The Testing Academy”.
- **Web practice:**
  - Web: saucedemo.com, demoqa.com, the-internet.herokuapp.com
  - API: restful-api.dev, reqres.in

---

*Use this roadmap as a checklist. Focus on depth over breadth, ship a real project, and showcase clear QA thinking in both manual and automation work.*
