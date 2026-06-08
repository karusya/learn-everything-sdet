# Linked Lists

## What a linked list is

A **linked list** is similar to an array in that it stores information in an **ordered sequence**. The main difference is in *how* that sequence is stored:

- An **array** lays its elements out in a contiguous block of memory, accessed by index (`arr[3]`).
- A **linked list** stores its elements as **separate objects** called **list nodes**, where each node holds a value and a **reference to the next node**.

Instead of "the third element" being a fixed memory offset, it's "the node you arrive at after following two `next` pointers from the start."

## The list node

A **list node** has just two attributes:

- **`value`** — stores the value of the node. It can be anything: a character, an integer, a string, an object.
- **`next`** — stores a **reference to the next node** in the linked list. If there is no next node, `next` is `null`.

```javascript
class ListNode {
    constructor(value) {
        this.value = value;
        this.next = null;
    }
}
```

That's it — two fields per node. Build a list by linking nodes together through their `next` pointers.

## What a linked list looks like

A linked list `1 → 2 → 3` is three separate `ListNode` objects whose `next` pointers form a chain:

```
[ value: 1 ] --> [ value: 2 ] --> [ value: 3 ] --> null
  next  ─────────┘  next  ─────────┘  next ───── null
```

Two pieces of vocabulary you'll see constantly:

- **Head** — the **first** node in the list. The list is usually identified by its head: if you have the head, you can reach every other node by following `next` pointers.
- **Tail** — the **last** node, the one whose `next` is `null`. (Some implementations track a tail pointer; many don't.)

If the head itself is `null`, the list is empty.

## Building a linked list by chaining nodes

**By chaining `ListNode` objects together, we can build a linked list.** The whole structure exists because of one mechanism: each node's `next` pointer references the next node in the sequence.

We start with the `ListNode` class:

```javascript
class ListNode {
    constructor(value) {
        this.value = value;
        this.next = null;
    }
}
```

Then we create the individual node objects and wire them up. Suppose we have three list nodes — `ListNode1`, `ListNode2`, `ListNode3`:

```javascript
const ListNode1 = new ListNode(1);
const ListNode2 = new ListNode(2);
const ListNode3 = new ListNode(3);

ListNode1.next = ListNode2;   // first node points to the second
ListNode2.next = ListNode3;   // second node points to the third
ListNode3.next = null;        // last node points to null — end of the list
```

That's the whole construction. Three independent `ListNode` objects get chained into a single linked list just by reassigning the `next` pointers. The list is now `1 → 2 → 3 → null`, and `ListNode1` is the **head**.

A few details worth noticing:

- We have to **make sure the `next` of the last node is `null`** (or rely on the constructor having set it to `null` already). Without that, traversal has no way to know it's reached the end.
- The order in which we create the nodes doesn't matter; only the order in which we wire the `next` pointers does. We could create `ListNode3` first and `ListNode1` last — the list would be identical.
- Once chained, the variable names `ListNode2` and `ListNode3` become optional. The list is fully reachable through `ListNode1.next` and `ListNode1.next.next`.

## Traversal of the linked list

To go through a linked list **from the beginning till the end**, we need a **simple `while` loop**. We start the traversal at the **top of the list** — the head — and keep following `next` pointers until we hit `null`.

```javascript
let current = ListNode1;          // start at the head
while (current !== null) {        // keep going while there's a node
    console.log(current.value);   // do something with the current node
    current = current.next;       // step forward to the next node
}
// 1, 2, 3
```

The pattern always has the same four pieces:

1. **A `current` pointer**, initialized to the head of the list.
2. **A `while (current !== null)` condition**, which keeps the loop alive as long as there are still nodes to visit.
3. **The work to do at each node** — read its value, update it, count it, accumulate it.
4. **`current = current.next`**, which moves the pointer one step forward.

This is the bread-and-butter pattern for linked list algorithms — almost every problem you'll see (find a value, count the nodes, reverse the list, detect a cycle, merge two lists) starts with some variation of this loop. The only thing that changes between problems is the work in step 3 and, occasionally, the stop condition in step 2 (e.g. `while (current.next !== null)` if you need to look one node ahead).

## Singly vs doubly linked lists

What we've described so far is a **singly linked list**: each node has a single `next` pointer. You can only move forward.

A **doubly linked list** adds a second pointer, `prev`, that points to the previous node — so you can move in both directions. The trade-off is more memory per node and slightly more bookkeeping on insert/delete.

```javascript
class DoublyListNode {
    constructor(value) {
        this.value = value;
        this.prev = null;
        this.next = null;
    }
}
```

Singly linked lists are by far the more common starting point.

## Complexity of common operations

| Operation                          | Linked list | Array  |
|------------------------------------|-------------|--------|
| Access by index (`get(i)`)         | O(n)        | O(1)   |
| Search for a value                 | O(n)        | O(n)   |
| Insert at head                     | O(1)        | O(n)   |
| Insert at tail (tail known)        | O(1)        | O(1) amortized |
| Insert in the middle (node known)  | O(1)        | O(n)   |
| Delete a node (node known)         | O(1)        | O(n)   |

The big differences:

- **Random access is slow.** To reach the `i`-th node, you have to walk `i` steps from the head. There's no shortcut.
- **Insert/delete is fast** *if you already have the node*. You just rewire a couple of `next` pointers — no shifting of memory.

## When to use a linked list

Linked lists shine when:

- You insert and delete from the **front or middle** a lot, and you already have a reference to the node.
- You don't need **random access** by index.
- You're implementing a structure where O(1) insertion/deletion at known positions matters — **queues**, **stacks**, **LRU caches** (with a hash map), **adjacency lists** in graphs.

They're a poor choice when you mostly want to read by index, scan with high cache locality, or do heavy numeric work — arrays win on all three.

## Common pitfalls

- **Losing the head.** When you reassign `head = head.next`, you've thrown away the rest of the list unless you saved the original head somewhere. Keep a separate variable for the head if you need to return it later.
- **Forgetting null checks.** `current.next` blows up if `current` is `null`. Loops should always end with `while (current !== null)` (or `current.next !== null` if you need to look one ahead).
- **Cycles.** A list isn't supposed to have cycles, but bugs can create one (e.g., setting `node.next = node` by accident). A traversal then loops forever — this is exactly what Floyd's tortoise-and-hare algorithm is designed to detect.

## Key takeaway

A **linked list** is an ordered sequence of nodes, where each node stores a **value** and a **`next` pointer** to the following node. It's slower than an array for random access but much faster for inserts and deletes at known positions. The whole data structure is essentially a chain of `ListNode` objects, and most algorithms over it are variations on "walk from head to tail with a `current` pointer."
