# Creational Design Patterns

Creational patterns offer structured, flexible approaches to **creating objects**. They define **how**, **when**, and **who** should create objects, separating creation logic from the code that uses those objects.

By isolating object construction, creational patterns make systems easier to extend, test, and refactor. The caller no longer needs to know which concrete class is being instantiated, what arguments it requires, or how its dependencies are wired together.

In this section, we cover three core creational patterns:

- **Singleton** — guarantees a single, shared instance.
- **Factory Method** — delegates instantiation to subclasses.
- **Builder** — assembles complex objects step by step.

---

<!-- markdownlint-disable MD022 MD024 MD025 MD031 MD032 MD033 MD037 MD009 MD012 -->

## Singleton

### Definition

The **Singleton design pattern** ensures that a class has **only one instance** and provides a **single, well-defined access point** to it.

In other words: no matter how many times you "create" the object, you always get back the same one. The class itself is responsible for guarding this uniqueness — clients don't have to coordinate to make sure they share an instance.

### Intent

- Restrict instantiation of a class to a single object.
- Provide a global access point to that object.
- Control access to a shared resource (configuration, log file, cache, connection pool).

### When to use

Use Singleton when exactly one object is needed to coordinate actions across the system — for example, a configuration manager, a logger, a database connection pool, a thread pool, or an in-memory cache. The pattern is appropriate when multiple instances would cause inconsistency, conflict, or unnecessary resource use.

### How it works

Singleton relies on **class variables** (also called **static variables**) — variables that belong to the class itself rather than to any one instance. Because they live on the class, they are **shared across every reference** to the class, which makes them the perfect place to store "the one instance."

A Singleton typically combines three mechanisms:

1. **A private/hidden constructor**, so external code cannot instantiate the class directly with `new`.
2. **A class (static) variable** inside the class that holds the single instance — shared across all attempts to construct it.
3. **A static access method** (often called `getInstance()`) that returns that variable — creating the instance lazily on the first call, then returning the same one forever after.

The first call constructs the object and stores it in the class variable; every subsequent call returns the existing reference.

### Why it's useful

Singleton **centralises and protects shared resources**. Instead of letting every part of the program create its own copy of a logger, config, cache, or connection pool — and risk inconsistent state or contention — the Singleton owns that resource and is the single gatekeeper through which all access flows. This makes shared state predictable and easier to coordinate.

### Example (Python)

```python
class ConfigManager:
    _instance = None  # the single stored instance

    def __new__(cls):
        # If no instance exists yet, create one. Otherwise, return the existing one.
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._settings = {}
        return cls._instance

    def set(self, key, value):
        self._settings[key] = value

    def get(self, key):
        return self._settings.get(key)


config_a = ConfigManager()
config_b = ConfigManager()

config_a.set("theme", "dark")
print(config_b.get("theme"))  # "dark"
print(config_a is config_b)   # True — same object
```

Even though we "constructed" `ConfigManager` twice, `config_a` and `config_b` reference the **same underlying object**. State set through one is visible through the other.

### Example (Java-style, for comparison)

```java
public class Logger {
    private static Logger instance;

    private Logger() { }  // private constructor

    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }

    public void log(String message) {
        System.out.println("[LOG] " + message);
    }
}

// Usage:
Logger.getInstance().log("Started");
```

The private constructor blocks `new Logger()` from outside the class — the only way in is through `getInstance()`.

### Thread safety

In multi-threaded environments, two threads could race past the `if (instance == null)` check at the same time and each create a new instance. Common fixes:

- **Synchronize** the `getInstance()` method (simple, but slower).
- **Double-checked locking** with a `volatile` field (faster, but trickier).
- **Eager initialization** — create the instance at class-load time, before any thread asks for it.
- **Enum-based singleton** (in Java) — the language guarantees a single instance.

### Pros

The pattern guarantees a **single, consistent point of access** to shared state, avoids the overhead of repeatedly constructing a heavy object, and centralizes lifecycle control of a shared resource.

### Limitations

Even when used correctly, Singleton has real drawbacks:

