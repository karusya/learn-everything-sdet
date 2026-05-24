# Recursion

## What recursion is

A **recursive function** is a function that **calls itself with a different argument**. Each call works on a slightly smaller or simpler version of the original problem, until the input is small enough to answer directly.

Put another way: recursion is a function that **breaks a problem into smaller sub-problems**, solves each of those, and then combines them — effectively solving the pieces in **reverse order**, as each recursive call only finishes once the deeper ones return.

Every recursive function has **two parts**:

1. **Base case** — the smallest version of the problem that can be answered directly, without any further recursion. This is what stops the function from calling itself forever.
2. **Recursive case** — the function calls itself with a smaller or simpler argument, moving the problem closer to the base case.

Miss either of these and recursion breaks: no base case means infinite recursion (stack overflow); no recursive case means the function never reduces the problem.

## Recursive vs iterative code

There are two basic ways to express repeated work in code:

- **Recursive** — a function that **calls itself**, with a slightly smaller or simpler input each time, until it reaches a base case that doesn't need to recurse any further.
- **Iterative** — code that **uses a loop** (`for`, `while`) to repeat work, updating a variable on each pass until a condition is met.

Both can solve the same problems. The difference is in how the work is *structured*, not in what gets computed. In fact, **any recursive function can be rewritten as an iterative one, and any iterative one can be rewritten recursively** — though one form is usually clearer than the other depending on the problem. (Rewriting recursion as iteration often involves managing your own stack data structure to mimic what the call stack was doing automatically.)

## A simple example: countdown

The classic introductory example is a countdown from `n` down to `1`.

### Recursive version

```python
def countdown(n):
    if n == 0:
        return            # base case: stop recursing
    print(n)
    countdown(n - 1)      # recursive case: call itself with a smaller input
```

Calling `countdown(3)` prints:

```
3
2
1
```

Two ingredients make this work, and **every recursive function needs both**:

1. **Base case** — the condition that stops the recursion (`if n == 0: return`). Without it, the function would call itself forever and eventually crash with a stack overflow.
2. **Recursive case** — the function calls itself with an input that's **closer to the base case** (`countdown(n - 1)`). Each call shrinks the problem.

### Iterative version (for comparison)

The same behavior with a loop:

```python
def countdown(n):
    while n > 0:
        print(n)
        n -= 1
```

Same output, different shape. The recursive version describes the problem ("print `n`, then count down from `n-1`"); the iterative version describes the procedure ("keep going while `n` is positive, then decrement").

## How recursion actually runs

When `countdown(3)` is called, the language doesn't magically know how to "unfold" itself. It uses the **call stack** — a built-in stack data structure where each function call gets its own frame containing its arguments and local variables.

```
countdown(3)  -->  prints 3, calls countdown(2)
   countdown(2)  -->  prints 2, calls countdown(1)
      countdown(1)  -->  prints 1, calls countdown(0)
         countdown(0)  -->  base case, returns
      returns
   returns
returns
```

Each call waits on the stack until its recursive call completes. This is also why too-deep recursion fails: the stack runs out of space.

## Types of recursion

Recursive functions come in two flavors, distinguished by **how many recursive calls** a single invocation makes:

- **One-branch (linear) recursion** — each call makes **exactly one** recursive call to itself. The call stack grows in a straight line: one chain of calls down, one chain back up. `countdown` and `factorial` are classic examples.
- **Multi-branch (tree) recursion** — each call makes **two or more** recursive calls. The call stack forms a *tree* of calls rather than a line, and the total number of calls grows much faster — typically exponentially in the input. Examples: naive Fibonacci, generating subsets/permutations, traversing binary trees.

The shape of the recursion has a huge effect on complexity: one-branch recursion is usually `O(n)` time, while a multi-branch recursion that doubles at each step is `O(2ⁿ)`.

### Example: factorial (one-branch recursion)

The factorial of `n` is `n * (n-1) * (n-2) * ... * 1`. Defined recursively:

- `n! = n * (n-1)!`
- `0! = 1!= 1` (base case)

