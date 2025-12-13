# UI POM vs API "POM": Why Structure Gets Confusing When Combined

> Understanding why users struggle to see clear POM structure when mixing UI and API testing

---

## 🌍 ENGLISH VERSION

### 1️⃣ First: What is POM - and how does it apply to UI & API?

**📌 POM (Page Object Model) - The Essence**

POM = Separating "operation logic" from "test logic"

**For UI:**
- Page = 1 web page
- Page Object contains:
  - locators
  - actions (click, fill, submit...)

**For API:**
- No "page" exists
- Equivalent thinking:
  - Service / Client Object Model
  - Many teams still call it "API POM" for simplicity

### 2️⃣ STANDARD - CLEAR UI POM Structure

**📁 UI Layer (UI only, no API, no assertions)**
```
src/ui/
├── pages/
│   ├── BasePage.ts
│   ├── HomePage.ts
│   └── BasicFormPage.ts
│
└── components/   (optional – higher level)
    └── Header.ts
```

**🧩 BasePage.ts (UI foundation)**
```typescript
import { Page } from 'playwright';

export abstract class BasePage {
  protected page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async open(path: string) {
    await this.page.goto(path);
  }
}
```

**🧩 HomePage.ts (True POM)**
```typescript
import { BasePage } from './BasePage';

export class HomePage extends BasePage {
  private basicFormLink = this.page.getByRole('link', {
    name: 'Basic HTML Form Example'
  });

  async goToBasicForm() {
    await this.basicFormLink.click();
  }
}
```

**🧠 Golden Rule of UI POM**
- ❌ No expect/assertions
- ❌ No test logic
- ✅ Only locator + action

**🧩 BasicFormPage.ts**
```typescript
export class BasicFormPage extends BasePage {
  private usernameInput = this.page.locator('#username');
  private submitBtn = this.page.getByRole('button', { name: 'Submit' });

  async fillUsername(name: string) {
    await this.usernameInput.fill(name);
  }

  async submit() {
    await this.submitBtn.click();
  }
}
```

### 3️⃣ API "POM" – Right Thinking for Beginners

API isn't a Page, so we rename it for accuracy.

**📁 API Layer (Service / Client)**
```
src/api/
├── clients/
│   └── user.api.ts
│
├── models/
│   └── user.model.ts
│
└── helpers/
    └── apiClient.ts
```

**🧩 apiClient.ts (base for API)**
```typescript
import axios from 'axios';
import { ENV } from '../../utils/env';

export const apiClient = axios.create({
  baseURL: ENV.apiUrl,
  timeout: 5000,
});
```

**🧩 user.api.ts (API POM)**
```typescript
import { apiClient } from '../helpers/apiClient';

export class UserApi {
  async createUser(payload: any) {
    return apiClient.post('/users', payload);
  }

  async getUser(id: string) {
    return apiClient.get(`/users/${id}`);
  }
}
```

**👉 This is exactly POM for API:**
- API endpoint = locator
- Method = action

**🧩 user.model.ts (data contract)**
```typescript
export interface User {
  id?: string;
  name: string;
  email: string;
}
```

### 4️⃣ Test Layer – Where UI & API MEET

**📁 Tests**
```
src/tests/
├── ui/
│   └── basicForm.ui.spec.ts
├── api/
│   └── user.api.spec.ts
└── hybrid/
    └── user.e2e.spec.ts
```

**🧪 UI Test (UI only)**
```typescript
it('Submit form successfully', async () => {
  const home = new HomePage(page);
  const form = new BasicFormPage(page);

  await home.open('/');
  await home.goToBasicForm();

  await form.fillUsername('Van QA');
  await form.submit();
});
```

**🧪 API Test (API only)**
```typescript
it('Create user by API', async () => {
  const userApi = new UserApi();
  const res = await userApi.createUser({
    name: 'Van QA',
    email: 'qa@test.com'
  });

  expect(res.status).to.equal(201);
});
```

**🧪 Hybrid Test (API setup – UI verify)**
```typescript
it('Create user via API, verify via UI', async () => {
  const userApi = new UserApi();
  const user = await userApi.createUser({ name: 'Van QA' });

  const page = ctx.page;
  await page.goto(`/users/${user.data.id}`);

  await expect(page.getByText('Van QA')).toBeVisible();
});
```

### 5️⃣ Summary (Very Important)

**🧠 One "Brain-Clincher" Sentence:**

UI POM = Page + Locator + Action
API POM = Client + Endpoint + Method
Test = orchestration (coordination)

### 6️⃣ Why "Unclear" Structure is Completely Normal?

**👉 Because:**

- 90% tutorials mix test + page logic
- API is usually written inline
- No one clearly explains "API also has POM, just different name"

---

## 🇻🇳 PHIÊN BẢN TIẾNG VIỆT

### 1️⃣ Trước hết: POM là gì – và áp dụng cho UI & API ra sao?

**📌 POM (Page Object Model) – bản chất**

POM = tách "logic thao tác" ra khỏi "logic test"

**Với UI:**
- Page = 1 trang web
- Page Object chứa:
  - locator (định vị phần tử)
  - action (click, fill, submit...)

**Với API:**
- Không có "page"
- Tư duy tương đương:
  - Service / Client Object Model
  - Nhiều team vẫn gọi là API POM cho dễ hiểu

### 2️⃣ Cấu trúc CHUẨN – RÕ RÀNG UI POM