- **Introduces global state.** A Singleton is effectively a global variable dressed up as a class. Any part of the program can read or mutate it from anywhere, which makes program flow harder to reason about and bugs harder to trace.
- **Complicates testing.** Because the instance persists for the lifetime of the program, state leaks between tests. Tests can no longer run in isolation unless you add explicit reset logic, and mocking the Singleton requires extra plumbing.
- **Reduces flexibility.** Consumers are tightly coupled to the concrete Singleton class. Swapping in a different implementation (a fake for tests, a different config source, a second instance for a new tenant) requires changing every call site rather than just wiring a different object in.

Additional concerns: Singletons violate the Single Responsibility Principle — the class manages both its own logic *and* its own instantiation. In multi-threaded code, the instantiation step must be synchronized to avoid race conditions. Overuse of Singleton often signals that **dependency injection** would be a cleaner solution: pass the shared object in, rather than reaching for a global.

### Key takeaway

Singleton answers the question *"How many of this should exist?"* with **exactly one**, and gives the rest of the program a single, predictable handle to reach it.

---

## Factory Method

### Definition

The **Factory design pattern** resolves a common challenge in object-oriented design: **deciding which class to instantiate when an object is needed**.

Instead of scattering that decision across the codebase as `if`/`else` or `switch` blocks full of constructor calls, the Factory pattern introduces an **abstraction that owns object creation**. The calling code doesn't construct objects directly — it **asks the factory** to create one. This keeps **creation logic separate from business logic**.

A factory typically exposes a method (often called `create`) that returns the appropriate object — **selecting and creating** the right concrete type **based on its input**.

### Intent

- Encapsulate object creation behind a single, well-defined entry point.
- Let the caller request an object by *what it needs*, not by *which class implements it*.
- Make it easy to add new types without touching the code that uses them.

### When to use

At its core, **Factory means delegation** — the caller delegates the responsibility of "which class, with what arguments, in what configuration" to a dedicated component. Reach for a Factory when you want to:

- **Centralize and control object creation.** Keep all the rules for *how* an object is built in one place, so changes don't ripple through the codebase. The factory becomes the single owner of creation decisions.
- **Build a framework or library that hides creation complexity.** Users of your framework should call one clean method and get back a fully wired object — without knowing about the constructors, dependencies, or configuration steps involved behind the scenes.
- **Handle situations where the exact types or number of objects are not known until runtime.** When a payload, config file, user input, or plugin determines which class to instantiate, the factory inspects that input and produces the right object dynamically.
- **Decouple callers from concrete classes.** A class cannot — and should not — always anticipate the type of object it must create. The factory absorbs that decision so callers depend only on the abstraction.
- **Provide an extension point.** New product types can be added by extending the factory, without modifying any existing caller.

### How it works

The factory sits between the caller and the concrete classes:

1. The caller hands the factory some input — a string, an enum, a config object.
2. The factory inspects that input and **decides which concrete class** to instantiate.
3. The factory returns the new object, **typed as an abstract interface** so the caller doesn't depend on the concrete class.

Business logic stays focused on *using* the object; the factory takes the entire decision of *which* object to build.

### Example (Python) — simple factory with a `create` method

```python
from abc import ABC, abstractmethod

# --- Product hierarchy ---
class Notification(ABC):
    @abstractmethod
    def send(self, message: str) -> None: ...

class EmailNotification(Notification):
    def send(self, message): print(f"Email: {message}")

class SMSNotification(Notification):
    def send(self, message): print(f"SMS: {message}")

class PushNotification(Notification):
    def send(self, message): print(f"Push: {message}")


# --- Factory: selects + creates based on input ---
class NotificationFactory:
    @staticmethod
    def create(channel: str) -> Notification:
        if channel == "email":
            return EmailNotification()
        elif channel == "sms":
            return SMSNotification()
        elif channel == "push":
            return PushNotification()
        else:
            raise ValueError(f"Unknown channel: {channel}")


# --- Business logic doesn't know about concrete classes ---
def notify_user(channel: str, message: str):
    notification = NotificationFactory.create(channel)
    notification.send(message)


notify_user("email", "Welcome!")  # Email: Welcome!
notify_user("sms", "Code: 1234")  # SMS: Code: 1234
```

Notice the two key properties:

- `notify_user` never mentions `EmailNotification` or `SMSNotification`. It only knows about `Notification` (the abstraction) and `NotificationFactory.create` (the entry point).
- Adding a Slack channel means adding `SlackNotification` and one new branch in the factory — no caller has to change.

