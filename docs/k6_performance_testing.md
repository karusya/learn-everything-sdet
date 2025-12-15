# 📊 **Lộ trình học k6 chi tiết (4 tuần)**

## Tuần 1: Kiến thức nền tảng & Script cơ bản

### Ngày 1-2: Tổng quan về Load Testing với k6

```javascript
 1. Hiểu vì sao cần load testing
 - Đo lường hiệu năng hệ thống
 - Tìm điểm tắc nghẽn (bottleneck)
 - Kiểm tra khả năng mở rộng (scalability)
 - Đảm bảo SLA (Service Level Agreement)

 2. Cài đặt k6
 -  macOS: brew install k6
 -  Windows: choco install k6
 -  Linux: sudo apt-get install k6

 3. Cấu trúc script k6 cơ bản
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10, // Virtual Users
  duration: '30s',
};

export default function () {
  const res = http.get('https://test-api.k6.io/public/crocodiles/');
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  sleep(1);
}
```
### Ngày 3-4: Các hàm và options cơ bản
```javascript
// script-basic.js
import http from 'k6/http';
import { check, group, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const responseTime = new Trend('response_time');

export const options = {
  // Stages - Tăng dần lượng users
  stages: [
    { duration: '30s', target: 20 },  // Ramp-up: 0 → 20 VUs
    { duration: '1m', target: 20 },   // Giữ ổn định
    { duration: '30s', target: 0 },   // Ramp-down: 20 → 0 VUs
  ],
  
  // Thresholds - Ngưỡng chấp nhận được
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% request < 500ms
    errors: ['rate<0.1'],            // Lỗi < 10%
  },
};

export default function () {
  // Group requests
  group('API Public Endpoints', function () {
    // GET request
    const res1 = http.get('https://test-api.k6.io/public/crocodiles/');
    
    // Check response
    const checkResult = check(res1, {
      'status is 200': (r) => r.status === 200,
      'has data': (r) => r.json().length > 0,
    });
    
    // Track error rate
    errorRate.add(!checkResult);
    
    // Track response time
    responseTime.add(res1.timings.duration);
  });
  
  sleep(Math.random() * 2); // Random sleep 0-2s
}
```
### Ngày 5-7: Thực hành với API thực tế
```javascript
// script-api-test.js
import http from 'k6/http';
import { check, group } from 'k6';

const BASE_URL = 'https://jsonplaceholder.typicode.com';

export const options = {
  scenarios: {
    // Scenario 1: Kiểm tra load bình thường
    normal_load: {
      executor: 'constant-vus',
      vus: 10,
      duration: '1m',
      gracefulStop: '10s',
    },
    // Scenario 2: Stress test
    spike_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '10s', target: 50 },
        { duration: '30s', target: 50 },
        { duration: '10s', target: 0 },
      ],
    },
  },
  thresholds: {
    'http_req_duration{scenario:normal_load}': ['p(95)<1000'],
    'http_req_duration{scenario:spike_test}': ['p(95)<2000'],
  },
};

export default function () {
  group('JSONPlaceholder API Tests', function () {
    // Test 1: Get all posts
    const postsResponse = http.get(`${BASE_URL}/posts`);
    check(postsResponse, {
      'GET /posts status 200': (r) => r.status === 200,
      'GET /posts has data': (r) => r.json().length > 0,
    });
    
    // Test 2: Get single post (dynamic ID)
    const postId = Math.floor(Math.random() * 100) + 1;
    const singlePostResponse = http.get(`${BASE_URL}/posts/${postId}`);
    check(singlePostResponse, {
      'GET single post status 200': (r) => r.status === 200,
      'Post has valid structure': (r) => {
        const data = r.json();
        return data.id && data.title && data.body;
      },
    });
    
    // Test 3: Create new post
    const payload = JSON.stringify({
      title: 'k6 Test',
      body: 'This is a test from k6',
      userId: 1,
    });
    
    const params = {
      headers: {
        'Content-Type': 'application/json',
      },
    };
    
    const createResponse = http.post(
      `${BASE_URL}/posts`,
      payload,
      params
    );
    
    check(createResponse, {
      'POST status 201': (r) => r.status === 201,
      'Response has ID': (r) => r.json().id !== undefined,
    });
  });
}
```
## Tuần 2: Nâng cao & Thực hành
### Ngày 8-9: Data-driven testing với CSV/JSON
```javascript
// script-data-driven.js
import http from 'k6/http';
import { check } from 'k6';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";

// Đọc dữ liệu từ CSV
const usersData = new SharedArray('users', function () {
  return papaparse.parse(open('./data/users.csv'), { header: true }).data;
});

// Đọc dữ liệu từ JSON
const testData = JSON.parse(open('./data/test-data.json'));

export const options = {
  vus: 5,
  duration: '1m',
};

export default function () {
  // Lấy ngẫu nhiên 1 user từ CSV
  const randomUser = usersData[Math.floor(Math.random() * usersData.length)];
  
  // Test login với data từ CSV
  const loginPayload = JSON.stringify({
    username: randomUser.username,
    password: randomUser.password,
  });
  
  const loginResponse = http.post(
    'https://test-api.k6.io/auth/token/login/',
    loginPayload,
    { headers: { 'Content-Type': 'application/json' } }
  );
  
  check(loginResponse, {
    'login successful': (r) => r.status === 200,
  });
  
  // Extract token nếu login thành công
  if (loginResponse.status === 200) {
    const token = loginResponse.json().access;
    
    // Gọi API protected với token
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
    };
    
    // Test với data từ JSON
    testData.posts.forEach(post => {
      const postResponse = http.post(
        'https://test-api.k6.io/my/crocodiles/',
        JSON.stringify(post),
        { headers }
      );
      
      check(postResponse, {
        'post created': (r) => r.status === 201,
      });
    });
  }
}

// Generate HTML report
export function handleSummary(data) {
  return {
    "summary.html": htmlReport(data),
  };
}
```
### Ngày 10-11: Authentication & Sessions
```javascript
// script-authentication.js
import http from 'k6/http';
import { check, fail } from 'k6';
import { browser } from 'k6/browser';

export const options = {
  scenarios: {
    // API testing
    api: {
      executor: 'shared-iterations',
      vus: 5,
      iterations: 20,
    },
    // Browser testing (nếu cần test frontend)
    browser: {
      executor: 'per-vu-iterations',
      vus: 2,
      iterations: 5,
      options: {
        browser: {
          type: 'chromium',
        },
      },
    },
  },
};

// Helper function để xử lý session
function handleAuth() {
  // Step 1: Get authentication token
  const loginRes = http.post(
    'https://test-api.k6.io/auth/token/login/',
    JSON.stringify({
      username: 'test_user',
      password: 'superCroc2019',
    }),
    { headers: { 'Content-Type': 'application/json' } }
  );
  
  if (!check(loginRes, { 'login succeeded': (r) => r.status === 200 })) {
    fail('Authentication failed');
  }
  
  const authToken = loginRes.json().access;
  
  // Step 2: Use token in subsequent requests
  return {
    headers: {
      'Authorization': `Bearer ${authToken}`,
      'Content-Type': 'application/json',
    },
  };
}

// API test với authentication
export default function () {
  const authHeaders = handleAuth();
  
  // Get user profile
  const profileRes = http.get(
    'https://test-api.k6.io/my/profile/',
    authHeaders
  );
  
  check(profileRes, {
    'profile retrieved': (r) => r.status === 200,
  });
  
  // Create resource
  const createRes = http.post(
    'https://test-api.k6.io/my/crocodiles/',
    JSON.stringify({
      name: `Croc_${__VU}_${__ITER}`,
      sex: 'M',
      date_of_birth: '2001-01-01',
    }),
    authHeaders
  );
  
  check(createRes, {
    'resource created': (r) => r.status === 201,
  });
}

// Browser testing (cho frontend)
export function browserTest() {
  const page = browser.newPage();
  
  try {
    page.goto('https://test.k6.io/');
    
    // Take screenshot
    page.screenshot({ path: `screenshot_${__VU}.png` });
    
    // Fill login form
    page.locator('input[name="login"]').type('admin');
    page.locator('input[name="password"]').type('123');
    page.locator('button[type="submit"]').click();
    
    // Wait for navigation
    page.waitForNavigation();
    
    // Verify login success
    check(page, {
      'login success': () => page.url().includes('welcome'),
    });
  } finally {
    page.close();
  }
}
```
### Ngày 12-14: Performance Dashboard & CI/CD
```yaml
# .github/workflows/k6-tests.yml
name: k6 Load Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # Chạy hàng ngày 2AM

jobs:
  load-test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup k6
      uses: grafana/setup-k6-action@v1
    
    - name: Run k6 tests
      run: |
        k6 run \
          --out json=results.json \
          --summary-export=summary.json \
          scripts/api-test.js
    
    - name: Upload results
      uses: actions/upload-artifact@v3
      with:
        name: k6-results
        path: results.json
    
    - name: Generate HTML Report
      run: |
        npm install -g k6-summary
        k6-summary summary.json --output report.html
    
    - name: Deploy to GitHub Pages
      uses: JamesIves/github-pages-deploy-action@v4
      with:
        folder: reports
```
## Tuần 3: Real-world Scenarios
### Ngày 15-16: E-commerce Load Test
```javascript
// script-ecommerce.js
import http from 'k6/http';
import { check, group, sleep } from 'k6';
import { Trend, Rate, Counter } from 'k6/metrics';

// Custom metrics
const addToCartTime = new Trend('add_to_cart_time');
const checkoutTime = new Trend('checkout_time');
const conversionRate = new Rate('conversion_rate');
const totalOrders = new Counter('total_orders');

const BASE_URL = 'https://demo-api.k6.io';

export const options = {
  scenarios: {
    browse_products: {
      executor: 'constant-vus',
      vus: 20,
      duration: '5m',
      exec: 'browseProducts',
    },
    add_to_cart: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '2m', target: 10 },
        { duration: '3m', target: 10 },
        { duration: '1m', target: 0 },
      ],
      exec: 'addToCart',
    },
    checkout: {
      executor: 'constant-arrival-rate',
      rate: 2, // 2 requests per second
      timeUnit: '1s',
      duration: '3m',
      preAllocatedVUs: 5,
      exec: 'checkout',
    },
  },
  thresholds: {
    'http_req_duration{scenario:browse_products}': ['p(95)<1000'],
    'http_req_duration{scenario:checkout}': ['p(95)<2000'],
    'conversion_rate': ['rate>0.3'], // 30% conversion rate
  },
};

// Scenario 1: Browse products
export function browseProducts() {
  group('Browse Catalog', () => {
    // View homepage
    const homeRes = http.get(`${BASE_URL}/`);
    check(homeRes, { 'homepage loaded': (r) => r.status === 200 });
    
    // Browse categories
    const categoriesRes = http.get(`${BASE_URL}/categories`);
    check(categoriesRes, {
      'categories loaded': (r) => r.status === 200,
      'has categories': (r) => r.json().length > 0,
    });
    
    // View products in category
    const categoryId = Math.floor(Math.random() * 5) + 1;
    const productsRes = http.get(
      `${BASE_URL}/categories/${categoryId}/products`
    );
    check(productsRes, {
      'products loaded': (r) => r.status === 200,
    });
    
    // View product detail
    if (productsRes.json().length > 0) {
      const product = productsRes.json()[0];
      const productDetailRes = http.get(
        `${BASE_URL}/products/${product.id}`
      );
      check(productDetailRes, {
        'product detail loaded': (r) => r.status === 200,
      });
    }
  });
  
  sleep(Math.random() * 3 + 1);
}

// Scenario 2: Add to cart
export function addToCart() {
  group('Shopping Cart', () => {
    // Login
    const loginRes = http.post(`${BASE_URL}/auth/login`, JSON.stringify({
      username: `user_${__VU}`,
      password: 'password123',
    }));
    
    const authToken = loginRes.json().token;
    const headers = {
      'Authorization': `Bearer ${authToken}`,
      'Content-Type': 'application/json',
    };
    
    // Add item to cart
    const startTime = Date.now();
    const addRes = http.post(
      `${BASE_URL}/cart/items`,
      JSON.stringify({
        productId: Math.floor(Math.random() * 100) + 1,
        quantity: Math.floor(Math.random() * 3) + 1,
      }),
      { headers }
    );
    
    const duration = Date.now() - startTime;
    addToCartTime.add(duration);
    
    check(addRes, {
      'item added to cart': (r) => r.status === 201,
    });
  });
  
  sleep(Math.random() * 2);
}

// Scenario 3: Checkout process
export function checkout() {
  group('Checkout Process', () => {
    const startTime = Date.now();
    
    // 1. Get cart
    const cartRes = http.get(`${BASE_URL}/cart`);
    check(cartRes, { 'cart retrieved': (r) => r.status === 200 });
    
    // 2. Create order
    const orderRes = http.post(
      `${BASE_URL}/orders`,
      JSON.stringify({
        cartId: cartRes.json().id,
        shippingAddress: {
          street: '123 Test St',
          city: 'Test City',
          zipCode: '12345',
        },
      })
    );
    
    // 3. Process payment
    if (orderRes.status === 201) {
      const paymentRes = http.post(
        `${BASE_URL}/payments`,
        JSON.stringify({
          orderId: orderRes.json().id,
          paymentMethod: 'credit_card',
          cardNumber: '4111111111111111',
        })
      );
      
      const duration = Date.now() - startTime;
      checkoutTime.add(duration);
      
      if (paymentRes.status === 200) {
        conversionRate.add(1);
        totalOrders.add(1);
      }
      
      check(paymentRes, {
        'payment successful': (r) => r.status === 200,
      });
    }
  });
  
  sleep(1);
}
```
### Ngày 17-18: WebSocket & GraphQL Testing
```javascript
// script-websocket-graphql.js
import ws from 'k6/ws';
import http from 'k6/http';
import { check } from 'k6';

// WebSocket Test
export function websocketTest() {
  const url = 'wss://echo.websocket.org';
  
  ws.connect(url, {}, function (socket) {
    socket.on('open', function open() {
      console.log('WebSocket connected');
      
      // Send message
      socket.send('Hello from k6');
      
      // Send multiple messages
      for (let i = 0; i < 5; i++) {
        socket.send(`Message ${i}`);
      }
    });
    
    socket.on('message', function (message) {
      console.log(`Received: ${message}`);
      
      check(message, {
        'message is correct': (msg) => msg.includes('Message'),
      });
    });
    
    socket.on('close', function () {
      console.log('WebSocket disconnected');
    });
    
    socket.setTimeout(function () {
      console.log('Closing socket after 10 seconds');
      socket.close();
    }, 10000);
  });
}

// GraphQL Test
export function graphqlTest() {
  const url = 'https://graphqlzero.almansi.me/api';
  
  // GraphQL query
  const query = `
    query ($id: ID!) {
      user(id: $id) {
        id
        name
        username
        email
        address {
          street
          city
        }
      }
    }
  `;
  
  const variables = {
    id: 1,
  };
  
  const headers = {
    'Content-Type': 'application/json',
  };
  
  const payload = JSON.stringify({
    query,
    variables,
  });
  
  const res = http.post(url, payload, { headers });
  
  check(res, {
    'GraphQL response status 200': (r) => r.status === 200,
    'has user data': (r) => {
      const data = r.json();
      return data.data && data.data.user;
    },
    'user has correct id': (r) => r.json().data.user.id === 1,
  });
}

export const options = {
  vus: 5,
  duration: '1m',
};

export default function () {
  // Run both tests
  websocketTest();
  graphqlTest();
}
```
## Tuần 4: Optimization & Production
### Ngày 19-20: Monitoring & Alerting
```javascript
// script-monitoring.js
import http from 'k6/http';
import { check, group } from 'k6';
import { Counter, Rate, Trend } from 'k6/metrics';
import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';

// Custom metrics cho monitoring
const successCounter = new Counter('successful_requests');
const errorCounter = new Counter('failed_requests');
const errorRate = new Rate('error_rate');
const percentile95 = new Trend('percentile_95');
const percentile99 = new Trend('percentile_99');

export const options = {
  scenarios: {
    smoke: {
      executor: 'constant-vus',
      vus: 1,
      duration: '1m',
      tags: { test_type: 'smoke' },
    },
    load: {
      executor: 'ramping-vus',
      stages: [
        { duration: '2m', target: 50 },
        { duration: '5m', target: 50 },
        { duration: '2m', target: 0 },
      ],
      tags: { test_type: 'load' },
    },
  },
  
  thresholds: {
    // Global thresholds
    'http_req_duration': ['p(95)<500', 'p(99)<1000'],
    'http_req_failed': ['rate<0.01'],
    
    // Tag-based thresholds
    'http_req_duration{test_type:smoke}': ['max<1000'],
    'http_req_duration{test_type:load}': ['p(95)<800'],
    
    // Custom metric thresholds
    'error_rate': ['rate<0.05'],
  },
  
  // Output to multiple destinations
  ext: {
    loadimpact: {
      projectID: 123456,
      name: 'Production Load Test',
    },
  },
};

// Helper function để ghi log
function logRequest(method, url, status, duration) {
  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      vu: __VU,
      iter: __ITER,
      method,
      url,
      status,
      duration,
    })
  );
}

export default function () {
  group('Health Checks', () => {
    // Health check endpoint
    const healthRes = http.get('https://test-api.k6.io/health');
    
    const healthCheck = check(healthRes, {
      'health check passed': (r) => r.status === 200,
    });
    
    if (healthCheck) {
      successCounter.add(1);
    } else {
      errorCounter.add(1);
      errorRate.add(1);
    }
    
    logRequest(
      'GET',
      'https://test-api.k6.io/health',
      healthRes.status,
      healthRes.timings.duration
    );
  });
  
  group('API Performance', () => {
    const start = new Date();
    const res = http.batch([
      ['GET', 'https://test-api.k6.io/public/crocodiles/'],
      ['GET', 'https://test-api.k6.io/public/crocodiles/1/'],
    ]);
    
    const duration = new Date() - start;
    
    // Track percentiles
    percentile95.add(duration);
    percentile99.add(duration);
    
    check(res[0], {
      'batch request 1 OK': (r) => r.status === 200,
    });
    
    check(res[1], {
      'batch request 2 OK': (r) => r.status === 200,
    });
  });
}

// Custom summary handler
export function handleSummary(data) {
  // In ra console
  console.log(textSummary(data));
  
  // Lưu ra file JSON
  const resultFile = `results/${Date.now()}_results.json`;
  
  return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    [resultFile]: JSON.stringify(data),
  };
}
```
### Ngày 21-22: Distributed Testing với k6 Cloud
```javascript
// script-distributed.js
import http from 'k6/http';
import { check } from 'k6';
import exec from 'k6/execution';

// Distributed test configuration
export const options = {
  // Khi chạy local
  // vus: 10,
  // duration: '30s',
  
  // Khi chạy với k6 cloud
  cloud: {
    // distribution: {
    //   'loadZone1': { loadZone: 'amazon:us:ashburn', percent: 50 },
    //   'loadZone2': { loadZone: 'amazon:eu:frankfurt', percent: 50 },
    // },
    projectID: 12345,
    name: 'Global Load Test',
  },
  
  // Multiple executors cho complex scenarios
  scenarios: {
    europe_users: {
      executor: 'constant-vus',
      vus: 50,
      duration: '5m',
      tags: { region: 'europe' },
      env: { BASE_URL: 'https://eu-api.example.com' },
    },
    us_users: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '2m', target: 100 },
        { duration: '3m', target: 100 },
        { duration: '1m', target: 0 },
      ],
      tags: { region: 'us' },
      env: { BASE_URL: 'https://us-api.example.com' },
    },
  },
  
  // Advanced thresholds
  thresholds: {
    // Global
    'http_req_duration': ['p(95)<1000'],
    
    // Per region
    'http_req_duration{region:us}': ['p(95)<800'],
    'http_req_duration{region:europe}': ['p(95)<1200'],
    
    // Per scenario
    'http_reqs{scenario:europe_users}': ['count>10000'],
    'http_reqs{scenario:us_users}': ['count>20000'],
  },
};

// Lấy environment variable
const BASE_URL = __ENV.BASE_URL || 'https://test-api.k6.io';

export default function () {
  // Thêm tag cho request
  const tags = {
    vu_id: __VU,
    iter: __ITER,
    region: exec.scenario.tags.region || 'unknown',
  };
  
  const res = http.get(
    `${BASE_URL}/public/crocodiles/`,
    { tags }
  );
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time acceptable': (r) => r.timings.duration < 2000,
  }, tags);
  
  // Logic khác nhau theo region
  if (tags.region === 'europe') {
    // European specific logic
    http.get(`${BASE_URL}/eu-specific-endpoint/`, { tags });
  } else if (tags.region === 'us') {
    // US specific logic
    http.get(`${BASE_URL}/us-specific-endpoint/`, { tags });
  }
}
```
### Ngày 23-24: Best Practices & Optimization
```javascript
// best-practices.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// ========== BEST PRACTICES ==========

// 1. Sử dụng environment variables
const API_URL = __ENV.API_URL || 'https://test-api.k6.io';
const VUS = parseInt(__ENV.VUS) || 10;

// 2. Shared data để giảm memory usage
import { SharedArray } from 'k6/data';
const testData = new SharedArray('test data', function () {
  return JSON.parse(open('./data/large-data.json'));
});

// 3. Custom metrics cho business logic
const businessErrorRate = new Rate('business_errors');

// 4. Tags cho filtering
const tags = {
  service: 'api-gateway',
  environment: __ENV.ENV || 'staging',
  test_id: __ENV.TEST_ID || 'default',
};

export const options = {
  // 5. Đúng executor cho use case
  scenarios: {
    // Dùng cho API testing
    api_load: {
      executor: 'constant-vus',
      vus: VUS,
      duration: '5m',
      tags: { ...tags, test_type: 'api' },
    },
    // Dùng cho spike testing
    spike: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '30s', target: 100 },
        { duration: '1m', target: 100 },
        { duration: '30s', target: 0 },
      ],
      tags: { ...tags, test_type: 'spike' },
    },
  },
  
  // 6. Realistic thresholds
  thresholds: {
    // Loại bỏ các threshold không cần thiết
    'http_req_duration{test_type:api}': ['p(95)<500'],
    'http_req_duration{test_type:spike}': ['p(95)<1000'],
    'business_errors': ['rate<0.01'],
  },
  
  // 7. System resource limits
  // systemTags: ['status', 'method', 'url', 'name'],
  discardResponseBodies: true, // Giảm memory khi không cần response body
};

// 8. Modular test functions
function login() {
  const res = http.post(`${API_URL}/auth/login`, JSON.stringify({
    username: `test_${__VU}`,
    password: 'password',
  }));
  
  check(res, {
    'login success': (r) => r.status === 200,
  });
  
  return res.json().token;
}

function getUserProfile(token) {
  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  };
  
  const res = http.get(`${API_URL}/user/profile`, { headers });
  
  // Business logic validation
  const isBusinessError = res.json().status === 'error';
  businessErrorRate.add(isBusinessError);
  
  return res;
}

function performAction(token, action) {
  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  };
  
  const payload = testData[Math.floor(Math.random() * testData.length)];
  
  const res = http.post(
    `${API_URL}/actions/${action}`,
    JSON.stringify(payload),
    { headers }
  );
  
  // Validate business rules
  check(res, {
    [`${action} successful`]: (r) => r.status === 200,
    'valid response format': (r) => {
      try {
        const data = r.json();
        return data.id && data.timestamp;
      } catch (e) {
        return false;
      }
    },
  });
  
  return res;
}

// 9. Main execution flow
export default function () {
  // Phase 1: Authentication
  const token = login();
  if (!token) {
    return; // Skip nếu login fail
  }
  
  sleep(0.5);
  
  // Phase 2: User actions
  const profile = getUserProfile(token);
  if (profile.status !== 200) {
    return;
  }
  
  sleep(Math.random() * 1);
  
  // Phase 3: Business actions
  const actions = ['create', 'update', 'delete'];
  const randomAction = actions[Math.floor(Math.random() * actions.length)];
  performAction(token, randomAction);
  
  // 10. Think time thực tế
  sleep(Math.random() * 2 + 1);
}
```
### Ngày 25-28: Project tổng hợp
```javascript
// project-complete.js
/**
 * COMPLETE E-COMMERCE LOAD TEST SUITE
 * Kết hợp tất cả kiến thức đã học
 */

import http from 'k6/http';
import { check, group, sleep, fail } from 'k6';
import { Trend, Rate, Counter, Gauge } from 'k6/metrics';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";
import exec from 'k6/execution';

// ========== CUSTOM METRICS ==========
const productBrowseTime = new Trend('product_browse_time');
const cartOperationTime = new Trend('cart_operation_time');
const checkoutTime = new Trend('checkout_time');
const conversionRate = new Rate('conversion_rate');
const activeUsers = new Gauge('active_users');
const totalRevenue = new Counter('total_revenue');

// ========== CONFIGURATION ==========
const BASE_URL = __ENV.BASE_URL || 'https://demo-store.k6.io';
const TEST_DURATION = __ENV.TEST_DURATION || '10m';
const TARGET_VUS = parseInt(__ENV.TARGET_VUS) || 50;

export const options = {
  scenarios: {
    // 1. Browsing behavior (70% users)
    browsing: {
      executor: 'constant-vus',
      vus: Math.floor(TARGET_VUS * 0.7),
      duration: TEST_DURATION,
      exec: 'browseScenario',
      tags: { user_type: 'browser' },
    },
    
    // 2. Buying behavior (20% users)
    buying: {
      executor: 'ramping-vus',
      startVUs: Math.floor(TARGET_VUS * 0.2),
      stages: [
        { duration: '2m', target: Math.floor(TARGET_VUS * 0.2) },
        { duration: '6m', target: Math.floor(TARGET_VUS * 0.2) },
        { duration: '2m', target: 0 },
      ],
      exec: 'buyScenario',
      tags: { user_type: 'buyer' },
    },
    
    // 3. Search behavior (10% users)
    searching: {
      executor: 'per-vu-iterations',
      vus: Math.floor(TARGET_VUS * 0.1),
      iterations: 20,
      exec: 'searchScenario',
      tags: { user_type: 'searcher' },
    },
  },
  
  thresholds: {
    // Performance thresholds
    'http_req_duration{user_type:browser}': ['p(95)<1000'],
    'http_req_duration{user_type:buyer}': ['p(95)<2000'],
    'http_req_duration{user_type:searcher}': ['p(95)<1500'],
    
    // Business thresholds
    'conversion_rate': ['rate>0.2'], // 20% conversion rate
    'product_browse_time': ['p(95)<800'],
    'checkout_time': ['p(95)<3000'],
    
    // Error thresholds
    'http_req_failed': ['rate<0.01'],
  },
  
  // Tags for filtering
  tags: {
    project: 'ecommerce-load-test',
    environment: __ENV.ENV || 'staging',
    version: '1.0.0',
  },
};

// ========== DATA ==========
const products = [
  { id: 1, name: 'Laptop', price: 999.99 },
  { id: 2, name: 'Phone', price: 699.99 },
  { id: 3, name: 'Tablet', price: 499.99 },
  { id: 4, name: 'Headphones', price: 199.99 },
  { id: 5, name: 'Smartwatch', price: 299.99 },
];

const users = new Array(100).fill(0).map((_, i) => ({
  username: `user${i + 1}`,
  email: `user${i + 1}@test.com`,
  password: 'Test123!',
}));

// ========== HELPER FUNCTIONS ==========
function getRandomUser() {
  return users[Math.floor(Math.random() * users.length)];
}

function getRandomProduct() {
  return products[Math.floor(Math.random() * products.length)];
}

function simulateThinkTime(min, max) {
  sleep(Math.random() * (max - min) + min);
}

// ========== AUTH MODULE ==========
function login(user) {
  const start = Date.now();
  
  const res = http.post(`${BASE_URL}/api/auth/login`, JSON.stringify({
    username: user.username,
    password: user.password,
  }), {
    headers: { 'Content-Type': 'application/json' },
    tags: { action: 'login' },
  });
  
  const duration = Date.now() - start;
  
  check(res, {
    'login successful': (r) => r.status === 200,
    'received auth token': (r) => r.json().token !== undefined,
  });
  
  if (res.status !== 200) {
    fail('Login failed');
  }
  
  return {
    token: res.json().token,
    duration,
  };
}

// ========== SCENARIOS ==========
export function browseScenario() {
  activeUsers.add(1);
  
  group('Browse Products', () => {
    // Homepage
    const homeRes = http.get(`${BASE_URL}/`, {
      tags: { page: 'home' },
    });
    check(homeRes, { 'homepage loaded': (r) => r.status === 200 });
    
    simulateThinkTime(2, 5);
    
    // Browse categories
    const categories = ['electronics', 'clothing', 'books'];
    const category = categories[Math.floor(Math.random() * categories.length)];
    
    const start = Date.now();
    const categoryRes = http.get(`${BASE_URL}/api/categories/${category}/products`, {
      tags: { page: 'category', category },
    });
    productBrowseTime.add(Date.now() - start);
    
    check(categoryRes, {
      'category products loaded': (r) => r.status === 200,
    });
    
    simulateThinkTime(1, 3);
    
    // View product detail
    if (categoryRes.json().length > 0) {
      const product = categoryRes.json()[0];
      http.get(`${BASE_URL}/api/products/${product.id}`, {
        tags: { page: 'product_detail', product_id: product.id },
      });
    }
  });
  
  activeUsers.add(-1);
}

export function buyScenario() {
  const user = getRandomUser();
  
  group('Complete Purchase Flow', () => {
    // 1. Login
    const auth = login(user);
    
    simulateThinkTime(1, 2);
    
    // 2. Browse and add to cart
    const product = getRandomProduct();
    
    const cartStart = Date.now();
    const cartRes = http.post(
      `${BASE_URL}/api/cart/items`,
      JSON.stringify({
        productId: product.id,
        quantity: Math.floor(Math.random() * 3) + 1,
      }),
      {
        headers: {
          'Authorization': `Bearer ${auth.token}`,
          'Content-Type': 'application/json',
        },
        tags: { action: 'add_to_cart' },
      }
    );
    cartOperationTime.add(Date.now() - cartStart);
    
    check(cartRes, {
      'item added to cart': (r) => r.status === 201,
    });
    
    simulateThinkTime(2, 4);
    
    // 3. Checkout (30% of buyers will checkout)
    if (Math.random() < 0.3) {
      group('Checkout Process', () => {
        const checkoutStart = Date.now();
        
        // Create order
        const orderRes = http.post(
          `${BASE_URL}/api/orders`,
          JSON.stringify({
            cartId: cartRes.json().cartId,
            shippingAddress: {
              street: '123 Test St',
              city: 'Test City',
              zipCode: '12345',
            },
          }),
          {
            headers: {
              'Authorization': `Bearer ${auth.token}`,
              'Content-Type': 'application/json',
            },
            tags: { action: 'create_order' },
          }
        );
        
        if (orderRes.status === 201) {
          // Process payment
          const paymentRes = http.post(
            `${BASE_URL}/api/payments`,
            JSON.stringify({
              orderId: orderRes.json().orderId,
              amount: product.price,
              paymentMethod: 'credit_card',
            }),
            {
              headers: {
                'Authorization': `Bearer ${auth.token}`,
                'Content-Type': 'application/json',
              },
              tags: { action: 'process_payment' },
            }
          );
          
          const checkoutDuration = Date.now() - checkoutStart;
          checkoutTime.add(checkoutDuration);
          
          if (paymentRes.status === 200) {
            conversionRate.add(1);
            totalRevenue.add(product.price);
            
            check(paymentRes, {
              'payment successful': (r) => r.status === 200,
              'order completed': (r) => r.json().status === 'completed',
            });
          }
        }
      });
    }
  });
}

export function searchScenario() {
  group('Search and Filter', () => {
    const searchTerms = ['laptop', 'phone', 'gadget', 'wireless', 'smart'];
    const term = searchTerms[Math.floor(Math.random() * searchTerms.length)];
    
    // Search
    const searchRes = http.get(
      `${BASE_URL}/api/search?q=${term}&sort=price&order=asc`,
      { tags: { action: 'search', term } }
    );
    
    check(searchRes, {
      'search successful': (r) => r.status === 200,
      'search returned results': (r) => r.json().results.length > 0,
    });
    
    simulateThinkTime(1, 3);
    
    // Apply filters
    if (searchRes.json().results.length > 0) {
      http.get(
        `${BASE_URL}/api/search?q=${term}&minPrice=100&maxPrice=500&inStock=true`,
        { tags: { action: 'filter' } }
      );
    }
  });
}

// ========== MAIN EXECUTION ==========
export default function () {
  // This won't be called because we use specific scenario executors
  console.log('Main execution - should not be called');
}

// ========== REPORTING ==========
export function handleSummary(data) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  
  // Business metrics summary
  const businessSummary = {
    'Total Revenue': `$${data.metrics.total_revenue.values.count.toFixed(2)}`,
    'Conversion Rate': `${(data.metrics.conversion_rate.values.rate * 100).toFixed(1)}%`,
    'Active Users (avg)': data.metrics.active_users.values.avg.toFixed(1),
    'Total Orders': data.metrics.total_revenue.values.count,
  };
  
  console.log('=== BUSINESS SUMMARY ===');
  Object.entries(businessSummary).forEach(([key, value]) => {
    console.log(`${key}: ${value}`);
  });
  
  return {
    // HTML Report
    [`reports/${timestamp}_report.html`]: htmlReport(data),
    
    // JSON data for analysis
    [`reports/${timestamp}_data.json`]: JSON.stringify(data),
    
    // Text summary
    'stdout': textSummary(data, {
      indent: '  ',
      enableColors: true,
    }),
  };
}
```

