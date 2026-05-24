# Structural Design Patterns

Where **creational patterns** focus on *how objects are made*, **structural patterns** focus on *how objects are composed* — how classes and instances are arranged into larger structures while keeping those structures flexible and efficient.

Real-world systems are made of components from many different sources: third-party libraries, legacy modules, external APIs, services from other teams. These pieces rarely share the same shape. Structural patterns give us proven ways to fit them together: bridging mismatched interfaces, sharing common state efficiently, layering behavior without subclassing, and exposing simple façades over complex subsystems.

In this section, we'll cover the **Adapter** pattern first.

---

## Adapter

### The problem

Real-world components often need to **work together even when they were not designed to**.

You buy a new library, integrate a third-party API, or pull in a legacy module — and its interface doesn't match what the rest of your code expects. The method names are different, the argument shapes are different, the return types are different. Rewriting one side to match the other is risky (you may not own the code) or expensive (you'd have to change every caller).

### What the Adapter pattern does

The **Adapter pattern** is a **structural design pattern** that allows **incompatible interfaces to work together**.

It acts as a **bridge between two unrelated components**, translating one interface into another. Crucially, **we do not modify the existing code** — instead, we **introduce an adapter** that sits between the two sides and handles the conversion.

The metaphor is exactly what it sounds like: an Adapter is the **power adapter between a plug and a socket**. The wall socket doesn't change. Your appliance doesn't change. The adapter just translates one shape into the other so both can do their job.

### When to use

Reach for Adapter when:

- You need to use an existing class but its interface doesn't match what your code expects.
- You want to integrate a **third-party library** or **legacy system** without modifying its source.
- You're migrating between two APIs and want to keep callers working with the old shape while the new implementation lives underneath.
- Multiple incompatible classes need to be made interchangeable behind a common interface.

### Structure of the Adapter pattern

The pattern has four roles:

1. **Client** — the code that **expects a specific interface**. It has already been written and shouldn't have to change just because a new component shows up.
2. **Target** — the **interface the client is written against**. This is the shape the client knows how to call: the methods, signatures, and types it speaks.
3. **Adaptee** — the **existing class with the incompatible interface**. It does the work you want, but its API doesn't match what the client expects. This is the "plug" with the wrong prongs.
4. **Adapter** — the new class that **implements the Target interface and translates calls to the Adaptee**. It accepts calls in the Target's shape and forwards them, reshaped, to the Adaptee. This is the physical adapter sitting between plug and socket.

Diagrammatically:

```
Client  --->  Target (interface)  <---  Adapter  --->  Adaptee
                                       (translates)
```

The client speaks **Target**. The Adapter accepts Target-shaped calls and speaks **Adaptee** behind the scenes — without the client or the adaptee ever needing to know about each other.

### Example (Python) — object adapter

Suppose your app already works with a `PaymentProcessor` interface, but you want to integrate a third-party gateway whose API looks completely different.

```python
from abc import ABC, abstractmethod

# --- Target: what the client expects ---
class PaymentProcessor(ABC):
    @abstractmethod
    def pay(self, amount: float, currency: str) -> str: ...


# --- Adaptee: existing third-party class, incompatible interface ---
class StripeGateway:
    def make_charge(self, cents: int, iso_currency: str) -> dict:
        # Different method name, different argument shape, different return type
        return {"status": "ok", "id": "stripe_123", "amount_cents": cents}


# --- Adapter: implements Target, wraps Adaptee, translates between them ---
class StripeAdapter(PaymentProcessor):
    def __init__(self, gateway: StripeGateway):
        self._gateway = gateway

    def pay(self, amount: float, currency: str) -> str:
        cents = int(amount * 100)                       # translate dollars -> cents
        result = self._gateway.make_charge(cents, currency.upper())
        return result["id"]                             # translate dict -> id string


# --- Client: speaks only Target ---
def checkout(processor: PaymentProcessor):
    txn_id = processor.pay(19.99, "usd")
    print(f"Charged. Transaction: {txn_id}")


checkout(StripeAdapter(StripeGateway()))
# Charged. Transaction: stripe_123
```