```javascript
// Recursive implementation of n! (n-factorial) calculation
function factorial(n) {
    // Base case: n = 0 or 1
    if (n <= 1) {
        return 1;
    }
    // Recursive case: n! = n * (n - 1)!
    return n * factorial(n - 1);
}
```

Again, both parts are present:

- **Base case:** `n <= 1` returns `1` directly. The recursion stops.
- **Recursive case:** the function calls itself with `n - 1`, a smaller version of the same problem.

Calling `factorial(4)` unfolds like this:

```
factorial(4)
= 4 * factorial(3)
= 4 * 3 * factorial(2)
= 4 * 3 * 2 * factorial(1)
= 4 * 3 * 2 * 1
= 24
```

Each call makes **one** further call — that's why this is one-branch recursion.

### Time and space complexity

**Time: O(n).** In total, `n` calls are made to the `factorial` function, and each call itself only does `O(1)` work (a comparison and a multiplication). The total time is therefore `O(n)`.

**Space: O(n).** Even though we aren't using any data structures explicitly, recursion operates on an **implicit stack** — the function call stack. That's how the language is able to return from one call back into the one that invoked it. Because there are `n` recursive calls outstanding at the deepest point (each waiting on its child to return), `n` frames sit on the stack simultaneously, giving `O(n)` space.

This is an important point about recursion in general: the call stack is *invisible* in the code, but it absolutely shows up in the space complexity. A recursive function that looks like it uses no extra memory is still using `O(depth-of-recursion)` space behind the scenes.

### Example: Fibonacci (two-branch recursion)

The **Fibonacci sequence** is the classic example of **multi-branch recursion**. The sequence is a set of numbers that starts with `0` and `1`, and every next number is the **sum of the two preceding numbers**:

```
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
```

The formula to calculate the *n*-th Fibonacci number is the sum of the two previous Fibonacci numbers — that is, `f(n - 1) + f(n - 2)`.

Formally:

- **Base case:** `f(0) = 0`, `f(1) = 1`
- **Recursive case:** `f(n) = f(n - 1) + f(n - 2)`

The first part is the base case (nothing further to compute); the second is the recursive case (the function calls itself — twice).

```javascript
// Recursive implementation to calculate the n-th Fibonacci number
function fibonacci(n) {
    // Base case: n = 0 or 1
    if (n <= 1) {
      return n;
    }
    // Recursive case: fib(n) = fib(n - 1) + fib(n - 2)
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

Because each call spawns **two** further calls, the call structure is a tree, not a line:

```
                       fib(5)
                  /             \
              fib(4)              fib(3)
            /        \           /       \
         fib(3)     fib(2)    fib(2)    fib(1)
        /     \    /    \     /    \
     fib(2) fib(1) fib(1) fib(0) fib(1) fib(0)
     /    \
  fib(1) fib(0)
```

Notice how the same sub-problems get computed many times — `fib(2)` is calculated three separate times in the tree above, `fib(3)` twice. That's where the explosion in work comes from.

### Time and space complexity (Fibonacci)

**Time: O(2ⁿ).** Because each call branches into two more calls, the total number of nodes in the call tree is `O(2ⁿ)`. Each node itself is just one function call doing the sum of two values — `O(1)` work per node. Multiplying gives `O(2ⁿ)` total time.

**Space: O(n).** Even though the *total number* of calls is exponential, the call stack only holds the calls along **one path down the tree** at any given moment (the language fully resolves one branch before starting the next). The deepest such path is `n` calls long, so the stack uses `O(n)` space.

This is a great illustration of why naive multi-branch recursion can be deceptively expensive: the code looks short and tidy, but the **shape of the call tree** — not the length of the code — is what determines complexity. Techniques like **memoization** or **dynamic programming** turn this `O(2ⁿ)` Fibonacci back into `O(n)` by remembering results that the naive version recomputes.

## Problem: sum an array recursively

A nice warm-up problem that shows how recursion replaces a loop on a list:

> Given an array of numbers, return the sum of all elements — using recursion.

### Thinking recursively

A list is a naturally recursive structure: it's either **empty**, or it's a **first element** followed by **a smaller list (the rest)**. That gives us the two cases:

- **Base case:** empty array → sum is `0`. (A one-element array can be its own base case too, returning that element.)
- **Recursive case:** the sum of the array is the **first element plus the sum of the rest**.

So:

```
sum([a, b, c, d]) = a + sum([b, c, d])
                  = a + b + sum([c, d])
                  = a + b + c + sum([d])
                  = a + b + c + d + sum([])
                  = a + b + c + d + 0
