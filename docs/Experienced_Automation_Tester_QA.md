# Interview Questions & Answers for Experienced Automation Testers

## Section 1: Selenium WebDriver (20 Questions)

**Q1. What are different types of waits in Selenium?**  
Selenium provides three types of waits to handle synchronization:
- **Implicit Wait**: Sets a default waiting time for all elements.
  ```java
  driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
  ```
- **Explicit Wait**: Waits for specific conditions on particular elements.
  ```java
  WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
  wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("submitBtn")));
  ```
- **Fluent Wait**: Custom polling and exception handling.
  ```java
  Wait<WebDriver> wait = new FluentWait<>(driver)
      .withTimeout(Duration.ofSeconds(10))
      .pollingEvery(Duration.ofMillis(500))
      .ignoring(NoSuchElementException.class);
  wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("element")));
  ```

**Q2. Explain the difference between `findElement()` and `findElements()`.**  
- `findElement()`: Returns a single `WebElement`; throws `NoSuchElementException` if not found.  
  ```java
  WebElement element = driver.findElement(By.id("username"));
  ```
- `findElements()`: Returns a `List<WebElement>`; returns empty list if none found.  
  ```java
  List<WebElement> elements = driver.findElements(By.className("item"));
  ```
Use `findElement()` when exactly one element is expected; `findElements()` for zero-or-many.

**Q3. What are XPath and CSS Selector? When to use each?**  
- **XPath**: Powerful, can traverse both directions.  
  `By.xpath("//button[@id='submit' and @class='primary']")`  
  `By.xpath("//div[contains(@class, 'error-message')]")`
- **CSS Selector**: Faster, concise for most cases.  
  `By.cssSelector("button#submit.primary")`  
  `By.cssSelector("div.error-message")`
Use CSS for simple stable locators; XPath for complex relations or when traversing parents/siblings.

**Q4. How to handle dynamic elements / changing IDs?**  
Strategies:
1. Partial attribute match  
   `By.xpath("//button[starts-with(@id, 'btn_')]")`  
   `By.cssSelector("button[id*='dynamic']")`
2. Relative XPath by text  
   `By.xpath("//button[contains(text(), 'Submit')]")`  
   `By.xpath("//label[text()='Username']/following::input")`
3. Wait for presence/clickable  
   ```java
   WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
   wait.until(ExpectedConditions.presenceOfElementLocated(
       By.xpath("//button[contains(@class, 'dynamic')]")));
   ```
4. Explicit wait then interact  
   ```java
   WebElement element = wait.until(
       ExpectedConditions.elementToBeClickable(By.xpath("//button[@onclick*='submit']")));
   element.click();
   ```

**Q5. Explain the Page Object Model (POM) pattern and its advantages.**  
Each page = class; locators + actions encapsulated.
```java
public class LoginPage {
  private WebDriver driver;
  private By username = By.id("username");
  private By password = By.id("password");
  private By loginBtn = By.id("loginBtn");

  public LoginPage(WebDriver driver) { this.driver = driver; }
  public void enterUsername(String u) { driver.findElement(username).sendKeys(u); }
  public void enterPassword(String p) { driver.findElement(password).sendKeys(p); }
  public DashboardPage clickLogin() { driver.findElement(loginBtn).click(); return new DashboardPage(driver); }
}
```
Advantages: centralized locators, maintainability, reduced duplication, readable tests, separation of concerns.

**Q6. Difference between Actions class and direct element methods?**  
- Direct: simple interactions (`click()`, `sendKeys()`).
- Actions: complex gestures (hover, drag-drop, right-click, key chords).
```java
Actions actions = new Actions(driver);
actions.moveToElement(el).click().perform();
actions.dragAndDrop(src, dst).perform();
actions.keyDown(Keys.SHIFT).click(el).keyUp(Keys.SHIFT).perform();
```