Notice three things:

- `StripeGateway` was **not modified**. Even if it lived in a third-party library, the adapter would still work.
- `checkout` was **not modified**. It only knows about `PaymentProcessor`.
- All the translation logic (dollars → cents, lowercase → uppercase currency, dict → id) lives in **one place**: the adapter.

Swap in a `PayPalAdapter` later, and `checkout` doesn't change at all.

### Two flavors: object adapter vs class adapter

- **Object adapter** (the example above) — the adapter **holds a reference** to the adaptee and forwards calls to it. Works in every language. Uses composition.
- **Class adapter** — the adapter **inherits from both** the target and the adaptee. Only possible in languages with multiple inheritance (or via interfaces + a single base class). Less flexible because the inheritance is fixed at compile time.

Object adapters are the more common and more portable choice.

### Pros

Adapter lets you reuse existing code — including third-party and legacy components — without modifying it. Translation logic is **isolated in one class**, making it easy to maintain, test, and replace. The client stays focused on its own abstraction (the Target) and is shielded from the messy details of the Adaptee. New incompatible implementations can be added simply by writing another adapter.

### Limitations

Each adapter introduces an **extra layer of indirection** — one more class to read through when debugging. Heavy use of adapters across a codebase can hide the actual shape of the underlying systems, making it harder to see what's really being called. When you control both sides of the interface, it's often cleaner to fix the interface directly rather than paper over the mismatch with an adapter.

### Key takeaway

The Adapter pattern **enables collaboration** between components that were never designed to work together. It keeps **client code clean and stable** — the client doesn't change, and the adaptee doesn't change. It **improves reusability and reduces coupling** by isolating translation logic in one well-defined place, and it **supports the Open/Closed Principle**: new incompatible components can be brought into the system simply by writing another adapter, without modifying any existing code.

In short, Adapter is the **plug-and-socket pattern** — a small piece of glue that lets two parts that were never designed to meet work together cleanly.

---

## Composite

### The problem

Many real-world systems are naturally **tree-shaped**: a file system has folders containing files and other folders; a UI is made of panels containing buttons, labels, and more panels; an organization chart has departments containing employees and sub-departments.

When code has to work with these structures, it often ends up full of type checks — *"is this a folder or a file?"*, *"is this a group or a single item?"* — and the logic for handling each case starts to diverge and duplicate. The Composite pattern is the way out.

### What the Composite pattern does

The **Composite design pattern** lets you compose objects into **tree-like structures** and then **treat individual objects and groups of objects uniformly**.

A single leaf and a whole branch share the same interface, so client code can call the same method on either one without caring which it has. The tree itself takes care of recursing into its children.

### Core components of the pattern

There are **three key parts**:

1. **Component** — defines a **common interface** for **all objects in the hierarchy**. Both leaves and composites implement this interface, which is what makes them interchangeable from the client's point of view. Typical operations: `render()`, `size()`, `price()`, `execute()`.
2. **Leaf** — represents a **simple, indivisible object** that **implements the interface directly**. It has no children. It just does the work for itself (e.g., a single file, a single button, an individual employee).
3. **Composite** — represents a **complex object that can contain other components** (leaves or other composites). It implements the same interface as a leaf, but its implementation typically **delegates** by iterating over its children and combining their results.

Diagrammatically:

```
                Component (interface)
                /                \
             Leaf              Composite
                                  |
                                  +-- children: [Component, Component, ...]
```

Because `Composite` holds a list of `Component`s — not specifically leaves — a composite can contain other composites, and the tree can be arbitrarily deep.

### Example (Python) — file system

A classic example: files and folders, where both expose a `size()` method.

