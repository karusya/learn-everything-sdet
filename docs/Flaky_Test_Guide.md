# 🧩 Flaky Test - Hướng Dẫn Hoàn Chỉnh

## ❓ Flaky Test Là Gì?

**Flaky Test** = Test khi chạy nhiều lần thì **lúc pass - lúc fail**, dù code không hề thay đổi.

### 🎯 Đặc Điểm Chính
- ❌ **Fail ngẫu nhiên** - Không theo pattern cố định
- 🐛 **Khó debug** - Không biết nguyên nhân chính xác
- 😔 **Giảm niềm tin** - Team mất confidence vào test suite
- 📊 **Thống kê thất thường** - CI/CD pipeline lúc đỏ lúc xanh

### 💡 Ví Dụ Thực Tế
```bash
# Chạy 10 lần - Kết quả khác nhau
✅ Test 1: PASS    ❌ Test 6: FAIL
✅ Test 2: PASS    ✅ Test 7: PASS
✅ Test 3: PASS    ❌ Test 8: FAIL
✅ Test 4: PASS    ✅ Test 9: PASS
❌ Test 5: FAIL    ❌ Test 10: FAIL
```

---

## 🚨 Dấu Hiệu Nhận Biết Flaky Test

### 📊 Thống Kê Bất Thường
- ▶️ Chạy **10 lần**: Pass 7, Fail 3
- 🔄 **"Rerun test"** lại pass
- 🎲 Fail **không theo pattern** nào cả

### 🔄 Hành Vi Không Ổn Định
- 🌐 **Local pass** nhưng **CI fail**
- ⏰ **Thời gian khác nhau** → kết quả khác nhau
- 🔀 **Thứ tự test** thay đổi → flaky xuất hiện

### 📈 Tác Động Đến Pipeline
- 🚦 CI/CD **lúc đỏ lúc xanh** không rõ lý do
- 👥 Team **mất thời gian** debug vấn đề không tồn tại
- 📉 **Coverage reports** không đáng tin cậy

---

## 🧠 Nguyên Nhân Phổ Biến Nhất

### ⏱️ 1. Timing / Wait Không Đủ

**Vấn đề**: Page chưa load, element chưa hiển thị, request chưa về.

#### ❌ Ví Dụ Xấu
```javascript
await page.click('#login');
await page.waitForTimeout(1000); // ⚠️ Hard-coded delay
await expect(page.locator('.success')).toBeVisible();
```

#### ✅ Cách Đúng
```javascript
await page.getByRole('button', { name: 'Login' }).click();
await expect(page.getByText('Welcome')).toBeVisible(); // 🎯 Auto-wait
```

### 📊 2. Dependency Vào Dữ Liệu Thay Đổi

**Vấn đề**: Test phụ thuộc vào dữ liệu động.

#### ❌ Ví Dụ Flaky
```javascript
// Test số lượng items - nhưng DB thay đổi liên tục
const itemCount = await page.locator('.product-item').count();
expect(itemCount).toBeGreaterThan(10); // ❌ Có thể fail nếu ít sản phẩm

// Test giá trending - thay đổi theo giờ
await expect(page.getByText('$29.99')).toBeVisible(); // ❌ Giá thay đổi
```

#### ✅ Cách Fix
```javascript
// Mock data hoặc tạo data test cố định
await page.route('/api/products', route => {
  route.fulfill({
    status: 200,
    body: JSON.stringify([
      { name: 'Test Product 1', price: 29.99 },
      { name: 'Test Product 2', price: 39.99 }
    ])
  });
});
```

### ⚡ 3. Race Condition

**Vấn đề**: Hai async actions chạy song song → hành vi khác nhau mỗi lần.

```javascript
// ❌ Race condition
await page.click('#submit-form');
await page.fill('#name', 'John'); // Chạy song song với click

// ✅ Sequential execution
await page.fill('#name', 'John');
await page.click('#submit-form');
```

### 🧹 4. Không Clean State Trước Mỗi Test

**Vấn đề**: Session, cache, database còn dữ liệu test cũ.