### 📁 Cấu trúc project hoàn chỉnh
```text
k6-project/
│
├── scripts/
│   ├── 01-basic/
│   │   ├── simple-test.js
│   │   └── basic-options.js
│   ├── 02-intermediate/
│   │   ├── data-driven.js
│   │   ├── authentication.js
│   │   └── scenarios.js
│   ├── 03-advanced/
│   │   ├── ecommerce.js
│   │   ├── websocket-graphql.js
│   │   └── distributed.js
│   └── 04-production/
│       ├── monitoring.js
│       ├── complete-project.js
│       └── best-practices.js
│
├── data/
│   ├── users.csv
│   ├── products.json
│   └── test-data.json
│
├── config/
│   ├── staging.json
│   ├── production.json
│   └── local.json
│
├── reports/
│   └── (auto-generated)
│
├── package.json
├── docker-compose.yml
├── .github/workflows/
│   └── k6-tests.yml
│
├── README.md
└── .env.example
```

### 🎯 **Mẹo học hiệu quả**

**Tuần 1-2:** Làm quen với syntax, chạy các script đơn giản

**Tuần 3:** Áp dụng vào dự án thật của bạn

**Tuần 4:** Tối ưu và đưa vào CI/CD

***Thực hành hàng ngày: Chạy ít nhất 1 test mỗi ngày***

***Document lại: Ghi chép các vấn đề gặp phải và cách giải quyết***