```python
from abc import ABC, abstractmethod

# --- Component: common interface for everything in the tree ---
class FileSystemItem(ABC):
    @abstractmethod
    def size(self) -> int: ...

# --- Leaf: a single file, no children ---
class File(FileSystemItem):
    def __init__(self, name: str, size: int):
        self.name = name
        self._size = size

    def size(self) -> int:
        return self._size

# --- Composite: a folder that contains other items ---
class Folder(FileSystemItem):
    def __init__(self, name: str):
        self.name = name
        self._children: list[FileSystemItem] = []

    def add(self, item: FileSystemItem):
        self._children.append(item)

    def size(self) -> int:
        # Delegates to children — works whether each child is a File or a Folder
        return sum(child.size() for child in self._children)


# Build a tree
root = Folder("root")
root.add(File("readme.md", 200))

docs = Folder("docs")
docs.add(File("intro.md", 500))
docs.add(File("guide.md", 1500))

root.add(docs)

# Client treats leaves and composites the same way
print(root.size())   # 2200
print(docs.size())   # 2000
```

The client never asks *"is this a File or a Folder?"* — it just calls `.size()`. The composite handles recursion internally.

### Why use the Composite pattern

- **Organizes objects into clear tree-like structures.** The pattern matches the real shape of hierarchical data, making the design easy to reason about.
- **Allows uniform treatment of individual objects and collections.** Client code can call the same methods on a leaf or on a whole subtree, with the same return type and the same semantics.
- **Simplifies client code by eliminating type checks and conditionals.** No more `if isinstance(x, Folder): ... else: ...` — the polymorphism does that work.
- **Supports the Open/Closed Principle.** New kinds of components (a new type of leaf, a new kind of composite) can be added without changing existing client code, as long as they implement the same `Component` interface.

### When to use

Use Composite when you have a part-whole hierarchy and you want clients to be able to ignore the difference between single objects and compositions of objects. Common cases: file systems, UI component trees, scene graphs in graphics engines, document structures (sections containing paragraphs containing words), nested menus, organization charts, and expression trees.

### Limitations

The pattern can make the design **overly general** — if "everything" implements the same interface, you may end up with methods on the Component that only make sense for composites (like `add` / `remove`), or only for leaves. Some implementations put those methods on the Component for uniformity (at the cost of safety), others restrict them to Composite (at the cost of pure interchangeability). Both choices have trade-offs.

### Key takeaway

Composite answers the question *"How do I treat one thing and many things the same way?"* It captures part-whole hierarchies in a single shared interface so that recursion through the tree becomes invisible to the caller — leaves and branches just look like *components*.

---

## Decorator

### The problem

Sometimes you want to add behavior to a single object — not to every instance of its class, not to a subclass, just to *this one object, in this one situation*. Subclassing doesn't fit: it locks the choice in at design time, multiplies classes for every possible combination of features, and quickly becomes unmaintainable when behaviors need to be mixed and matched at runtime.

### What the Decorator pattern does

The **Decorator design pattern** is a **structural design pattern** that allows **behaviors to be added to individual objects dynamically**, **without modifying the original code**.

It uses **composition over inheritance**: instead of extending a class, you **wrap an object inside another object** — the decorator — that adds new behavior **before or after delegating** to the original. Because decorators **implement the same interface** as the objects they wrap, they're interchangeable with them, and they can be stacked: a decorator can wrap another decorator, which wraps another, and so on.

Each layer adds one responsibility. Combine layers and you compose behavior at runtime.

### Core components of the pattern

1. **Component** — defines the **common interface** that both the base object and its decorators implement. This is what makes wrapping transparent to clients.
2. **Concrete Component** — the **base object with minimal functionality**. It implements the Component interface and does the actual core work. Decorators will wrap instances of this.
3. **Decorator** — the **wrapper that holds a reference to a Component and delegates work to it**. It implements the same Component interface, so from the outside it looks like the thing it wraps. By itself it doesn't add behavior — it just forwards calls.
4. **Concrete Decorators** — extend the base Decorator and **add specific behavior** before or after delegating to the wrapped component (e.g., logging, caching, encryption, formatting, access checks).

Diagrammatically:

