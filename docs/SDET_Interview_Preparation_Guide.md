# SDET - Selenium with Java + API Testing + Gen AI Interview Preparation

**Complete Free Course with Solved Questions & Quizzes**

*By: Inder P Singh*

- [Topmate Profile](https://topmate.io/kushalparikh11/)
- [LinkedIn Profile](https://www.linkedin.com/in/kushalparikh11/)
- [YouTube Channel](https://youtube.com/@QA1/) - Software and Testing Training (346 Tutorials, 82,400 Subscribers)
- [Blog](https://fourth-industrial-revolution.blogspot.com/) - Software Testing Space (1.88 Million Views)

---

## Table of Contents

1. [The Modern SDET Landscape](#chapter-1-the-modern-sdet-landscape)
2. [Java Core for Automation Mastery](#chapter-2-java-core-for-automation-mastery)
3. [Selenium 4 Fundamentals & WebDriver](#chapter-3-selenium-4-fundamentals--webdriver)
4. [Advanced Framework Design & Architecture](#chapter-4-advanced-framework-design--architecture)
5. [Orchestration: TestNG, Build Tools, and CI/CD](#chapter-5-orchestration-testng-build-tools-and-cicd)
6. [API Testing Concepts and Protocols](#chapter-6-api-testing-concepts-and-protocols)
7. [API Automation with Rest Assured & Karate](#chapter-7-api-automation-with-rest-assured--karate)
8. [The Gen AI Revolution in Testing](#chapter-8-the-gen-ai-revolution-in-testing)
9. [System Design & Coding Challenges](#chapter-9-system-design--coding-challenges)
10. [Behavioral Interview & Situation Handling](#chapter-10-behavioral-interview--situation-handling)
11. [Videos](#chapter-11-videos)

---

## Chapter 1: The Modern SDET Landscape

### Gone are the days when software development followed a rigid waterfall model—developers wrote code for months, handed it to QA, and hoped for the best. Today, Agile, DevOps, and continuous delivery put speed first. Speed without stability is a recipe for disaster.

Traditional manual testing could not keep pace with automated pipelines, and many developers lacked the mindset or time to cover edge cases and integration points thoroughly. That gap created the need for a hybrid role: the **Software Development Engineer in Test**.

### What is an SDET?

An SDET is a **technical professional with strong programming skills** who builds automated testing tools, frameworks, and infrastructure.

**Analogy**: While a product developer builds the feature (the "car"), an SDET builds the diagnostics, the wind tunnel, and the automation that ensure the car is safe and performs reliably at speed.

### The Skill Balance

To succeed and to explain your value in interviews, balance these three skill sets:

1. **Development**: Proficiency in languages such as Java (the focus in this course), plus familiarity with OOP, design patterns, and data structures.

2. **Testing**: Solid knowledge of the testing pyramid, boundary analysis, API contracts, and realistic user flows.

3. **Operations (DevOps)**: Experience with CI/CD (Jenkins, GitHub Actions), Docker, and cloud environments.

### SDET vs Traditional QA Engineer

When asked, "How does your role differ from a traditional manual QA?" use a crisp comparison.

**Interview Tip**: Emphasize that you value manual exploratory testing, but as an SDET your goal is to eliminate repetitive manual effort so the team can focus on complex scenarios.

### "Building Quality In": The Shift-Left Mindset

Modern SDETs operate with a **Shift Left** philosophy—move testing earlier in the SDLC. You "build quality in" by:

- Participating in architecture reviews to spot untestable designs early.
- Reviewing code for testability and edge-case handling.
- Driving contract testing to ensure APIs meet specs before the UI is built.

### Cost of Quality

Fixing a bug early is much cheaper than fixing it in production. Industry estimates often quote lower cost when addressed in requirements versus much higher costs in production. The takeaway: **find issues early when they are cheapest to fix**.

### The SDET in the SDLC and CI/CD

SDETs are integrated into the CI/CD pipeline. Your automation becomes a **gatekeeper**: failing tests should stop deployment. That requires **production-quality test code** and low-flakiness automation.

### Technical Snapshot: Jenkinsfile Example

Below is a representative Jenkinsfile pipeline snippet an SDET might manage. It shows build, unit tests, integration/API tests, UI automation, and post steps like report generation.

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Integration & API Tests') {
            steps {
                // Run TestNG suite for API
                sh 'mvn test -DsuiteXmlFile=api-testng.xml'
            }
        }
        stage('UI Automation (Selenium)') {
            steps {
                // Run UI tests in headless mode
                sh 'mvn test -DsuiteXmlFile=ui-testng.xml -Dheadless=true'
            }
        }
    }
    post {
        always {
            // Generate reports (example)
            // allure includeProperties: false, results: [[path: 'target/allure-results']]
        }
        failure {
            // notify team on failure
            // mail to: 'team@company.com', subject: 'Build Failed', body: 'Regression suite failed.'
        }
    }
}
```

### The Rise of Generative AI in Testing

Generative AI is changing routine SDET tasks by assisting with:

1. Self-healing scripts: Detecting locator changes and suggesting updates.
2. Test data generation: Creating realistic JSON payloads at scale.
3. Code assistance: Producing Page Object Model skeletons and boilerplate quickly.

AI speeds repetitive work, but it does not replace the SDET. It replaces junior tasks; skilled engineers must validate, optimize, and integrate AI-generated code.

### Summary

The modern SDET is a hybrid power user: part developer, part tester, part DevOps engineer. You write the code that finds bugs, test APIs and databases, and shift left to influence design and quality.

### Quiz — Chapter 1

**What is the primary focus of an SDET compared to a traditional QA engineer?**

A. Writing only manual test cases  
B. Preventing bugs during development and automating quality checks **(Correct)**  
C. Managing release schedules  
D. Only performing exploratory testing

**Which skill is NOT typically part of the SDET skill balance?**

A. Development (Java, OOP)  
B. Testing principles and API contracts  
C. DevOps and CI/CD knowledge  
D. Graphic design for product UI **(Correct)**

**What does "Shift Left" mean in testing?**

A. Moving testing to the end of the cycle  
B. Removing tests altogether  
C. Moving testing activities earlier in the SDLC **(Correct)**  
D. Doing only manual testing

---

## Chapter 2: Java Core for Automation Mastery

Automation is development. Building a scalable test framework requires solid programming fundamentals—this chapter focuses on Java concepts that form the backbone of Selenium and RestAssured frameworks.

### Object-Oriented Programming (OOP) in Automation

Interviewers expect you to map OOP principles to automation patterns.

**Encapsulation**: Protect data and expose behavior via methods. This is central to the Page Object Model (POM)—keep WebElement locators private and expose public interaction methods so locator changes are fixed in one place.

**Polymorphism**: Treat objects as their parent type to enable flexibility, e.g., `WebDriver driver = new ChromeDriver();` lets you swap browser implementations without changing test logic.

**Inheritance**: Use a BaseTest class for setUp() and tearDown() so test classes inherit common behavior.

### The Collections Framework

Automation works with groups of objects—lists, sets, and maps.

**List (ArrayList vs LinkedList)**: Use ArrayList when you primarily read data.

**Set (HashSet)**: Good for unique collections like window handles.

**Map (HashMap)**: Ideal for headers or credentials in API testing.

### Exception Handling: Building Resilience

Tests must fail clearly and release resources reliably.

**Checked vs Unchecked**: IOException vs NullPointerException. Use try-catch-finally to ensure cleanup in finally.

### Modern Java: Streams and Lambda Expressions (Java 8+)

Use Streams for concise, readable code.

```java
//Example: Streams to detect items under price threshold
List<WebElement> prices = driver.findElements(By.cssSelector(".product-price"));
List<Integer> cheapIphones = prices.stream()
    .map(e -> e.getText().replace("$", "")) // text cleaning
    .map(Integer::parseInt) // parse to int
    .filter(price -> price < 500) // filter
    .collect(Collectors.toList());

if (cheapIphones.size() > 0) {
    throw new RuntimeException("Found iPhones cheaper than $500!");
}
```

Lambdas are useful for waits and custom conditions:

```java
//Example: Lambda with WebDriverWait
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(d -> d.findElement(By.id("status")).getText().equals("Complete"));
```

### Chapter Summary

Mastering core Java distinguishes an automation framework architect from only a script user:

- OOP for structure (POM, BaseTest).
- Collections for dynamic data.
- Exception handling for resilience and cleanup.
- Streams and lambdas for concise, readable logic.

### Quiz — Chapter 2

**Which OOP principle is central to the Page Object Model?**

A. Polymorphism  
B. Encapsulation **(Correct)**  
C. Inheritance only  
D. Abstraction only

**Which collection is best for unique, unordered elements like window handles?**

A. ArrayList  
B. LinkedList  
C. HashSet **(Correct)**  
D. HashMap

**What is the purpose of the finally block in exception handling?**

A. To run only if no exception occurs  
B. To catch exceptions only  
C. To execute cleanup code regardless of success or failure **(Correct)**  
D. To replace try-catch entirely

---

## Chapter 3: Selenium 4 Fundamentals & WebDriver

If Java is like the brain, Selenium WebDriver is like the hands and eyes of your automation framework. This chapter covers Selenium 4 improvements, reliable locators, complex element handling, and synchronization strategies.

### The Architecture Shift: JSON Wire vs W3C Standardization

Selenium 3 used the JSON Wire Protocol for client-driver communication. Selenium 4 adopts the **W3C WebDriver standard**, which improves stability and reduces interpretation overhead between client libraries and browser drivers. This standardization helps reduce flaky behavior and promotes cross-browser consistency.

**Interview Tip**: If asked, "What changed in Selenium 4?", explain that the adoption of the W3C WebDriver standard is the major architectural difference.

### Element Location Strategies

Locating elements reliably is the foundation of stable tests. Preferred locator priority:

1. **ID** (`By.id`) — unique and often fastest.
2. **Name** (`By.name`) — often unique.
3. **CSS Selector** (`By.cssSelector`) — faster than XPath for many cases.
4. **XPath** (`By.xpath`) — powerful but more brittle.

### Selenium 4 Feature: Relative Locators

Relative locators find elements relative to others: `above`, `below`, `toLeftOf`, `toRightOf`, `near`.

```java
//Example: Relative Locator
// Find anchor element
WebElement usernameInput = driver.findElement(By.id("username"));

// Find password input below the username input
WebElement passwordInput = driver.findElement(
    RelativeLocator.with(By.tagName("input")).below(usernameInput)
);

passwordInput.sendKeys("SecretPassword123");
```

### Handling Complex Web Elements

**Dropdowns** with `<select>` tags use the Select class for reliability:

```java
//Example: Select usage
WebElement dropdown = driver.findElement(By.id("country"));
Select selectCountry = new Select(dropdown);
selectCountry.selectByVisibleText("United States");
selectCountry.selectByValue("US");
selectCountry.selectByIndex(1);
```

**Frames and windows** require context switching:

```java
//Example: Frame switching
driver.switchTo().frame("iframe_id");
// actions inside frame
driver.switchTo().defaultContent(); // back to main page
```

### Synchronization: The Cure for Flakiness

Timing mismatches create flaky tests. Use waits appropriately.

#### Implicit Wait
A global setting:
```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```

**Pros**: simple. **Cons**: can interact badly with explicit waits and produce unpredictable timing.

#### Explicit Wait (preferred)
Use WebDriverWait and ExpectedConditions for element-specific waits:

#### Fluent Wait
Use for polling frequency and ignoring specific exceptions.

### Common Interview Questions

**Q: What is the difference between driver.close() and driver.quit()?**

**A**: `close()` closes the current browser window or tab. `quit()` closes all windows and terminates the WebDriver session.

**Q: Why shouldn't we mix implicit and explicit waits?**

**A**: Mixing them can lead to unpredictable wait behavior and longer-than-expected timeouts.

### Summary

Selenium 4's W3C alignment improves stability. Use robust locator strategies, handle context switches correctly, and master explicit and fluent waits to build reliable tests that work in CI.

### Quiz — Chapter 3

**What is the main architectural change in Selenium 4 compared to Selenium 3?**

A. Removal of WebDriver entirely  
B. Introduction of a new scripting language  
C. Adoption of the W3C WebDriver standard **(Correct)**  
D. Full replacement of browser drivers

**Which locator is usually preferred for performance and stability?**

A. XPath always  
B. ID **(Correct)**  
C. CSS only  
D. Tag name only

**What does driver.quit() do?**

A. Closes the currently focused tab only  
B. Closes all browser windows and ends the WebDriver session **(Correct)**  
C. Pauses the driver  
D. Refreshes the page

---

## Chapter 4: Advanced Framework Design & Architecture

### Introduction: From Scripter to Architect

Knowing how to write a Selenium script does not make you a Senior SDET. Writing a script that works once is easy; designing a suite of 5,000 tests that runs reliably every night, that is easy to debug, and that is simple to maintain is an engineering feat.

The difference between a junior automation tester and an SDET architect lies in **framework design**. A framework is more than a folder structure—it is a set of guidelines, abstract classes, and design patterns that enforce coding standards and lower the maintenance cost of testing. In this chapter, we move beyond linear scripting and explore architectural patterns that power robust automation suites.

### The Page Object Model (POM): The Industry Standard

POM is a design pattern that creates an object repository for web UI elements. Its principle is **separation of concerns**: test logic (assertions, data) should never be mixed with implementation logic (selectors, WebElements).

- **Page Class**: Represents a specific page, contains locators (private) and methods to interact with them.
- **Test Class**: Calls methods on Page Classes and contains no direct WebDriver calls.

Implementation strategy: use encapsulation and fluent interfaces (method chaining).

```java
//Example: Page Class (POM)
public class LoginPage {
    private WebDriver driver;

    // Locators are private (Encapsulation)
    private By usernameField = By.id("user-name");
    private By passwordField = By.id("password");
    private By loginButton = By.id("login-button");
    private By errorMessage = By.cssSelector("h3[data-test='error']");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    // Action methods with Fluent Interface
    public LoginPage enterUsername(String username) {
        driver.findElement(usernameField).sendKeys(username);
        return this; // enables chaining
    }

    public LoginPage enterPassword(String password) {
        driver.findElement(passwordField).sendKeys(password);
        return this;
    }

    public InventoryPage clickLogin() {
        driver.findElement(loginButton).click();
        return new InventoryPage(driver);
    }
}

//Example: Test Class using POM
@Test
public void validLoginTest() {
    InventoryPage inventory = new LoginPage(driver)
        .enterUsername("standard_user")
        .enterPassword("secret_sauce")
        .clickLogin(); // transitions to next page
    Assert.assertTrue(inventory.isProductListDisplayed());
}
```

Why this wins interviews: it shows maintainability. If the login button ID changes, update it once in the Page Class.

### The Screenplay Pattern: The SOLID Alternative

POM can lead to very large classes. The Screenplay Pattern (popularized by Serenity) applies SOLID principles to testing.

- **Actors**: the entity performing actions.
- **Abilities**: what the actor can do (e.g., browse the web).
- **Tasks**: high-level business goals (e.g., log in).
- **Interactions**: low-level actions (click, enter).

```java
//Example: Screenplay-style usage
Actor inder = Actor.named("Inder");
inder.can(BrowseTheWeb.with(driver));
inder.attemptsTo(
    Login.withCredentials("user", "pass")
);
inder.should(
    seeThat(TheInventory.items(), hasSize(6))
);
```

Interview tip: you do not have to implement Screenplay for every role, but explaining why it exists (to solve POM bloat and improve composition) demonstrates architectural maturity.

### Advanced Selenium 4: Chrome DevTools Protocol (CDP)

Selenium 4 exposes integration with the browser debugging protocol (CDP). CDP lets SDETs manipulate network conditions, emulate geolocation, capture performance traces, and intercept requests.

Use cases: network simulation for resilience testing, geolocation mocking for location-based behavior, and request interception to test error handling.

### 4. WebDriver BiDirectional (BiDi) Protocol

BiDi extends two-way, event-driven communication between client and browser to enable real-time event listening across browsers. Unlike traditional synchronous WebDriver, BiDi allows subscribing to browser events such as console logs, network events, or runtime exceptions.

Use cases: network simulation for resilience testing, geolocation mocking for location-based behavior, and request interception to test error handling.

```java
//Example: Listening for console errors
LogInspector logInspector = new LogInspector(driver);
logInspector.onConsoleEntry(entry -> {
    if (entry.getLevel() == ConsoleLogEntry.Level.ERROR) {
        System.out.println("JS Error detected: " + entry.getText());
        // fail test or log issue
    }
});
driver.get("https://buggy-site.com");
```

BiDi transforms automation into monitoring: detect JS exceptions, network failures, or security warnings as they occur.

### Summary: Architecture as a Mindset

- Choose POM for standard enterprise apps and team familiarity.
- Consider Screenplay for highly complex domains and better separation of responsibilities.
- Use CDP and BiDi for hard-to-reach scenarios like network faults and real-time console monitoring.

### Quiz — Chapter 4

**What is the primary benefit of using the Page Object Model?**

A. Faster test execution  
B. Separation of concerns and maintainability **(Correct)**  
C. Eliminates the need for waits  
D. Reduces the number of test cases

**Which pattern emphasizes Actors, Abilities, Tasks, and Interactions?**

A. Page Object Model  
B. MVC  
C. Screenplay Pattern **(Correct)**  
D. Singleton Pattern

**What does Chrome DevTools Protocol allow you to do from tests?**

A. Only take screenshots  
B. Only run JavaScript in the browser  
C. Simulate network conditions and emulate geolocation **(Correct)**  
D. Replace WebDriver entirely

---

## Chapter 5: Orchestration: TestNG, Build Tools, and CI/CD

### Introduction: The Conductor of the Orchestra

Orchestration organizes individual tests into a cohesive execution strategy. It enables tasks like run smoke tests only, execute tests in parallel, and trigger tests automatically on commits.

Integrating tests into CI/CD differentiates a framework developer from a local script runner.

### Test Runners: TestNG and JUnit 5

Test runners manage lifecycle, reporting, and execution. TestNG remains a dominant choice, though JUnit 5 is widely adopted.

**TestNG annotation lifecycle** (order of execution):
1. `@BeforeSuite` / `@AfterSuite`
2. `@BeforeTest` / `@AfterTest`
3. `@BeforeClass` / `@AfterClass`
4. `@BeforeMethod` / `@AfterMethod`
5. `@Test`

Use `@BeforeMethod` for resetting browser state and `@BeforeSuite` for global setup like reporting or DB connections.

**Grouping and filtering**: use TestNG groups to tag and run subsets.

```java
//Example: TestNG grouping
@Test(groups = {"smoke", "login"})
public void verifyValidLogin() {
    // test logic
}
```

**Parallel execution and thread safety**: use TestNG parallelization (methods/classes) and avoid static WebDriver instances; use `ThreadLocal<WebDriver>` for isolation.

### Build Tools: Maven and Gradle

Frameworks must run from the CLI for CI servers. Use Maven or Gradle for dependency management and builds.

Resolve dependency conflicts by analyzing dependency hierarchy and excluding conflicting transitive dependencies.

**Maven Surefire Plugin** runs TestNG suites via Maven and binds tests to the build lifecycle.

Use Maven profiles for environment-specific properties (e.g., `-Pqa`).

### CI/CD Integration: The Quality Gate

CI detects commits and runs builds; CD automates releases. SDETs enforce the **quality gate**: failing tests should block deployment.

Jenkins pipeline steps: checkout, build, run tests, generate reports, notify on failures. GitHub Actions can run similar pipelines via repository workflows.

**Headless execution**: CI runners lack GUIs; use ChromeOptions with `--headless` and `--window-size=1920,1080` to ensure consistent rendering.

```java
//Example: ChromeOptions for headless CI
ChromeOptions options = new ChromeOptions();
options.addArguments("--headless");
options.addArguments("--window-size=1920,1080");
```

### Interview checklist (sample questions and answers):

- **How do you rerun failed tests?** — Implement TestNG IRetryAnalyzer.
- **Difference between @BeforeMethod and @BeforeClass?** — @BeforeMethod runs before each test; @BeforeClass runs once per class.
- **How to pass parameters from Jenkins to tests?** — Use parameterized builds and `System.getProperty("BROWSER_TYPE")` with `mvn -DBROWSER_TYPE=chrome`.
- **What is a flaky test and how to fix it?** — A test that unpredictably passes/fails. Fix by improving synchronization, isolating data, removing implicit sleeps.

### Summary

We transformed standalone code into deployable artifacts: TestNG for orchestration, Maven for builds, and CI/CD for enforcement of quality gates. Frameworks should be runnable in CI with headless execution and secure configuration.

### Quiz — Chapter 5

**Which TestNG annotation runs before every test method?**

A. @BeforeSuite  
B. @BeforeClass  
C. @BeforeMethod **(Correct)**  
D. @BeforeTest

**What is a recommended solution for running tests in parallel without driver collisions?**

A. Use a static WebDriver for all threads  
B. Use Thread.sleep extensively  
C. Use ThreadLocal<WebDriver> to provide per-thread instances **(Correct)**  
D. Disable parallel execution entirely

**Why use headless browser mode in CI?**

A. It provides more visuals for debugging  
B. It increases flakiness  
C. CI runners do not have a display; headless ensures tests run without a GUI **(Correct)**  
D. It makes tests slower

---

## Chapter 6: API Testing Concepts and Protocols

### Introduction: The Iceberg Beneath the Surface

The UI is only the visible 10% of an application; the backend is the 90% where core logic and most critical defects live. API testing interacts directly with that backend and is faster, more stable, and shifts validation earlier in the lifecycle.

### The API Landscape: REST vs SOAP

SOAP is a strict protocol using XML with built-in standards (WS-Security), suited to legacy or highly regulated systems. REST is an architectural style, typically using JSON, statelessness, and standard HTTP methods—preferred for modern web and mobile apps.

### The Parts of an HTTP Request

Four pillars:

1. **Endpoint (URI)** — resource address.
2. **Method (verb)** — GET, POST, PUT, PATCH, DELETE.
3. **Headers** — metadata (auth, content-type).
4. **Body** — payload for POST/PUT/PATCH.

Map HTTP verbs to CRUD and note idempotence: PUT and DELETE are typically idempotent; POST is not.

### Status Codes

Know major codes and ranges (2xx success, 3xx redirects, 4xx client errors, 5xx server errors).

Examples include:
- 200 OK
- 201 Created
- 204 No Content
- 400 Bad Request
- 401 Unauthorized
- 403 Forbidden
- 404 Not Found
- 500 Internal Server Error

### Authentication Mechanisms

- **Basic Auth** — base64 username:password, requires HTTPS.
- **OAuth 2.0** — token-based authorization flow for third-party access.
- **JWT** — stateless signed tokens sent as Authorization: Bearer <token>.

### The Data Layer: JSON Payloads

JSON is the primary payload format. Validate both data values and response schema structure (type checking, presence of fields). Use libraries like Jackson or GSON for parsing in Java.

```json
{
    "firstName": "John",
    "lastName": "Doe",
    "isActive": true,
    "roles": ["admin", "editor"],
    "address": {
        "street": "123 Java Lane",
        "city": "Techville"
    }
}
```

Validations: data assertions (value correctness) and schema assertions (field types and presence).

### Summary: The Shift Left

API tests run faster, are more stable than UI tests, and let you verify business logic before the UI exists. This is the essence of shifting left.

### Quiz — Chapter 6

**Which HTTP method is typically non-idempotent (meaning that it has side effects)?**

A. POST **(Correct)**  
B. PUT  
C. DELETE  
D. GET

**Which authentication method involves stateless signed tokens?**

A. Basic Auth  
B. OAuth 1.0  
C. JWT **(Correct)**  
D. API Key only

**Why are API tests preferred over UI tests for shift-left testing?**

A. They are slower but more visual  
B. They require a browser to run  
C. They are faster, more stable, and can validate business logic earlier **(Correct)**  
D. They cannot be automated

---

## Chapter 7: API Automation with Rest Assured & Karate

### Introduction: Turning Protocols into Code

Rest Assured (Java) and Karate (BDD-style) are key tools for API automation. Rest Assured integrates with Java frameworks; Karate offers concise, readable feature files and built-in parallel execution.

### Rest Assured: The Java DSL Standard

Rest Assured provides a fluent, BDD-like API.

```java
//Example: Rest Assured POST request
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

public class UserApiTest {
    static {
        RestAssured.baseURI = "https://api.example.com";
    }

    @Test
    public void createNewUserTest() {
        String requestBody = "{ \"name\": \"John Doe\", \"job\": \"SDET\" }";

        given()
            .contentType(ContentType.JSON)
            .header("Authorization", "Bearer token123")
            .body(requestBody)
        .when()
            .post("/users")
        .then()
            .statusCode(201)
            .body("name", equalTo("John Doe"))
            .body("id", notNullValue())
            .time(lessThan(2000L)); // response time assertion
    }
}
```

### JSON Path: Assertions

Use JsonPath to extract nested values for validation or reuse.

### Karate DSL: The BDD Alternative

Karate removes step definitions; the Gherkin scenario is executable.

```gherkin
Feature: User Management API
Background:
    * url 'https://api.example.com'

Scenario: Create and Validate User
    Given path 'users'
    And request { name: 'Jane Doe', job: 'Architect' }
    When method post
    Then status 201
    And match response == { id: '#notnull', name: 'Jane Doe', job: 'Architect', createdAt: '#ignore' }
```

When to choose: Rest Assured for Java-heavy frameworks and integration with POJOs (Plain Old Java Objects); Karate for quick implementation, readability, and enabling non-developers to write tests.

### Data-Driven API Testing

Use TestNG DataProviders or Karate Scenario Outline/Examples for data-driven coverage.

```java
//Example: TestNG DataProvider for Rest Assured
@DataProvider(name = "userData")
public Object[][] createUserData() {
    return new Object[][] {
        {"John", "QA"},
        {"Alice", "Dev"},
        {"Bob", "Manager"}
    };
}

@Test(dataProvider = "userData")
public void dataDrivenPost(String name, String job) {
    JSONObject requestParams = new JSONObject();
    requestParams.put("name", name);
    requestParams.put("job", job);

    given()
        .body(requestParams.toJSONString())
    .when()
        .post("/users")
    .then()
        .statusCode(201);
}
```

### Advanced Architecture: RequestSpecification and POJOs

Create reusable RequestSpecification and map JSON to POJOs for type safety and maintainability.

### Interview Tip

Expect questions about auth handling, PUT vs PATCH, validating dynamic IDs, and choosing between Rest Assured and Karate.

### Summary

You know about how to automate APIs end-to-end and design frameworks that scale. The next chapter will explore Gen AI for SDETs—how AI assists with code generation, test data, and self-healing tests.

### Quiz — Chapter 7

**Which tool converts Gherkin scenarios directly into executable tests without step definitions?**

A. Rest Assured  
B. Cucumber with step definitions  
C. Karate **(Correct)**  
D. Postman

**In Rest Assured, what is RequestSpecification used for?**

A. To store database connections  
B. To store UI locators  
C. To centralize base URI and common headers for reuse **(Correct)**  
D. To manage thread-local drivers

**Why prefer POJOs for request/response bodies in Rest Assured?**

A. They make tests slower  
B. They remove the need for assertions  
C. They provide type safety and easier serialization/deserialization **(Correct)**  
D. They require less memory

---

## Chapter 8: The Gen AI Revolution in Testing

### Introduction: The New Co-Pilot

By now, you know about Java core, Selenium WebDriver, framework architecture, CI/CD pipelines, and API protocols. Generative AI (Gen AI) is the next productivity multiplier. For the modern SDET, Gen AI is a turbocharger, not a replacement. This chapter explains how Large Language Models (LLMs) like GPT-5, Claude, and Llama can be integrated into Java frameworks for test generation, data synthesis, and self-healing.

### From Requirements to Code: Automatic Test Generation

One immediate use of Gen AI is reducing "time to first test." Instead of manually translating a user story into test cases and step definitions, an LLM can identify boundary values, positive flows, and negative flows and output syntactically correct Selenium/Java code.

**Workflow**
1. Input: Raw user story or acceptance criteria.
2. Process: LLM analyzes text to extract testable scenarios.
3. Output: Draft Page Objects, step implementations, and test methods for review.

### Example: Generating Page Objects

```java
package com.automation.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginModal {
    WebDriver driver;

    @FindBy(css = "input[name='user_email']")
    private WebElement emailField;

    @FindBy(css = "input[name='password']")
    private WebElement passwordField;

    @FindBy(css = "button[data-testid='submit-login']")
    private WebElement loginButton;

    @FindBy(css = ".alert-error")
    private WebElement errorMessage;

    public LoginModal(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void login(String email, String pass) {
        emailField.sendKeys(email);
        passwordField.sendKeys(pass);
        loginButton.click();
    }
}
```

**Interview Tip**: say you use AI to generate boilerplate only; you validate and adapt AI output to framework patterns, security, and style.

### Synthetic Data Generation for Privacy Compliance

Production data is often sensitive. Apart from tools like Mock Data Generator, Gen AI can produce context-aware synthetic data that follows schema and locale rules but contains fictitious values, enabling realistic tests without privacy risk.

### Example: AI-driven data generator (pseudo-code)

```java
// Example: Pseudo-code wrapper for synthetic data generation
public class DataGenerator {
    // Wraps an LLM API call and returns a JSON string for a user profile
    public static String generateUserProfile(String role) {
        String prompt = "Generate a valid JSON user profile for role '" + role +
            "'. Include email, address (US format), and phone. Use fictitious data.";
        return OpenAIService.call(prompt); // Replace with your validated service wrapper
    }
}
```

Resulting payload (example):

```json
{
    "email": "tester_992@synthetic.com",
    "role": "ADMIN",
    "address": {
        "street": "4502 Mockingbird Lane",
        "city": "Springfield",
        "state": "IL",
        "zip": "62704"
    }
}
```

### Self-Healing Automation Scripts

Flakiness often arises from changing locators. A self-healing approach captures failures, analyses the DOM, queries an LLM for likely selectors, retries, and—if validated—updates the locator store.

**How it works**
1. Failure detection (NoSuchElementException).
2. Capture DOM snapshot and contextual text.
3. Query LLM: provide the intended locator, surrounding attributes, and ask for candidate selectors.
4. Validate suggested selector; if it works, persist it (and log the change for human review).

### Limitations: Hallucinations and Verification

LLMs are probabilistic and can sometimes **hallucinate** (meaning provide non-existent facts confidently): suggest non-existent libraries, insecure patterns, or incorrect APIs. Emphasize **Human in the Loop (HITL)**: SDETs must review AI outputs for correctness, security, and architectural fit.

The SDET role shifts from sole author to **AI reviewer and integrator**. Always validate AI-generated code with static analysis, security scans, unit tests, and code reviews.

### Summary: Future-Proofing Your Career

Gen AI automates repetitive tasks and speeds development, but it raises the bar for SDETs who must verify, secure, and integrate AI outputs. Prepare to design architectures, orchestrate CI/CD, ensure API reliability, and review AI artifacts.

### Quiz — Chapter 8

**What is the primary role of Gen AI in test generation for SDETs?**

A. Replace SDETs entirely  
B. Generate boilerplate and accelerate the first draft of tests **(Correct)**  
C. Automatically merge pull requests  
D. Run CI pipelines

**Which of the following is a privacy-safe use of Gen AI for test data?**

A. Copying production PII into test environments  
B. Re-using real customer emails  
C. Generating synthetic, context-aware data that follows schema rules **(Correct)**  
D. Scraping random public data without consent

**What is a major risk when using LLMs to auto-generate code?**

A. Faster test creation  
B. Lower maintenance cost  
C. Hallucinations and insecure or incorrect suggestions **(Correct)**  
D. Improved test coverage

---

## Chapter 9: System Design & Coding Challenges

### Introduction: The Whiteboard Challenge

Live technical interviews test both algorithmic thinking and architecture skills. As an SDET you must be ready for string and collection problems, and for designing scalable test automation frameworks.

### Coding Challenges (Data Structures & Algorithms)

You will be asked to demonstrate proficiency with Strings, Collections, Stacks, Maps, and basic algorithms relevant to parsing, deduplication, and validation.

**Example: Count character frequency**

**Example: Balanced parentheses validator**

### System Design for SDETs

Designing a test framework in interviews requires clear requirements, a layered architecture, and trade-offs for scalability and maintainability.

**High-level layers**
1. **Test Layer**: TestNG/JUnit tests containing assertions only.
2. **Business Logic Layer**: Page Objects / Action classes.
3. **Core Layer**: Driver factory (ThreadLocal), wrapper utilities, config.
4. **Reporting & Infrastructure**: Logging, reporting, CI/CD integration.

**Key design considerations**

**A. Scalability and Parallel Execution**: Use TestNG parallel modes and ThreadLocal<WebDriver>.

Ensure stateless tests and isolated test data.

**B. Database Integration**: Integrate JDBC utilities to seed and validate data: setup, execute, assert.

**C. Handling Flakiness**: Implement retry strategies selectively, replace Thread.sleep with explicit/fluent waits, and add stale element recovery wrappers.

**D. Logging and Reporting**: Use structured logging (Log4j) and attach screenshots on failure via ITestListener.

### Example: ThreadLocal WebDriver (conceptual)

```java
// Example: Thread-safe WebDriver using ThreadLocal
public class DriverFactory {
    private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

    public static synchronized void setDriver(WebDriver driver) {
        tlDriver.set(driver);
    }

    public static WebDriver getDriver() {
        return tlDriver.get();
    }

    public static synchronized void removeDriver() {
        tlDriver.get().quit();
        tlDriver.remove();
    }
}
```

**Interview Tip**: discuss clarifying questions first (platform, scale, environment), sketch layered architecture, and justify choices.

### Quiz — Chapter 9

**Which data structure is most appropriate for checking balanced brackets?**

A. Queue  
B. List  
C. Stack **(Correct)**  
D. Map

**What is the primary benefit of using ThreadLocal<WebDriver> in a test framework?**

A. Slower tests  
B. Shared single driver instance  
C. Per-thread isolated WebDriver instances for parallel execution **(Correct)**  
D. Avoids using Selenium

**Which approach best reduces flakiness caused by timing issues?**

A. Using Thread.sleep everywhere  
B. Running tests sequentially only  
C. Explicit and fluent waits with robust element wrappers **(Correct)**  
D. Removing assertions

**When designing a framework, where should WebDriver calls be placed?**

A. Directly in test methods  
B. In utility scripts only  
C. Encapsulated inside Page Objects or core driver wrappers **(Correct)**  
D. In reporting modules

**What is an appropriate use of database integration in tests?**

A. Replace UI checks completely  
B. Use production data without masking  
C. Seed test data, validate persistence, and clean up state **(Correct)**  
D. Generate random production-like records without governance

**Which is a poor strategy for handling flaky tests?**

A. Improving waits and isolation  
B. Adding retries blindly for assertion failures  
C. Implementing a quarantine and root cause analysis  
D. Using retry only for known environment issues

---

## Chapter 10: Behavioral Interview & Situation Handling

### Introduction: The Soft Skills

Behavioral skills determine whether you fit the team and can influence product quality. Adopt a **prevention-first mindset**: SDETs prevent defects, enable developers, and make risk-informed decisions.

The **STAR method** (Situation, Task, Action, Result) is the recommended structure for behavioral answers. Use numbers and outcomes wherever possible.

### Scenario: Handling Flaky Tests

**Preferred answer structure (STAR):**

- **Situation**: Nightly suite had high flakiness.
- **Task**: Restore trust and stabilize pipeline.
- **Action**: Quarantine intermittent tests, replace Thread.sleep with explicit/fluent waits, add selective retries for environmental issues.
- **Result**: Green builds recovered; quarantine backlog reduced significantly.

### Scenario: Conflict Resolution with Developers

Move conversations from opinion to data: reproduce with logs, screenshots, and test data; verify acceptance criteria; involve product owner when requirements are ambiguous; offer to pair-debug if needed.

### Scenario: Prioritization Under Pressure

Assess impact (functional or data loss), propose mitigations (feature flag, workaround), and if risk is severe (data loss, security), recommend delaying release. Always propose a post-mortem to prevent recurrence.

### Agile ceremonies

Participate in planning to assess testability, report automation impact in standups, and use retrospectives to address technical debt.

### Questions to ask the interviewer

- What is the developers-to-SDET ratio?
- Is automation part of the Definition of Done (DoD)?
- How is test data managed in lower environments?

### Quiz — Chapter 10

**What is the STAR method used for?**

A. Writing test scripts  
B. Designing frameworks  
C. Structuring behavioral interview answers (Situation, Task, Action, Result) **(Correct)**  
D. Choosing test data

**When a developer says "It works on my machine," the best first step is to:**

A. Argue until they agree  
B. Close the bug immediately  
C. Provide reproducible evidence: logs, screenshots, and exact test steps **(Correct)**  
D. Re-run tests endlessly

**If a production release risks data loss and management wants to proceed, you should:**

A. Stay silent and let it go  
B. Help hide the bug in release notes  
C. Clearly state the risk, propose mitigations, and recommend delaying if data loss is possible **(Correct)**  
D. File a generic bug and move on

---

## Chapter 11: Videos

In order to learn more, view my following videos:

- [Artificial Intelligence for Software Testing](https://youtu.be/iyVbrPG7L5U)
- [What is the Role of Artificial Intelligence in Software Testing?](https://youtu.be/TZlZVnnvcgs)
- [How to use Machine Learning in Software Testing](https://youtu.be/DwGuzfom67M)
- [Artificial Intelligence Projects for Resume](https://youtu.be/E8aXSlZL4KA)
- [Artificial Intelligence in Test Automation](https://youtu.be/-tHDcNc2IxU)
- [Building Test Automation Framework using AI](https://youtu.be/1hMcKjEp6to)
- [Artificial Intelligence Projects in Test Automation](https://youtu.be/QTr-MqcIPvs)
- [Advanced AI Concepts in Test Automation](https://youtu.be/y3C3QIhj-dg)
- [Free Artificial Intelligence AI Project in Python - Generative AI Chatbot](https://youtu.be/nVTu6IjUbNY)
- [LLM Concepts Deep Dive: Tokens, Transformers, Embeddings & RAG Explained](https://youtu.be/PLACEHOLDER)
- [Generative AI: Builder's Journey - Build LLMs, RAG, Prompting and Deployment in Gen AI](https://youtu.be/PLACEHOLDER)

---

*This comprehensive guide covers SDET interview preparation with Selenium, Java, API Testing, and Gen AI. Prepared by Inder P Singh. All rights reserved © 2025.*