### Example (Python) — Factory Method variant

A more formal "Factory Method" version uses subclassing to decide the type, rather than a conditional inside one factory:

```python
class NotificationFactory(ABC):
    @abstractmethod
    def create(self) -> Notification: ...

    def notify(self, message: str) -> None:
        notification = self.create()
        notification.send(message)

class EmailFactory(NotificationFactory):
    def create(self): return EmailNotification()

class SMSFactory(NotificationFactory):
    def create(self): return SMSNotification()


EmailFactory().notify("Welcome!")  # Email: Welcome!
```

Each concrete factory subclass decides which product to build. This is the classic Gang of Four "Factory Method" — useful when the surrounding workflow (`notify`) is shared but the *type produced* varies.

### Pros

The Factory pattern removes direct `new`/constructor calls from business logic, **eliminating tight coupling** to concrete classes. Creation rules live in one place, so changes (renaming a class, swapping an implementation, adding caching around construction) happen there rather than across the codebase. It honors the **Open/Closed Principle**: new product types can be introduced by adding a new branch or subclass, without modifying existing callers.

### Limitations

The pattern adds an extra layer of indirection — a class or method whose only job is to build other objects. For small problems with only two or three product types that aren't expected to grow, this can feel heavyweight; a simple `if`/`else` or a dict mapping strings to constructors may be clearer. The "factory inside a factory" style (abstract factories with subclasses per product) can multiply classes quickly if applied too eagerly.

### Key takeaway

A Factory answers the question *"Which class should we instantiate?"* — and hides the answer behind a single method, so the rest of the code never has to ask.

---

## Builder

### Definition

The **Builder design pattern** separates the **construction** of a complex object from its **representation**, so the same construction process can produce different variants of the object.

It's the right tool when a class has **many optional parameters** that need to be **assembled step by step** based on configuration, user input, or runtime choices — rather than being passed all at once into a single, sprawling constructor.

### When to use

Use Builder when:

- An object has **many optional parameters**, and you don't want overloaded constructors or long positional argument lists.
- Construction needs to happen **step by step**, with each step driven by **config or user input**.
- The same building process should be able to produce **different representations** of the object (e.g., a "minimal" vs "full" version, JSON vs XML, dark theme vs light theme).
- Construction includes ordered steps, validation, or branching logic that doesn't belong in a constructor.

Configuration objects, HTTP request builders, SQL query builders, UI form builders, and document/report generators are classic Builder candidates.

### Builder vs Factory

These two patterns look similar — both hide object creation — but they answer different questions:

| | **Factory** | **Builder** |
|---|---|---|
| **Focus** | *Which* object to create | *How* the object is built |
| **Creation** | Creates the object in a **single step** | Creates the object **incrementally**, step by step |
| **Best for** | Picking between several known types based on input | Assembling one complex object out of many optional pieces |
| **Returns** | A fully-formed object immediately | The same builder (chainable), until `build()` is called |

In short: **Factory creates an object in a single step**, while **Builder creates it incrementally and focuses on how the object is built**.

### How it works — the four components

A canonical Builder implementation has four roles:

1. **Product** — the complex object that is being assembled. It usually has many fields, often immutable, and is sometimes valid only after all required steps are completed.
2. **Builder interface** — defines the **steps required** to build the product (e.g., `set_url()`, `add_header()`, `set_body()`). It declares *what* can be configured, not *how*.
3. **Concrete builders** — implement those steps to produce **specific variations** of the product (e.g., a `JsonRequestBuilder` vs an `XmlRequestBuilder`). Each concrete builder keeps its own internal state as construction progresses.
4. **Director** *(optional)* — controls the **order of building steps** to produce a particular configuration. The director knows *which steps to call and in what order*; the builder knows *how to execute each step*. The director is useful when you have standard "recipes" that should always produce the same shape of object.

The director + builder split means you can reuse the same building algorithm with different concrete builders to get different products — that's how "same process, different representation" actually works.

### Example (Python) — fluent builder

The simplest form of Builder: methods return `self`, so calls chain together until `build()` returns the finished product.