```

Each call strips off the first element and recurses on a shorter array, until the array is empty.

### Implementation (JavaScript)

```javascript
const sumNumbersRecursive = (numbers) => {
    if (numbers.length === 0) return 0;            // base case: empty array
    if (numbers.length === 1) return numbers[0];   // base case: single element
    return numbers[0] + sumNumbersRecursive(numbers.slice(1));
};

module.exports = {
    sumNumbersRecursive,
};
```

Two base cases here — strictly only one is needed (`length === 0` is enough), but adding `length === 1` is a small micro-optimization that saves one extra call at the bottom of the recursion.

### Complexity

- **Time: O(n).** Each call processes one element and makes one further call, so there are `n` calls total, each doing `O(1)` work — *except* for `slice(1)`, which actually copies the rest of the array and is itself `O(n)`. With `slice`, the true total time is `O(n²)`.
- **Space: O(n).** The call stack reaches depth `n` before any call returns. The intermediate sliced arrays also contribute to memory usage.

A more efficient version passes an **index** instead of slicing:

```javascript
const sumNumbersRecursive = (numbers, i = 0) => {
    if (i === numbers.length) return 0;
    return numbers[i] + sumNumbersRecursive(numbers, i + 1);
};
```

This keeps it true `O(n)` time and avoids creating `n` copies of the array.

### Why this is a useful pattern

This shape — "do something with `arr[0]`, then recurse on `arr.slice(1)`" — works for any aggregation over a list: sum, product, min, max, count, filter, map, reduce. Once you see the pattern, you've effectively learned how to express any list operation recursively.

## Problem: reverse a string recursively

> Given a string, return its reverse — using recursion.

### Thinking recursively

A string is essentially a list of characters, so the same "first + rest" idea applies — but the **order in which we combine** changes everything:

- To **sum** an array, we combine first + rest: `arr[0] + sum(rest)`.
- To **reverse** a string, we combine rest + first: `reverse(rest) + s[0]`.

That tiny rearrangement is what flips the order. Each character "waits" on the stack until its rest has been reversed, then attaches itself to the **end** instead of the front.

- **Base case:** empty string → return `""`.
- **Recursive case:** `reverse(s) = reverse(s.slice(1)) + s[0]`.

### Implementation (JavaScript)

```javascript
const reverseString = (s) => {
    if (s.length === 0) return "";
    return reverseString(s.slice(1)) + s[0];
};

module.exports = {
    reverseString,
};
```

### Trace for `"abc"`

```
reverseString("abc")
= reverseString("bc") + "a"
= (reverseString("c") + "b") + "a"
= ((reverseString("") + "c") + "b") + "a"
= ((""           + "c") + "b") + "a"
= ("c"                  + "b") + "a"
= "cb"                         + "a"
= "cba"
```

Notice the unwinding order. The function descends all the way to the empty string first, *then* assembles the result on the way back up — each return tacks one character onto the **end** of the growing reversed string.

### Complexity

- **Time: O(n²).** There are `n` recursive calls, but each one does `slice(1)` (copies the rest of the string, O(n)) and a string concatenation (also O(n) in most engines because strings are immutable). That's `O(n)` work per call, multiplied by `n` calls.
- **Space: O(n²)** in the worst case — `n` stack frames, each holding an intermediate string of decreasing length, plus the new strings created by concatenation. The call stack itself is `O(n)`.

For production code you'd reverse a string iteratively (or via `[...s].reverse().join("")`), but the recursive version is a great exercise: it shows how the **order of combination** in the recursive case controls the final shape of the answer.

## Problem: factorial recursively

We already saw factorial earlier as the canonical example of one-branch recursion, but here's the standalone problem framing with the version you wrote:

> Given a non-negative integer `n`, return `n!` — the product of all positive integers up to and including `n`. By definition, `0! = 1`.

### Thinking recursively

The factorial of `n` is `n` times the factorial of `n − 1`. The recursion bottoms out at `0`:

- **Base case:** `n === 0` → return `1`.
- **Recursive case:** `factorial(n) = n * factorial(n - 1)`.

### Implementation (JavaScript)

```javascript
const factorial = (n) => {
    if (n === 0) return 1;
    return n * factorial(n - 1);
};

