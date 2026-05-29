# Dynamic Programming

## One-dimensional dynamic programming

**Dynamic programming (DP)** is an **optimized version of recursion**. It takes a recursive solution that recomputes the same sub-problems over and over and rewrites it so that **each sub-problem is solved only once**. The result is usually much more efficient in both **time and space**.

DP is called "one-dimensional" when each sub-problem can be identified by a **single value** — like "what is the answer for `n`?" — and the answers can be stored in a one-dimensional array (or a single variable). When the sub-problem needs two coordinates to identify it ("what's the answer for input `(i, j)`?"), the DP is two-dimensional. We'll start with the one-dimensional case.

The canonical example is the **Fibonacci sequence**:

```
F(n) = F(n − 1) + F(n − 2)
F(0) = 0, F(1) = 1
```

## Dynamic programming vs recursion

A pure recursive solution computes its sub-problems from scratch every time they come up. **Dynamic programming tells us that we can avoid repeating those computations by using memoization.**

**Memoization is basically caching.** The idea: once we perform a computation, we **store its result in a cache** so we don't have to repeat it. The next time the same sub-problem comes up, we read the answer out of the cache instead of recomputing it.

The cache can be any structure that lets you look up a value by its input:

- a **hash map** (`{}` in JavaScript, `dict` in Python) — flexible, works for any key
- an **array** — fast and compact when inputs are small non-negative integers

In essence:

> **DP = recursion + memoization.**

The recursion describes *what* the answer is in terms of smaller answers. The memoization makes sure each of those smaller answers is computed only once.

### Fibonacci, memoized

```javascript
function fibMemoization(n, cache) {
    if (n <= 1) {
        return n;
    }
    if (cache[n] != 0) {
        return cache[n];
    }
    cache[n] = fibMemoization(n - 1, cache) + fibMemoization(n - 2, cache);
    return cache[n];
}
```

Walking through what each line does:

- **`if (n <= 1) return n;`** — base case, identical to the brute-force version.
- **`if (cache[n] != 0) return cache[n];`** — the memoization check. If we've already computed `F(n)`, return the stored answer immediately. (Initializing the cache to zeros works here because the only `F(k)` that equals `0` is `F(0)`, which the base case already handles — so a non-zero entry always means "previously computed.")
- **`cache[n] = ...`** — compute the recurrence the normal way, but **store the result** before returning it.
- **`return cache[n];`** — return the value we just stored.

The only difference from the brute-force code is that two-line cache check and the assignment. That tiny change turns an O(2ⁿ) algorithm into an O(n) one, because every value `F(k)` is now computed exactly once instead of being recomputed across many branches of the call tree.

## Step 1 — Brute-force recursion

The most natural way to write Fibonacci is to translate the formula directly into code:

```javascript
function bruteForce(n) {
    if (n <= 1) {
        return n;
    }
    return bruteForce(n - 1) + bruteForce(n - 2);
}
```

It's short and reads exactly like the math. But it has a big problem.

### Why it's slow

Each call branches into **two** more calls, so the call structure is a tree:

```
                       fib(5)
                  /             \
              fib(4)              fib(3)
            /        \           /       \
         fib(3)     fib(2)    fib(2)    fib(1)
         ...
```

The same sub-problems get computed many times: `fib(3)` is computed twice, `fib(2)` three times, `fib(1)` five times. As `n` grows, the duplication explodes.

- **Time: O(2ⁿ)** — the call tree roughly doubles at each level.
- **Space: O(n)** — the call stack only holds one path through the tree at a time, but that path is `n` deep.

For `n = 40` this is already millions of redundant calls; for `n = 50` it's slow enough to feel; for `n = 100` it would never finish in a human lifetime.

The fix is to **stop redoing work we've already done**.

## Step 2 — Memoization (top-down DP)

The first DP technique: keep the recursive shape, but **cache** each result the first time we compute it, and read from the cache on every subsequent call.

