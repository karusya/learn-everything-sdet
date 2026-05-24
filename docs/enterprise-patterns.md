# Enterprise Patterns

The design patterns covered earlier — creational, structural, behavioral — focus on how individual objects are built, composed, and interact. **Enterprise patterns** zoom out one level: they describe how to organize the **business logic of an application** itself.

These patterns come from the world of long-lived business applications, where the same data flows through many layers (UI, services, database) and the business rules are the thing that actually has to stay correct over years of change. The classic catalog is Martin Fowler's *Patterns of Enterprise Application Architecture*.

The first two patterns to understand are the two ends of a spectrum: **Transaction Script** (procedural, simple) and **Domain Model** (object-oriented, rich). We'll start with Transaction Script.

---

## Transaction Script

### Definition

The **Transaction Script** pattern **organizes business logic by procedures**, where **each procedure handles a single request from the presentation layer**.

A "transaction" here means a logical unit of work the user requests — *place an order*, *transfer funds*, *register a user*, *cancel a booking*. For each such request, you write **one procedure** that does the whole job from start to finish: reads input, runs the business rules, talks to the database, and returns a result.

There's no rich object model behind the scenes — just data structures and procedures that operate on them.

### Applicability

Transaction Script is a great fit for situations where speed and simplicity matter more than long-term structural sophistication:

- **Quick prototypes and proof-of-concept work.** When the goal is to demonstrate an idea or validate an assumption, you don't want to spend a week designing an object model. A few transaction scripts get something running fast.
- **CRUD-heavy applications.** Internal tools, admin panels, and many SaaS dashboards spend most of their time reading data, applying a small rule or two, and writing it back. Each create/read/update/delete operation is a natural transaction script.
- **Data transformation pipelines.** ETL jobs, import/export scripts, and batch processors are essentially long sequences of "read this, transform it, write it." A procedural, top-to-bottom script matches that flow almost exactly.

### When to use it

Reach for Transaction Script when:

- **Business logic is simple and each operation is independent.** No web of shared rules between use cases; each request can be handled on its own.
- The team is comfortable with **procedural coding** and doesn't need (or want) the indirection of a rich domain model.
- The application is dominated by **CRUD operations** — most requests boil down to "read these rows, change a value, write them back."
- You're shipping a **quick MVP** and need to get the first version of the product into users' hands before investing in deeper architecture.

It's also the right choice for small admin tools, internal scripts, and the early stages of any system whose business rules are still simple.

### How it's organized

The structure is intentionally flat:

1. The **presentation layer** (controller, route handler) receives a request.
2. It calls **one Transaction Script** — a single function or method that corresponds to that request.
3. The script does **everything needed** to fulfill the request:
   - validates input
   - applies business rules
   - reads and writes data through some data-access mechanism
   - returns a response
4. The script returns; the controller formats the response and sends it back.

Each transaction script is **self-contained**. They sit side by side in a service or module, with little or no shared state.

### Example (Python) — placing an order

```python
def place_order(user_id: int, product_id: int, quantity: int) -> dict:
    # 1. Validate input
    if quantity <= 0:
        raise ValueError("Quantity must be positive")

    # 2. Read data the operation needs
    user = db.find_user(user_id)
    product = db.find_product(product_id)
    if product.stock < quantity:
        raise ValueError("Insufficient stock")

    # 3. Apply business rules
    total = product.price * quantity
    if user.is_premium:
        total *= 0.9  # 10% discount for premium users

    # 4. Write data
    order_id = db.insert_order(user_id, product_id, quantity, total)
    db.decrement_stock(product_id, quantity)

    # 5. Return a result
    return {"order_id": order_id, "total": total}
```

Everything the "place order" use case needs lives in one procedure. There's no `Order` class with methods, no `User.applyDiscount()`, no abstraction layer — just the steps, in order. Another transaction script (`cancel_order`, `refund_order`) would sit beside it, doing its own job from top to bottom.

### Pros

The pattern is **easy to understand**: a developer can read one procedure and see the entire flow of a business operation in one place. There's almost no upfront design — you don't need to model a domain before you can ship the first feature. It scales well with team size when each developer can own one or two scripts. For applications whose rules are simple and stable, it's hard to beat in terms of clarity and speed.

### Limitations

Transaction Script falls apart as business logic grows. The same rule (a discount calculation, a validation, a status transition) gets **duplicated across many scripts**. As scripts grow, they accumulate conditional branches and become long and hard to test. There's no obvious place for shared concepts to live — `User`, `Order`, `Product` are just bags of data, not objects with behavior. At some point, the cost of duplication exceeds the cost of building a proper **Domain Model**, and the codebase starts to feel like it's fighting back.

A common rule of thumb: start with Transaction Script when the rules are simple; migrate to a Domain Model when the same logic starts showing up in more than two or three scripts.

### Key takeaway

Transaction Script organizes business logic as **one procedure per use case**. It's the simplest possible structure for application logic — perfect for straightforward operations, problematic once the rules get rich enough that the same logic needs to live in many places at once.