```python
class HttpRequest:
    def __init__(self, url, method, headers, body, timeout):
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.timeout = timeout

    def __repr__(self):
        return f"{self.method} {self.url} (timeout={self.timeout}s)"


class HttpRequestBuilder:
    def __init__(self):
        self._url = None
        self._method = "GET"
        self._headers = {}
        self._body = None
        self._timeout = 30

    def url(self, url):       self._url = url;       return self
    def method(self, method): self._method = method; return self
    def header(self, k, v):   self._headers[k] = v;  return self
    def body(self, body):     self._body = body;     return self
    def timeout(self, s):     self._timeout = s;     return self

    def build(self):
        if not self._url:
            raise ValueError("URL is required")
        return HttpRequest(
            self._url, self._method, self._headers, self._body, self._timeout
        )


request = (
    HttpRequestBuilder()
    .url("https://api.example.com/users")
    .method("POST")
    .header("Authorization", "Bearer token")
    .body({"name": "Karina"})
    .timeout(10)
    .build()
)

print(request)  # POST https://api.example.com/users (timeout=10s)
```

The same builder can produce a minimal `GET` or a fully configured `POST` — no overloaded constructors, no long positional argument lists.

### Example (Python) — Builder + Director

Here the **Director** owns the recipe (the order of steps), and different **Concrete Builders** plug in to produce different representations of the product.

```python
from abc import ABC, abstractmethod

# --- Product ---
class Report:
    def __init__(self):
        self.parts = []
    def __repr__(self):
        return " | ".join(self.parts)

# --- Builder interface: defines the steps ---
class ReportBuilder(ABC):
    @abstractmethod
    def add_title(self): ...
    @abstractmethod
    def add_body(self): ...
    @abstractmethod
    def add_footer(self): ...
    @abstractmethod
    def result(self) -> Report: ...

# --- Concrete builders: implement steps for specific variations ---
class PlainReportBuilder(ReportBuilder):
    def __init__(self): self._r = Report()
    def add_title(self):  self._r.parts.append("Title")
    def add_body(self):   self._r.parts.append("Body text")
    def add_footer(self): self._r.parts.append("Footer")
    def result(self):     return self._r

class HtmlReportBuilder(ReportBuilder):
    def __init__(self): self._r = Report()
    def add_title(self):  self._r.parts.append("<h1>Title</h1>")
    def add_body(self):   self._r.parts.append("<p>Body text</p>")
    def add_footer(self): self._r.parts.append("<footer>Footer</footer>")
    def result(self):     return self._r

# --- Director: controls the order of building steps ---
class ReportDirector:
    def __init__(self, builder: ReportBuilder):
        self._builder = builder

    def build_full_report(self) -> Report:
        self._builder.add_title()
        self._builder.add_body()
        self._builder.add_footer()
        return self._builder.result()


# Same recipe, two different representations:
print(ReportDirector(PlainReportBuilder()).build_full_report())
# Title | Body text | Footer

print(ReportDirector(HtmlReportBuilder()).build_full_report())
# <h1>Title</h1> | <p>Body text</p> | <footer>Footer</footer>
```

The Director never changes. Swap the concrete builder, get a different product — that's the Builder pattern's full power.

### Pros

Builder turns sprawling constructors into a readable, self-documenting fluent interface. It supports immutable target objects, lets construction logic validate state before producing the final object, and cleanly handles many optional fields. With a Director, the same building process can produce multiple representations of the product.

### Limitations

Builder adds a second class (and sometimes a third — the Director) for every product, which is overkill when the target object has only a handful of fields. In languages with named arguments or default parameters (like Python or Kotlin), a builder is often unnecessary — the language already solves the "many optional parameters" problem at the call site.

### Key takeaway

Builder answers the question *"How should this object be assembled?"* It trades a single, hard-to-read constructor for a clear, step-by-step process — and lets you swap in different recipes or representations without rewriting the assembly logic.

---

## Choosing between them

A useful way to keep these straight:

- Reach for **Singleton** when *how many* instances exist matters more than *how* they're built.
- Reach for **Factory Method** when *which type* of object to create is the question, and the answer should be extensible.
- Reach for **Builder** when *how* an object is assembled is the hard part — many fields, ordered steps, or multiple representations.

In the next section, we'll look at **structural patterns**, which focus on how objects and classes are composed into larger structures.