module.exports = {
    factorial,
};
```

### Complexity

- **Time: O(n)** — one recursive call per level, and each does `O(1)` work (a comparison and a multiplication).
- **Space: O(n)** — the call stack holds `n` frames before any of them returns.

This is the simplest possible example of **one-branch recursion**: one recursive call per invocation, a linear chain of stack frames, no recomputation of sub-problems. It's the same shape as `sumNumbersRecursive` above — each call does a tiny piece of work and forwards the rest of the problem to the next call.

## Problem: climbing stairs

A classic problem that shows how to **recognize** a recursive structure in a real-world setting:

> You are climbing a staircase. It takes `n` steps to reach the top. Each time you can take either **1 step** or **2 steps**. How many distinct ways can you climb to the top?

### Thinking recursively

The trick is to ask: *how could I have arrived at step `n`?* There are only two possibilities:

- I was on step `n - 1` and took **1 step**, or
- I was on step `n - 2` and took **2 steps**.

That means the number of ways to reach step `n` is the sum of:

- the number of ways to reach step `n - 1`, plus
- the number of ways to reach step `n - 2`.

So:

```
climbStairs(n) = climbStairs(n - 1) + climbStairs(n - 2)
```

Base cases:

- `climbStairs(1) = 1` — only one way to climb a single step.
- `climbStairs(2) = 2` — two ways: `1 + 1` or `2`.

Notice anything familiar? This is **exactly the Fibonacci recurrence**, just with different starting values. Many real problems turn out to be Fibonacci in disguise once you spot the recursive structure.

### Implementation (JavaScript)

```javascript
function climbStairs(n) {
    // Base cases
    if (n === 1) return 1;
    if (n === 2) return 2;

    // Recursive case: arrived from either step n-1 or step n-2
    return climbStairs(n - 1) + climbStairs(n - 2);
}