**📁 UI Layer (chỉ UI, không API, không assertion)**
```
src/ui/
├── pages/
│   ├── BasePage.ts
│   ├── HomePage.ts
│   └── BasicFormPage.ts
│
└── components/   (optional – level cao hơn)
    └── Header.ts
```

**🧩 BasePage.ts (nền tảng UI)**
```typescript
import { Page } from 'playwright';

export abstract class BasePage {
  protected page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async open(path: string) {
    await this.page.goto(path);
  }
}
```

**🧩 HomePage.ts (POM đúng nghĩa)**
```typescript
import { BasePage } from './BasePage';

export class HomePage extends BasePage {
  private basicFormLink = this.page.getByRole('link', {
    name: 'Basic HTML Form Example'
  });

  async goToBasicForm() {
    await this.basicFormLink.click();
  }
}
```

**🧠 Quy tắc vàng của UI POM**
- ❌ Không expect/không assertion
- ❌ Không logic test
- ✅ Chỉ locator + action

**🧩 BasicFormPage.ts**
```typescript
export class BasicFormPage extends BasePage {
  private usernameInput = this.page.locator('#username');
  private submitBtn = this.page.getByRole('button', { name: 'Submit' });

  async fillUsername(name: string) {
    await this.usernameInput.fill(name);
  }

  async submit() {
    await this.submitBtn.click();
  }
}
```

### 3️⃣ API "POM" – Tư duy ĐÚNG cho người mới học

API không phải Page, nên ta đổi tên cho đúng bản chất.

**📁 API Layer (Service / Client)**
```
src/api/
├── clients/
│   └── user.api.ts
│
├── models/
│   └── user.model.ts
│
└── helpers/
    └── apiClient.ts
```

**🧩 apiClient.ts (base cho API)**
```typescript
import axios from 'axios';
import { ENV } from '../../utils/env';

export const apiClient = axios.create({
  baseURL: ENV.apiUrl,
  timeout: 5000,
});
```

**🧩 user.api.ts (API POM)**
```typescript
import { apiClient } from '../helpers/apiClient';

export class UserApi {
  async createUser(payload: any) {
    return apiClient.post('/users', payload);
  }

  async getUser(id: string) {
    return apiClient.get(`/users/${id}`);
  }
}
```

**👉 Đây chính là POM cho API:**
- API endpoint = locator
- Method = action

**🧩 user.model.ts (data contract)**
```typescript
export interface User {
  id?: string;
  name: string;
  email: string;
}
```

### 4️⃣ Test Layer – nơi UI & API GẶP NHAU

**📁 Tests**
```
src/tests/
├── ui/
│   └── basicForm.ui.spec.ts
├── api/
│   └── user.api.spec.ts
└── hybrid/
    └── user.e2e.spec.ts
```

**🧪 UI Test (UI only)**
```typescript
it('Submit form successfully', async () => {
  const home = new HomePage(page);
  const form = new BasicFormPage(page);

  await home.open('/');
  await home.goToBasicForm();

  await form.fillUsername('Van QA');
  await form.submit();
});
```

**🧪 API Test (API only)**
```typescript
it('Create user by API', async () => {
  const userApi = new UserApi();
  const res = await userApi.createUser({
    name: 'Van QA',
    email: 'qa@test.com'
  });

  expect(res.status).to.equal(201);
});
```

**🧪 Hybrid Test (API setup – UI verify)**
```typescript
it('Create user via API, verify via UI', async () => {
  const userApi = new UserApi();
  const user = await userApi.createUser({ name: 'Van QA' });

  const page = ctx.page;
  await page.goto(`/users/${user.data.id}`);

  await expect(page.getByText('Van QA')).toBeVisible();
});
```

### 5️⃣ Tóm lại cho bạn dễ nhớ (rất quan trọng)

**🧠 Một câu "chốt não":**

UI POM = Page + Locator + Action
API POM = Client + Endpoint + Method
Test = orchestration (điều phối)

### 6️⃣ Vì sao thấy "không rõ" là hoàn toàn bình thường?

**👉 Vì:**

- 90% tutorial trộn test + page logic
- API thường bị viết inline
- Không ai nói rõ "API cũng có POM, chỉ khác tên"

---

## 🎯 KEY TAKEAWAYS / ĐIỂM CHỐT

### 🔍 **Why Structure Gets Confusing When Combined:**

1. **Different Naming Conventions**: UI calls it "Page", API calls it "Client/Service"
2. **Mixed Responsibilities**: Many tutorials put assertions in page objects
3. **Inline API Calls**: API logic often written directly in tests
4. **Lack of Clear Separation**: No dedicated folders for UI vs API layers

### ✅ **Clear Separation = Clear Understanding**

**UI POM Structure:**
- `src/ui/pages/` - Page Objects (locators + actions only)
- `src/ui/components/` - Reusable UI components
- `src/tests/ui/` - UI-only tests

**API POM Structure:**
- `src/api/clients/` - API client classes (endpoints + methods)
- `src/api/models/` - Data contracts/interfaces
- `src/tests/api/` - API-only tests

**Hybrid Tests:**
- `src/tests/hybrid/` or `src/tests/e2e/` - Tests combining UI + API

### 🚀 **Benefits of Clear Structure:**

- **Maintainability**: Easy to update UI/API changes
- **Reusability**: Page/Client objects can be reused across tests
- **Readability**: Test intent is clear, logic is separated
- **Scalability**: Easy to add new tests without duplication

---

*This comparison helps explain why POM structure becomes unclear when mixing UI and API testing approaches.* 🎯
