# Heaps

## What a heap is

A **heap** is a specialized **tree-based data structure**. It's the standard way to implement an abstract data type called the **Priority Queue**.

To understand what makes a heap interesting, it helps to compare it to a regular queue:

- A **queue** operates **First-In-First-Out (FIFO)** — whoever joined the line first gets served first.
- A **priority queue** doesn't care about the order items were added — items are **removed by priority**. The element with the **highest priority** is always removed first, regardless of when it arrived.

Think of a hospital emergency room. People don't get seen in the order they walked in; they get seen based on how serious their condition is. That's a priority queue. A heap is the data structure that makes this fast.

## Heap properties

A heap is a **complete binary tree** (every level filled from left to right, with the last level possibly partially filled) that obeys one extra rule about how parents and children are ordered. That rule comes in two flavors, giving us the two types of heap.

### Min heap

In a **min heap**, the **smallest element is always on top** (at the root of the tree), and that smallest element is the first to be removed.

More precisely: **every parent node is less than or equal to its children**. The smallest value in the entire heap therefore "bubbles up" to the root.

```
        1
       / \
      3   5
     / \  /
    7  8 9
```

`1` is the minimum. The next smallest values sit close to the top. The biggest values live in the leaves.

### Max heap

In a **max heap**, the **biggest element is always on top** (at the root), and that biggest element is the first to be removed.

More precisely: **every parent node is greater than or equal to its children**. The largest value in the entire heap bubbles up to the root.

```
        9
       / \
      8   5
     / \  /
    7  3 1
```

`9` is the maximum. Big values dominate the top of the tree; small values live in the leaves.

## What a heap is *not*

It's worth noting two things heaps **don't** do:

- A heap is **not sorted** — only the parent/child relationship is enforced. Looking at a min heap, you can't tell which element is the second-smallest just by looking at the root's children.
- A heap is **not a binary search tree** — in a BST, left children are smaller and right children are larger, supporting efficient *search*. A heap only knows about the root, not about ordering across subtrees.

A heap is optimized for one job: **get the highest-priority element, fast**.

## Why this structure is fast

Because the structure is a complete binary tree, its height is always `O(log n)`. The two important operations both take advantage of this:

- **Insert** an element: `O(log n)` — add it at the bottom, then "bubble up" to restore the heap property.
- **Remove the top** (the min or the max): `O(log n)` — replace the root with the last element, then "sink down" to restore the heap property.
- **Peek at the top** (look without removing): `O(1)` — it's always at the root.

This is why heaps are the standard implementation of priority queues. No other structure gives you "remove the most important element" in logarithmic time so cheaply.

## How heaps are stored in memory

Even though we draw heaps as trees, they're almost always stored as a **simple array** — no actual tree nodes, no pointers. For a node at index `i`:

- Its **parent** is at index `(i − 1) / 2` (integer division).
- Its **left child** is at index `2i + 1`.
- Its **right child** is at index `2i + 2`.

So the min heap drawn above becomes:

```
index:  0  1  2  3  4  5
value: [1, 3, 5, 7, 8, 9]
```

Index `0` (the root) is `1`. Its children are at indices `1` and `2` (`3` and `5`). And so on. This compact representation is part of why heaps are so efficient: no pointer chasing, just arithmetic on array indices.

## Where heaps show up

Heaps are everywhere once you know to look for them:

- **Priority queues** in operating system schedulers, networking, simulation.
- **Heap sort** — sort by repeatedly removing the top.
- **Dijkstra's** and **Prim's** algorithms — pick the next cheapest edge or path.
- **Top-K problems** — find the K largest/smallest elements in a stream.
- **Median-of-stream** — keep two heaps balanced to track the running median.

## Key takeaway

A **heap** is a complete binary tree with one rule about parent/child order. It's the canonical implementation of a **priority queue**, where elements are removed by importance rather than arrival order. A **min heap** keeps the smallest element on top; a **max heap** keeps the largest. Both support insert and remove-top in **O(log n)** and peek in **O(1)**, which is what makes them indispensable whenever the question is *"what's the next most important thing?"*