console.log(climbStairs(5)); // 8
```

For `n = 5`, the answer is `8`. The valid paths are:

```
1+1+1+1+1
1+1+1+2
1+1+2+1
1+2+1+1
2+1+1+1
1+2+2
2+1+2
2+2+1
```

### Complexity

This is the same shape as Fibonacci, so it carries the same costs:

- **Time: O(2ⁿ)** — each call branches into two, building an exponential call tree with massive recomputation of the same sub-problems.
- **Space: O(n)** — the call stack only holds one path through the tree at a time, up to depth `n`.

### The takeaway from this problem

The climbing-stairs problem is a great example of how to **recognize** a recursive problem in the wild:

1. Ask "what was the situation **one step before** the final answer?"
2. If there's a small, fixed number of ways to have arrived at this state, you have your recursive cases.
3. Identify the smallest version of the problem where the answer is trivial — that's your base case.

Once you see the pattern, the same recursive shape appears everywhere: counting paths in a grid, decoding strings, tiling problems, coin-change variations, and many more.

## When recursion is the better fit

Recursion shines when the *problem itself* is naturally recursive — that is, when a solution for the whole can be expressed cleanly in terms of solutions for smaller pieces. Common examples:

- **Tree and graph traversal** — file systems, DOM trees, parse trees, expression trees.
- **Divide-and-conquer algorithms** — merge sort, quick sort, binary search.
- **Mathematical definitions** — factorial, Fibonacci, power.
- **Backtracking** — solving mazes, generating permutations, the N-queens problem.

In each of these, an iterative solution is possible but tends to require manually managing a stack — at which point you're just re-implementing recursion by hand.

## Trade-offs

Recursion can be elegant but it isn't free.

- Each call adds a frame to the call stack, so deep recursion uses more memory than a loop and can hit a **stack overflow** for very large inputs.
- Function call overhead makes recursion **slightly slower** than the equivalent loop in most languages.
- Iterative code is often easier to step through in a debugger.

For simple linear repetition (like our countdown), a loop is usually the natural choice. For tree-shaped or self-similar problems, recursion is usually the clearer one.

## Key takeaway

A function is **recursive** when it calls itself, and **iterative** when it uses a loop. Every recursive function needs a **base case** (to stop) and a **recursive case** (to shrink the problem on each call). Use recursion when the problem is naturally self-similar; use iteration when the work is just "do this N times."

---

## Exhaustive recursion

So far we've used recursion to *reduce* a problem step by step (countdown shrinks `n` toward 0). **Exhaustive recursion** is a different flavor: instead of reducing toward a single answer, we **explore every possible choice** at each step and collect all the results.

It's the technique behind:

- Generating all subsets of a set
- Generating all permutations of a list
- Solving combinatorial problems (combinations, partitions)
- Backtracking puzzles (N-queens, sudoku, word search)

The shape is always the same: at each recursive step there are multiple branches, and we recurse into **each of them**, gathering the results.

### Problem: subsets

> Write a function `subsets` that takes in an array as an argument. The function should return a 2D array where each subarray represents one of the possible subsets of the array.

For input `[1, 2, 3]`, the output should contain all 8 subsets:

```
[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]
```

(2³ = 8 subsets — each element is either in or out, giving 2ⁿ total.)

### The key insight

For each element, there are exactly **two choices**: include it, or exclude it. The set of all subsets of `[1, 2, 3]` is the union of:

- All subsets of `[2, 3]` **without** `1`
- All subsets of `[2, 3]` **with** `1` prepended

This is the recursive structure. The base case is the empty array, whose only subset is the empty subset `[]`.

### Implementation (Python)

```python
def subsets(arr):
    # Base case: the only subset of an empty array is the empty subset
    if not arr:
        return [[]]

    first = arr[0]
    rest = arr[1:]

    # All subsets that DO NOT include `first`
    without_first = subsets(rest)

    # All subsets that DO include `first` — prepend `first` to each
    with_first = [[first] + subset for subset in without_first]

    return without_first + with_first


print(subsets([1, 2, 3]))
# [[], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3]]
```

### Why it's "exhaustive"

At every recursive call we make **both** choices — "exclude this element" *and* "include this element" — and combine the results. Nothing is pruned. We explore the entire decision tree, which is why the output grows as `2ⁿ`.

### The decision tree for `[1, 2, 3]`

```
                       subsets([1, 2, 3])
                      /                   \
        exclude 1                          include 1
        subsets([2, 3])              [1] + each of subsets([2, 3])
       /            \
exclude 2        include 2
subsets([3])     [2] + subsets([3])
   ...                 ...
```

Each leaf of this tree corresponds to one subset in the final answer.

### Pattern: how to write exhaustive recursion

The recipe is consistent across these problems:

1. **Identify the choice** being made at each step (include/exclude, pick which next item, place/skip).
2. **Define a base case** for when there are no more choices to make.
3. **Recurse into every option** and combine the results.

Subsets makes a binary choice (in or out). Permutations make an N-way choice (which element goes next). Backtracking adds a fourth step — *prune* branches that can't lead to a valid answer — but the core shape is the same.

### Key takeaway

Exhaustive recursion explores **every possible combination of choices** by branching at each step. The output is the union of results from every branch, not a reduction to a single value. The technique is the foundation for generating subsets, permutations, and any other "enumerate all possibilities" problem.