#### ❌ Test Flaky
```javascript
test('create user', async ({ page }) => {
  // Không clean DB - user đã tồn tại từ test trước
  await page.fill('#username', 'testuser');
  await page.click('#create');
  await expect(page.getByText('User created')).toBeVisible(); // ❌ Fail nếu user đã tồn tại
});
```

#### ✅ Cách Fix
```javascript
test.beforeEach(async ({ page }) => {
  // Clean state trước mỗi test
  await page.context().clearCookies();
  await page.evaluate(() => localStorage.clear());

  // Hoặc reset database
  await resetTestDatabase();
});
```

### 🌐 5. External Dependency

**Vấn đề**: API ngoài, third-party services không ổn định.

#### ❌ Phụ Thuộc External
```javascript
// Test gọi API payment thực
await page.click('#pay-with-stripe');
await expect(page.getByText('Payment successful')).toBeVisible();
// ❌ Stripe API chậm → timeout
// ❌ Network issues → fail
```

#### ✅ Mock External Services
```javascript
await page.route('**/api/stripe/**', route => {
  route.fulfill({
    status: 200,
    body: JSON.stringify({ success: true, transactionId: 'test_123' })
  });
});
```

---

## 🛠️ Cách Xử Lý Flaky Test

### 🎯 1. Luôn Dùng Locator Ổn Định

#### ❌ Locator Flaky
```javascript
// CSS class có thể thay đổi
await page.click('.btn.btn-primary.ml-2');

// XPath fragile
await page.click('//*[@id="login-form"]/div[2]/button');
```

#### ✅ Locator Tốt
```javascript
// Role-based (khuyên dùng nhất)
await page.getByRole('button', { name: 'Login' }).click();

// Data-testid (ổn định nhất)
await page.getByTestId('submit-button').click();

// Accessible name
await page.getByLabel('Email address').fill('test@example.com');
```

### ⏳ 2. Đợi Đúng Điều Kiện (Auto-Wait)

**Playwright đã có sẵn - không cần waitForTimeout()**

```javascript
// ✅ Auto-wait thông minh
await expect(page.getByText('Loading...')).toBeVisible();
await expect(page.getByText('Success')).toBeVisible({ timeout: 10000 });

// ❌ Không dùng hard-coded delay
await page.waitForTimeout(3000); // ⚠️ Anti-pattern
```

### 🔄 3. Dùng Retry & Timeout Hợp Lý

```javascript
test('robust test', async ({ page }) => {
  // Timeout phù hợp với use case
  await expect(page.getByText('Data loaded'))
    .toBeVisible({ timeout: 15000 });

  // Retry cho actions không ổn định
  await expect(async () => {
    await page.reload();
    await expect(page.getByText('Content ready')).toBeVisible();
  }).toPass({ timeout: 10000 });
});
```

### 🎭 4. Mock API Khi Không Cần Thật

```javascript
// Mock API responses
await page.route('/api/user/profile', route => {
  route.fulfill({
    status: 200,
    body: JSON.stringify({
      name: 'Test User',
      email: 'test@example.com',
      avatar: 'https://example.com/avatar.jpg'
    })
  });
});

// Mock network delays
await page.route('/api/slow-endpoint', async route => {
  await new Promise(resolve => setTimeout(resolve, 100)); // Simulate delay
  route.fulfill({ status: 200, body: 'Slow response' });
});
```

### 🧽 5. Reset State Mỗi Test

```javascript
// playwright.config.ts
export default defineConfig({
  use: {
    // Fresh browser context mỗi test
    // Không dùng storageState nếu không cần thiết
  },

  // Clean database
  globalSetup: './global-setup.ts',
  globalTeardown: './global-teardown.ts'
});

// Test-level cleanup
test.afterEach(async ({ page }) => {
  // Clear local storage, cookies
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });
  await page.context().clearCookies();
});
```

---

## 🧪 Debug Flaky Test Trong CI

### 🔍 Quy Trình Debug

#### 1️⃣ Xác Nhận Flaky
```bash
# Chạy test 10 lần để xác nhận flaky
for i in {1..10}; do
  echo "Run $i:"
  npx playwright test --project=chromium flaky-test.spec.ts
done
```

#### 2️⃣ Bật Trace & Video
```javascript
// playwright.config.ts
export default defineConfig({
  use: {
    // Record trace khi fail
    trace: 'on-first-retry',
    // Record video
    video: 'retain-on-failure',
    // Screenshot khi fail
    screenshot: 'only-on-failure'
  }
});
```

