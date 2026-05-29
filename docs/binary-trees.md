# Binary Trees

## What a binary tree is

A **binary tree** is a data structure made of **nodes and pointers**, just like a linked list — but where each node in a linked list points to *one* next node, each node in a binary tree has **at most two pointers**, called the **left child** and the **right child**.

The **value** stored in a node can be any data type — a number, a string, an object, anything.

```javascript
class TreeNode {
    constructor(val) {
        this.val = val;
        this.left = null;
        this.right = null;
    }
}
```

That's it — three fields per node: a value, a left pointer, and a right pointer. Either pointer can be `null`, meaning "no child on that side."

Drawn out, a small binary tree looks like this:

```
        10           <- root
       /  \
      5    15        <- internal nodes
     / \     \
    3   7    20      <- leaves (mostly)
```

Each line shows a level. The top node is the **root**. Pointers always go from parent to child — never back up.

## Root node

The **root node** is the **highest node in the tree** — the entry point. It has **no parent**.

Every other node in the tree can be reached by starting at the root and following pointers downward. There's no way into the tree except through the root, which is why almost every tree algorithm takes the root as its only argument.

In the diagram above, `10` is the root.

## Leaf nodes

A **leaf node** is a node with **no children** at all (both `left` and `right` are `null`). In the diagram, `3`, `7`, and `20` are leaves.

A useful guarantee: **the nodes at the last level of the tree are always leaf nodes**. If they had children, they wouldn't be on the last level — those children would be. (Note that leaves can also appear above the last level, like `20` is at level 2 in our example even though level 3 exists for `7`.)

A **non-leaf node** (sometimes called an **internal node**) has **at least one child** — left, right, or both. In the diagram, `10`, `5`, and `15` are non-leaf nodes.

The leaf/non-leaf distinction matters because most tree algorithms have to decide *"do I recurse further, or am I at the bottom?"* — and that decision is exactly "is this a leaf?".

## Children of a node

The **children of a node** are simply its **left child** and **right child** — the two nodes that its `left` and `right` pointers refer to. Either child can be missing (`null`), so a node may have zero, one, or two children.

When we talk about "the children" of a node without specifying which one, we usually mean both pointers together.

## Height of a binary tree

The **height** of a binary tree is measured from the **root node down to the lowest leaf node** — specifically, the **number of edges on the longest path** from the root to any leaf.

A single-node tree has height `0`. The tree in our example has height `2`, because the longest root-to-leaf path goes `10 → 5 → 3` (or `10 → 5 → 7`), which is two edges.

Height matters because most tree-operation costs depend on it, not on the total number of nodes. A balanced tree of `n` nodes has height `O(log n)`; a degenerate tree shaped like a chain has height `O(n)`. That's the difference between a fast lookup and a slow one.

## Number of edges in a tree

A useful structural fact:

> **The number of edges in a tree is `n − 1`**, where `n` is the number of nodes.

Every node except the root has exactly one incoming edge (from its parent), and the root has none — so the count of edges is always one less than the count of nodes. This is true for any tree, not just binary ones, and it's a handy invariant to remember when reasoning about tree algorithms or memory usage.

## Direction and shape

Two structural rules are baked into the definition:

1. **Pointers can only point in one direction** — from parent to child. There's no built-in pointer from a child back to its parent. (Some implementations add one if you need it, but it's not part of the basic structure.)
2. **A binary tree is a connected acyclic graph** with no cycles. Every node is reachable from the root, and there's exactly **one path** from the root to any node — no loops, no shortcuts, no two parents.

Put together: a tree is what you get when you take a graph, remove all the cycles, and pick one node as the entry point. Or, looked at from the other direction: a tree is a graph where every node except the root has exactly one parent.

> Strictly speaking, an implementation with parent → child pointers is a **directed** acyclic graph. But the *abstract* structure of a tree — the relationships between nodes — is the same whether you draw the edges as arrows or as plain lines, which is why both descriptions show up in textbooks.

## Other useful vocabulary

A few more terms that come up constantly when working with trees:

- **Parent** — the node one level above a given node; the node whose `left` or `right` pointer refers to it.
- **Siblings** — two nodes that share the same parent.
- **Subtree** — any node together with all its descendants. Every node is the root of its own subtree, which is why so many tree algorithms are naturally recursive.
- **Depth** of a node — number of edges from the **root** down to that node. The root has depth `0`. (Depth is measured *from the top*; height is measured *to the bottom*.)

For the tree above: `7` has depth `2` and height `0`; the root `10` has depth `0` and height `2`.

## Common shapes you'll hear about

Once you have the basic definition, people slice binary trees into named subclasses based on their shape:

- **Full binary tree** — every node has either `0` or `2` children. No node has just one child.
- **Complete binary tree** — every level is fully filled except possibly the last, and the last level is filled from left to right. This is the shape **heaps** use.
- **Perfect binary tree** — every internal node has exactly `2` children, and all leaves are at the same depth. (A perfect tree is both full and complete.)
- **Balanced binary tree** — the heights of the two subtrees of every node differ by at most some small constant (often 1). Important because operations on a balanced tree are `O(log n)`; on a degenerate "tree" that's actually a chain, they degrade to `O(n)`.
- **Binary search tree (BST)** — a binary tree with an extra rule: for every node, all values in the **left** subtree are smaller, and all values in the **right** subtree are larger. This is what makes search efficient.

A plain binary tree has no ordering constraint between left and right — that comes only with BSTs.

## Why binary trees matter

Trees show up everywhere because **hierarchical relationships are everywhere**: file systems, DOM, JSON, parse trees, decision trees, scene graphs, database indexes. Binary trees are the simplest tree shape with enough structure to be useful, and they're the basis for:

- **Binary search trees** for ordered lookups
- **Heaps** for priority queues
- **Tries** (a generalization) for prefix search
- **Expression trees** for compilers and calculators
- **Segment trees** and **Fenwick trees** for range queries
- **Huffman trees** for compression

Most "tree problems" in interviews and real systems boil down to: visit every node, decide something at each one, possibly combine results from the left subtree and the right subtree.

## Key takeaway

A **binary tree** is a hierarchy of nodes where each node stores a value and **at most two pointers** — `left` and `right`. A node with no children is a **leaf**; a node with at least one is a **non-leaf**. Pointers run one direction only, and the overall structure is connected and cycle-free, which is what distinguishes a tree from a general graph. From this minimal definition you get a surprisingly rich family of specialized trees — BSTs, heaps, tries, balanced trees — that power a huge fraction of the data structures you'll meet later.
