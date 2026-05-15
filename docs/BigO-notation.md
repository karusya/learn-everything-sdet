---
title: Big O Notation — Complete Notes
summary: Full overview of Big O including intuition, formal definition, simplification rules, time and space complexity, arrays, and brute force examples.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Big O Notation — Complete Notes

## Overview

**Big O notation** describes how an algorithm **scales** as input size `n` grows.

It focuses on:
- **Rate of growth**
- **Worst-case performance**
- **Upper bound of operations**

---

## Core Concept

- `n` → input size  
- `f(n)` → number of operations  

We ask:

> How does `f(n)` grow as `n → ∞`?

---

## Formal Definition (Bounded Above)

```text
f(n) = O(g(n))

if there exist constants c > 0 and n₀ such that:
f(n) ≤ c · g(n), for all n ≥ n₀

👉 Big O means the function is bounded above

## Intuition

- Big O shows the **maximum (upper bound) growth rate**
- We ignore **constants** and **small inputs**
- Focus only on behavior as `n → ∞`

---

## Worst-Case Focus

Big O represents:

> The **worst-case amount of work** an algorithm can perform

- Guarantees performance will not exceed this bound  
- Used for safe comparison between algorithms  

---

## Rate of Growth

We care only about:

> How fast the function grows as input increases

Not:
- Exact runtime  
- Small input behavior  

---

## Common Time Complexities

### Constant Time — O(1)

```text
O(1)