```
                Component (interface)
                /                  \
        ConcreteComponent          Decorator (wraps a Component)
                                       |
                                       +-- ConcreteDecoratorA  (adds behavior X)
                                       +-- ConcreteDecoratorB  (adds behavior Y)

Stacking:  ConcreteDecoratorA( ConcreteDecoratorB( ConcreteComponent() ) )
```

### Example (Python) — coffee shop

A classic example: a base drink whose price and description are extended by stackable "add-ons."

```python
from abc import ABC, abstractmethod

# --- Component: common interface ---
class Beverage(ABC):
    @abstractmethod
    def cost(self) -> float: ...
    @abstractmethod
    def description(self) -> str: ...

# --- Concrete Component: base object with minimal functionality ---
class Espresso(Beverage):
    def cost(self) -> float: return 2.50
    def description(self) -> str: return "Espresso"

# --- Decorator: wraps a Beverage, delegates by default ---
class BeverageDecorator(Beverage):
    def __init__(self, wrapped: Beverage):
        self._wrapped = wrapped
    def cost(self) -> float:        return self._wrapped.cost()
    def description(self) -> str:   return self._wrapped.description()

# --- Concrete Decorators: each adds one specific behavior ---
class Milk(BeverageDecorator):
    def cost(self):        return self._wrapped.cost() + 0.50
    def description(self): return self._wrapped.description() + ", milk"

class Sugar(BeverageDecorator):
    def cost(self):        return self._wrapped.cost() + 0.20
    def description(self): return self._wrapped.description() + ", sugar"

class WhippedCream(BeverageDecorator):
    def cost(self):        return self._wrapped.cost() + 0.70
    def description(self): return self._wrapped.description() + ", whipped cream"


# Stack decorators at runtime to compose behavior
drink = WhippedCream(Sugar(Milk(Espresso())))
print(drink.description())  # Espresso, milk, sugar, whipped cream
print(f"${drink.cost():.2f}")  # $3.90
```

A few things to notice:

- `Espresso` was never modified to know about milk, sugar, or cream.
- Each decorator adds **one** responsibility. Combinations (milk + sugar, milk + cream, sugar + cream + extra sugar) are created at runtime by composition, not by writing new subclasses.
- The client variable `drink` is typed as `Beverage`. The fact that it happens to be wrapped three times is invisible to whatever uses it.

### Why use the Decorator pattern

- **Adds behavior dynamically, per-object, at runtime** — not at compile time and not for every instance of a class.
- **Composition over inheritance.** Avoids the "subclass explosion" you get when every combination of features needs its own class.
- **Single Responsibility Principle.** Each decorator handles one concern (logging, caching, validation, formatting) and can be developed, tested, and reused independently.
- **Open/Closed Principle.** New behaviors are added by writing new decorators, without touching the base component or the existing decorators.
- **Stackable and order-aware.** The order in which decorators are wrapped controls the order in which their behavior runs — which is exactly what you want for things like authentication → caching → logging.

### When to use

Reach for Decorator when:

- You want to add behavior to **specific objects** rather than to a whole class.
- You need behaviors that should be **combinable in arbitrary ways** at runtime.
- Subclassing would lead to a combinatorial explosion of classes.
- You want to keep optional features (logging, caching, compression, encryption) **separable from core logic**.

Real-world examples: I/O streams (buffered, gzipped, encrypted), HTTP middleware (auth, rate limiting, logging), UI component wrappers (scroll, border, shadow), and Python's own function decorators are an idiomatic form of this pattern.

### Limitations

A heavily decorated object can be hard to debug — a single method call may pass through several wrappers before reaching the concrete component, and stepping through them in a stack trace takes patience. The order of wrapping matters and isn't always obvious from reading the code. And because every decorator must conform to the Component interface, that interface tends to stay small; adding new methods later means updating every decorator.

### Key takeaway

Decorator answers the question *"How do I add behavior to **this specific object** without changing its class — and keep that behavior composable with other behaviors?"* It's the **wrapping pattern**: each layer adds one thing, the layers stack, and the wrapped object never knows it's been decorated.
