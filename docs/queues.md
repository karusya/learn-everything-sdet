# Queues

## What is a Queue?

A queue is a linear data structure similar to a stack, but it follows a **FIFO** (First In, First Out) approach — the first element added is the first one removed.

Think of it like a line of people: the first person to join the line is the first to be served.

---

## Relation to Arrays

Queues overlap conceptually with arrays — both store ordered sequences of elements. The difference is the **access pattern**: a queue only allows insertion at the back and removal from the front, whereas an array allows arbitrary access.

---

## Implementation

The easiest and most efficient way to implement a queue is with a **singly linked list**, using two pointers:

- `left` — points to the front of the queue (dequeue end)
- `right` — points to the back of the queue (enqueue end)

---

## Core Operations

### Enqueue

Inserts an element at the **end** of the queue. Runs in **O(1)** time.

```javascript
enqueue(val) {
    const newNode = new ListNode(val);
    if (this.right != null) {
        // Queue is not empty
        this.right.next = newNode;
        this.right = this.right.next;
    } else {
        // Queue is empty
        this.left = newNode;
        this.right = newNode;
    }
}
```

### Dequeue

Removes and returns the element from the **front** of the queue. Runs in **O(1)** time.

```javascript
dequeue() {
    if (this.left == null) {
        // Queue is empty
        return;
    }
    // Remove left node and return value
    const val = this.left.val;
    this.left = this.left.next;
    if (!this.left) {
        this.right = null;
    }
    return val;
}
```

> **Good practice:** always check if the queue is empty before dequeuing — similar to stacks, operating on an empty queue should be handled gracefully.

---

## Complexity

| Operation | Time |
|-----------|------|
| Enqueue   | O(1) |
| Dequeue   | O(1) |
| Peek      | O(1) |
| Search    | O(n) |

---

## Queue vs Stack

| | Queue | Stack |
|---|---|---|
| Order | FIFO — first in, first out | LIFO — last in, first out |
| Insert | Back (`enqueue`) | Top (`push`) |
| Remove | Front (`dequeue`) | Top (`pop`) |
| Example | Waiting line | Undo history |

---

## Use Cases

- **BFS (Breadth-First Search)** — queues are the backbone of level-by-level graph/tree traversal
- **Task scheduling** — OS process queues, print spoolers
- **Streaming / buffers** — data producers and consumers operating at different speeds
- **Sliding window problems** — deque (double-ended queue) variant used in many algorithms