```javascript
function memoFib(n, memo = {}) {
    if (n <= 1) return n;
    if (memo[n] !== undefined) return memo[n];   // already computed → reuse
    memo[n] = memoFib(n - 1, memo) + memoFib(n - 2, memo);
    return memo[n];
}
```

What changed:

- We added a `memo` object that maps `n → F(n)`.
- Before doing any work, we check if `memo[n]` is already known.
- After computing, we save the result so future calls skip straight to a lookup.

Now each `fib(k)` is computed **exactly once**. Subsequent calls are just `O(1)` lookups.

- **Time: O(n)** — `n` unique values, each computed once with O(1) work.
- **Space: O(n)** — the `memo` table plus the call stack.

This style is called **top-down DP** because we still start from `n` (the top of the problem) and recurse downward, but we no longer redo work along the way.

## Step 3 — Tabulation (bottom-up DP)

The same idea, but instead of recursing from `n` downward, we build the answers **from the bottom up** using a loop and an array.

```javascript
function tabFib(n) {
    if (n <= 1) return n;
    const dp = new Array(n + 1);
    dp[0] = 0;
    dp[1] = 1;
    for (let i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}
```

We start with the smallest known values (`dp[0]`, `dp[1]`) and walk forward, filling each cell from the two that came before. No recursion, no call stack — just a loop.

- **Time: O(n).**
- **Space: O(n)** for the `dp` array.

This style is called **bottom-up DP** or **tabulation**. It's often preferred in practice because:

- No risk of stack overflow on very large `n`.
- Loops are typically faster than function calls.
- The structure of the computation is easier to read top-to-bottom.

## Step 4 — Space-optimized DP

Look at the tabulation code again. To compute `dp[i]`, we only need `dp[i - 1]` and `dp[i - 2]` — we never look back further. So why store the entire array?

```javascript
function spaceOptimizedFib(n) {
    if (n <= 1) return n;
    let prev2 = 0, prev1 = 1;
    for (let i = 2; i <= n; i++) {
        const curr = prev1 + prev2;
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}
```

Two variables instead of an `n`-length array. Same answer, same `O(n)` time, but now:

- **Time: O(n).**
- **Space: O(1).**

This pattern — *if the recurrence only looks back a fixed number of steps, you only need a fixed number of variables* — is one of the most common space optimizations in 1D DP.

## The four-step pattern

The progression we just walked through is the standard recipe for turning any recursive problem into DP:

1. **Brute-force recursion.** Write the most natural recursive solution. Verify it's correct on small inputs.
2. **Memoize (top-down).** Add a cache so each sub-problem is solved once. This usually drops the time complexity dramatically — often from exponential to linear.
3. **Tabulate (bottom-up).** Rewrite the recursion as a loop that builds answers from the smallest sub-problem upward into an array.
4. **Optimize space.** If each cell of the table only depends on a fixed number of previous cells, replace the array with a few variables.

You don't always need to go all the way to step 4 — sometimes step 2 is enough. The point is that **each step is mechanical** once you've written the previous one.

## When 1D DP is the right tool

Reach for 1D DP when:

- You have a recursive solution where the answer for input `n` depends on the answers for smaller inputs (`n - 1`, `n - 2`, `n - k`).
- The same sub-problem comes up repeatedly during the recursion (overlapping sub-problems).
- The sub-problem is fully described by **a single index or value**.

Classic 1D DP problems: Fibonacci, climbing stairs, house robber, decode ways, coin change (minimum coins), longest increasing subsequence (with care), word break.

## Key takeaway

Dynamic programming is **recursion plus a memory of past answers**. The brute-force recursion is correct but expensive because it recomputes the same things over and over; DP fixes that by storing each sub-problem's answer the first time it's computed. The result is usually a jump from exponential time to linear, and often a further drop from linear to constant space.

In one phrase: **DP is about doing the same work fewer times.**