**Q7. How do you handle `StaleElementReferenceException`?**  
- Re-locate element after DOM change.
- Use explicit waits for presence/visibility.
- Retry on stale within a loop.
```java
int attempts = 0;
while (attempts < 3) {
  try { driver.findElement(By.id("element")).click(); break; }
  catch (StaleElementReferenceException e) { attempts++; }
}
```

**Q8. Locator strategies and reliability order.**  
1) ID, 2) Name, 3) CSS, 4) XPath, 5) LinkText/Partial, 6) ClassName, 7) TagName.  
Prefer ID/CSS; avoid brittle complex XPaths.

**Q9. Differences: `driver.navigate()`, `driver.get()`, `driver.switchTo()`**  
- `get(url)`: Loads URL, waits for load.  
- `navigate().to/back/forward/refresh()`: Adds history control.  
- `switchTo()`: Change context (frames, windows, alerts).

**Q10. Handling pop-ups, alerts, dialogs.**  
- Alerts: `Alert alert = driver.switchTo().alert(); alert.accept();`  
- Windows: store main handle, iterate `getWindowHandles()`, switch.  
- Frames: `switchTo().frame(name|index|element)`, then `defaultContent()` / `parentFrame()`.

**Q11. Implicit vs Explicit vs Fluent Wait (practical).**  
| Scenario | Wait Type | Example |
| --- | --- | --- |
| Page-wide default wait | Implicit | `implicitlyWait(10s)` |
| Specific element condition | Explicit | `new WebDriverWait(...).until(visibilityOf(...))` |
| Custom polling/ignores | Fluent | `new FluentWait(...).pollingEvery(500ms)...` |
Best practice: avoid mixing implicit with explicit; prefer explicit/fluent.

**Q12. Screenshots and visual reports.**  
```java
File shot = ((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(shot, new File("./screenshots/test_"+System.currentTimeMillis()+".png"));
// Element screenshot (Selenium 4)
File elem = element.getScreenshotAs(OutputType.FILE);
```
For reports, integrate ExtentReports / Allure and attach images (path or Base64).

**Q13. Handling SSL certificate errors.**  
```java
ChromeOptions opt = new ChromeOptions(); opt.setAcceptInsecureCerts(true);
WebDriver driver = new ChromeDriver(opt);
// Similar for FirefoxOptions/EdgeOptions
```

**Q14. Keyboard and mouse interactions.**  
```java
Actions a = new Actions(driver);
a.sendKeys(Keys.ENTER).perform();
a.click(element).doubleClick(element).contextClick(element).perform();
a.dragAndDrop(src, dst).perform();
```

**Q15. `switchTo()` for frames/windows.**  
- Frames: `frame(index|name|element)`, `parentFrame()`, `defaultContent()`.  
- Windows: iterate handles, `switchTo().window(handle)`, return to main.

**Q16. File uploads / downloads.**  
- Upload: `element.sendKeys("C:\\path\\file.txt");`  
- Downloads: set browser prefs to auto-download; verify file exists in download dir.

**Q17. Common ExpectedConditions (WebDriverWait).**  
`presenceOfElementLocated`, `visibilityOfElementLocated`, `elementToBeClickable`, `textToBePresentInElement`, `stalenessOf`, `invisibilityOfElementLocated`, `numberOfElementsToBeMoreThan`, `urlContains`, `alertIsPresent`.

**Q18. Execute JavaScript in Selenium.**  
```java
JavascriptExecutor js = (JavascriptExecutor) driver;
js.executeScript("arguments[0].click();", element);
js.executeScript("arguments[0].scrollIntoView(true);", element);
String value = (String) js.executeScript("return arguments[0].textContent;", element);
```

**Q19. Headless browser testing (pros/cons).**  
- Pros: faster, lower resource, CI-friendly, good for parallel.  
- Cons: no visuals, some JS/CSS differences, harder debug.  
```java
ChromeOptions o = new ChromeOptions(); o.addArguments("--headless=new");
WebDriver driver = new ChromeDriver(o);
```