#### 3️⃣ Phân Tích Logs
```bash
# Xem console logs
npx playwright show-report

# Download trace files từ CI
# Analyze với Playwright Trace Viewer
npx playwright show-trace trace.zip
```

### 🐌 Debug Techniques

#### Slow Motion Mode
```bash
# Chạy chậm để observe
npx playwright test --headed --slowMo=500

# Debug mode với inspector
npx playwright test --debug failing-test.spec.ts
```

#### Network Monitoring
```javascript
// Log network requests
page.on('request', request => {
  console.log('Request:', request.url());
});

page.on('response', response => {
  console.log('Response:', response.status(), response.url());
});
```

#### Environment Comparison
```javascript
// So sánh local vs CI
console.log('User Agent:', await page.evaluate(() => navigator.userAgent));
console.log('Viewport:', page.viewportSize());
console.log('Timezone:', await page.evaluate(() => Intl.DateTimeFormat().resolvedOptions().timeZone));
```

---

## 📋 Checklist Xử Lý Flaky Test

### ✅ Trước Khi Viết Test
- [ ] Xác định **test boundaries** rõ ràng
- [ ] **Mock external dependencies**
- [ ] Chọn **locators ổn định**
- [ ] Setup **proper cleanup**

### ✅ Trong Quá Trình Viết
- [ ] **Không dùng** `waitForTimeout()`
- [ ] **Luôn dùng** auto-wait của Playwright
- [ ] **Test data** độc lập, không conflict
- [ ] **Handle async** đúng cách

### ✅ Khi Test Fail
- [ ] **Chạy lại** 5-10 lần để xác nhận flaky
- [ ] **Bật trace** và analyze
- [ ] **Kiểm tra logs** network/console
- [ ] **So sánh** local vs CI environment

### ✅ Refactor Flaky Test
- [ ] **Tăng timeout** hợp lý (không quá 30s)
- [ ] **Retry logic** cho actions không ổn định
- [ ] **Isolate test data** hoàn toàn
- [ ] **Mock slow APIs** hoặc unreliable services

---

## 🎯 Best Practices Tránh Flaky Test

### 🏗️ Test Design
1. **Test một responsibility** - Mỗi test chỉ kiểm tra một điều
2. **Independent tests** - Không phụ thuộc lẫn nhau
3. **Predictable data** - Dùng seed data hoặc factories
4. **Minimal UI interactions** - Ưu tiên API calls khi có thể

### 🔧 Tool Configuration
```javascript
// playwright.config.ts - Anti-flaky setup
export default defineConfig({
  use: {
    // Reasonable timeouts
    actionTimeout: 10000,
    navigationTimeout: 30000,

    // Retry failed tests
    retries: process.env.CI ? 2 : 0,

    // Capture evidence
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },

  // Parallel execution (nhưng không quá nhiều)
  workers: process.env.CI ? 2 : undefined
});
```

### 📊 Monitoring & Metrics
- **Track flaky rate**: `< 5% là acceptable`
- **Alert** khi test fail rate tăng
- **Regular cleanup**: Remove hoặc fix flaky tests
- **Documentation**: Ghi lý do và cách fix

---

## 🚀 Kết Luận

**Flaky Test là kẻ thù số 1** của automated testing. Chúng:

- 📉 **Giảm niềm tin** vào test suite
- ⏰ **Tốn thời gian** debug không cần thiết
- 💰 **Tăng chi phí** maintenance
- 😫 **Làm team stress** và mất động lực

### 💡 Chiến Lược Phòng Ngừa

1. **Thiết kế tests** với mindset "stable first"
2. **Mock everything** không cần thiết
3. **Use reliable locators** và auto-wait
4. **Monitor regularly** và fix ngay khi phát hiện
5. **Accept reality**: 100% stable tests là không thể - aim for `< 5%` flaky rate

### 🎖️ Mindset QA
> "Flaky test không phải là lỗi của tool, mà là lỗi của cách chúng ta viết test"

**Hãy viết tests như thể chúng sẽ chạy 1000 lần mà không fail một lần nào!** 🚀