**Q20. Test data & env configuration.**  
Use properties/JSON, config reader, env-specific files.  
```java
Properties p = new Properties();
p.load(new FileInputStream("./config.properties"));
String url = p.getProperty("base.url");
```

---

## Section 2: Core Java (20 Questions)

**Q21. OOP concepts: Encapsulation, Inheritance, Polymorphism, Abstraction.**  
- Encapsulation: hide data via accessors.  
- Inheritance: reuse / IS-A.  
- Polymorphism: overloading/overriding.  
- Abstraction: abstract classes/interfaces.

**Q22. Static vs non-static members.**  
Static: class-level, single copy, accessed via class, hidden not overridden.  
Non-static: per-instance, can be overridden.

**Q23. Exception hierarchy & handling.**  
`Throwable -> Error / Exception -> (Checked / Runtime)`. Use try-catch-finally, multi-catch, try-with-resources, `throw/throws`.

**Q24. Checked vs unchecked exceptions.**  
Checked must be declared/caught (e.g., IOException); unchecked extend RuntimeException (e.g., NPE).

**Q25. String vs StringBuilder vs StringBuffer.**  
Immutable vs mutable; thread-safety (StringBuffer synchronized); performance.

**Q26. Access modifiers scope.**  
`public` (anywhere), `protected` (package + subclasses), default (package), `private` (class).

**Q27. Interfaces vs abstract classes.**  
Interface = contract (single/multiple), default/static methods allowed. Abstract class = partial impl, state + behavior, single inheritance.

**Q28. Overloading vs overriding.**  
Overloading: same name, different params (compile-time). Overriding: subclass redefines (runtime).

**Q29. `final` keyword uses.**  
Final class (no extend), final method (no override), final variable (const).

**Q30. Pass-by-value in Java.**  
Primitives copy value; object references copied (object mutable, reference reassignment not reflected).

**Q31. Constructors: default, parameterized, copy.**  
Used for initialization; copy constructor to clone state.

**Q32. `this` and `super`.**  
`this` current instance; `super` parent access/constructor.

**Q33. `instanceof` usage.**  
Type checking before casting; e.g., driver instanceof ChromeDriver.

**Q34. Memory management & GC; leaks.**  
Heap vs Stack; eligible for GC when unreferenced; avoid static collections holding onto objects.

**Q35. Wrapper classes, auto-boxing/unboxing.**  
Primitives to objects and back; needed for generics/collections.

**Q36. `==` vs `.equals()`.**  
`==` reference (objects) / value (primitives); `.equals()` content (override for custom).

**Q37. Immutability & creating immutable classes.**  
Final class, final fields, no setters, defensive copies.

**Q38. Generics for type safety.**  
Compile-time checks, no casting; bounded generics.

**Q39. HashMap vs Hashtable.**  
HashMap not synchronized, allows null; Hashtable synchronized, legacy.

**Q40. Lambda expressions & functional interfaces.**  
Single Abstract Method (SAM); use Predicate, Function, Consumer, Supplier; method refs.

---

## Section 3: Java Collections Framework (15 Questions)

**Q41. Collection hierarchy; Collection vs Collections.**  
Collection = root interface (List/Set/Queue). Collections = utility class (static helpers).

**Q42. ArrayList vs LinkedList vs Vector.**  
ArrayList: random access, dynamic array. LinkedList: fast insert/delete mid, queue/deque. Vector: legacy synchronized.

**Q43. HashSet vs TreeSet vs LinkedHashSet.**  
HashSet: no order, O(1). TreeSet: sorted, O(log n), no null. LinkedHashSet: insertion order.

**Q44. HashMap vs TreeMap vs LinkedHashMap.**  
HashMap: no order, allows null. TreeMap: sorted by key, no null key. LinkedHashMap: insertion order.

**Q45. Comparable vs Comparator.**  
Comparable = natural ordering inside class; Comparator = external multiple orderings.

**Q46. Iterator and safe removal.**  
Use iterator.remove() or `removeIf`; avoid modifying during enhanced for.

**Q47. Fail-fast vs fail-safe iterators.**  
Fail-fast (ArrayList, HashMap) throw CME on modification. Fail-safe (ConcurrentHashMap, CopyOnWriteArrayList) work on snapshot.

**Q48. `stream()` vs `parallelStream()`.**  
Sequential vs parallel processing; order guarantees differ; use parallel for large CPU-bound tasks when order not critical.

**Q49. Queue, Deque, PriorityQueue.**  
Queue FIFO; Deque double-ended; PriorityQueue ordered by priority/comparator.

**Q50. Map.Entry iteration methods.**  
`entrySet()`, `keySet()`, `values()`, `forEach`, streams.

**Q51. Fail-fast vs fail-safe collections (expanded).**  
Fail-fast throw CME on concurrent modification; fail-safe use copy/snapshot (no CME, may not reflect latest).

**Q52. Stream ops: filter/map/flatMap/reduce/collect.**  
Examples for even filter, mapping, flattening, reducing sum/product, collecting to list/set/map/grouping.

**Q53. Array vs ArrayList.**  
Fixed vs dynamic size; primitives allowed in arrays; ArrayList objects only; richer API.

**Q54. Difference List vs Set vs Map.**  
List ordered/duplicates; Set unique; Map key-value with unique keys.

**Q55. Collectors common methods.**  
`toList`, `toSet`, `toMap`, `groupingBy`, `partitioningBy`, `joining`, `counting`, `averaging`, `summarizingInt`, `maxBy/minBy`.

---

## Section 4: TestNG Framework (16 Questions)

**Q56. What is TestNG and how does it differ from JUnit?**  
Richer annotations, groups, dependencies, parallelism, DataProvider, suites.

**Q57. TestNG annotations lifecycle.**  
`@BeforeSuite`, `@BeforeTest`, `@BeforeClass`, `@BeforeMethod`, `@Test`, and corresponding `@After*`; know scope/frequency.

**Q58. `@Test` attributes (`invocationCount`, `timeOut`, `expectedExceptions`, `description`, `enabled`, `dependsOnMethods`, `alwaysRun`, `priority`).**

**Q59. TestNG assertions vs standard.**  
Hard assertions stop on failure; SoftAssert collects then `assertAll()`.

**Q60. DataProvider for parameterization.**  
Returns Object[][] / Iterator<Object[]>; supports parallel, external data (CSV/JSON/DB).

**Q61. testng.xml configuration and execution.**  
Define suites/tests/classes/methods, params, groups; run via `testng.xml` or Maven Surefire.

**Q62. Listeners (ITestListener, ISuiteListener, etc.).**  
Implement for hooks like onTestStart/Success/Failure; use for screenshots, logging, reporting; register in XML or programmatically.

**Q63. Test grouping and running specific groups.**  
Use `groups` on @Test; include/exclude in XML or via `-Dgroups`.

**Q64. Parallel execution in TestNG.**  
Parallel at suite/test/class/method/instances; configure `parallel` and `thread-count` in XML or Surefire; ensure thread-safe WebDriver (ThreadLocal).

**Q65. Test dependencies with `dependsOnMethods` and `alwaysRun`.**

**Q66. Reporting: built-in + ExtentReports/Allure integration.**

**Q67. Soft vs hard assertions (SoftAssert vs Assert).**

**Q68. `@DataProvider` attributes (name, parallel, context/method params).**

**Q69. Skipping tests (`enabled=false`, `SkipException`, XML exclude, conditional in hooks).**

**Q70. Suite/Test/Class/Method hooks (`@BeforeSuite`, `@AfterSuite`, `@BeforeTest`, `@AfterTest`).**

**Q71. @Test attributes: priority, groups, alwaysRun, timeOut, dependsOn, description.**

---

## Section 5: Cucumber BDD (16 Questions)

**Q72. What is Cucumber/BDD? Gherkin syntax.**  
Feature/Scenario/Scenario Outline, Given/When/Then/And/But, Background, Examples.

**Q73. Step definitions creation.**  
Map steps with annotations (`@Given`, `@When`, `@Then`); parameter types; use Page Objects.

**Q74. Hooks (@Before/@After) and tag-specific hooks with order.**  
Use for setup/teardown; attach screenshots on failure.

**Q75. Tags and running specific tags.**  
Tag expressions: `@smoke`, `@smoke or @regression`, `@smoke and @critical`, `not @skip`.

**Q76. Data Tables usage.**  
`DataTable` to maps/lists/custom objects; single/multi-column tables.

**Q77. Scenario Outline with Examples.**  
Template-driven scenarios; placeholders `<var>` replaced by Examples rows.

**Q78. Cucumber runner configuration.**  
`@CucumberOptions` with features, glue, plugins (pretty/html/json/junit/allure), tags, dryRun, monochrome, snippets.

**Q79. Background steps execution.**  
Common setup before each scenario in a feature.

**Q80. Passing parameters in steps (string/int/float/double/word/regex/DataTable).**

**Q81. Cucumber reports (HTML/JSON/JUnit/Allure) and plugin setup.**

**Q82. Skipping scenarios (tags + `SkipException` + tag filters).**

**Q83. World/Context object for shared state (PicoContainer DI).**

**Q84. Parallel execution in Cucumber (TestNG runners, multiple runners, Surefire/Failsafe).**

**Q85. Step definition best practices (single responsibility, POM, no hardcoded waits, logging, reuse).**

---

## Section 6: REST API Automation (16 Questions)

**Q86. REST API principles & HTTP methods (idempotence, CRUD mapping).**

**Q87. RestAssured basics (given/when/then; baseURI; GET/POST/PUT/DELETE).**

**Q88. HTTP status codes (200/201/204/400/401/403/404/405/500/502/503).**

**Q89. JSON/XML parsing (JsonPath, XmlPath), arrays, nested objects.**

**Q90. Headers & auth (Bearer, Basic, OAuth2), RequestSpec/ResponseSpec, API keys.**

**Q91. JSON Schema validation (`json-schema-validator` module; file or inline schemas).**

**Q92. Content types (JSON, XML, form-url-encoded, multipart).**

**Q93. Parameterization/data-driven API tests (DataProvider, CSV/JSON external data).**

**Q94. Request/response logging (filters, conditional logging, log to file/custom filters).**

**Q95. Timeouts, retries, error handling (socket/connect timeouts, retry analyzer/manual retries, handling 4xx/5xx).**

**Q96. SOAP vs REST; SOAP testing (SOAPMessage; or RestAssured with XML + XPath).**

---

## Section 7: Common Framework Design & Best Practices (10 Questions)

**Q97. Test automation framework architecture (layered: execution → framework → business/page/steps → utilities → AUT).**  
Driver manager, config reader, base test, page objects, utilities, reporting/logging.

**Q98. Page Object Model importance (maintainability, reuse, readability).**  
Encapsulate locators/actions; return next page objects; handle waits inside page methods.

**Q99. CI/CD integration.**  
Jenkins/GitHub Actions pipelines: build → unit → integration/API → UI smoke/regression → reports → deploy; headless, artifacts, notifications.

**Q100. Best practices for scalable/maintainable frameworks.**  
Modular structure, centralized config, data-driven, robust waits, logging, screenshots, reusable utilities, version control hygiene, code quality tools (Sonar, Jacoco), documentation.

**Bonus Q101–Q105 (from design/best-practices):**  
- **Q101. Cross-browser testing** via TestNG params and driver factory.  
- **Q102. Environment management** using enums/profiles/props.  
- **Q103. Custom assertions/validations** utilities.  
- **Q104. Reporting with screenshots/logs** (Extent/Allure + logger).  
- **Q105. Test data management & cleanup** (DB helpers, factories, teardown).

---

*Use this guide as a concise Markdown reference for experienced automation testers preparing for interviews across Selenium, Java, TestNG, Cucumber BDD, API testing, and framework design.* 

