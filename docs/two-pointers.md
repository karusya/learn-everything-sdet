# Two Pointers

The **two pointers** technique is one of the most useful patterns for working with arrays and strings. The main idea is simple: instead of using a single index to walk through the data, you keep **two indices** (commonly called `l` and `r`, for *left* and *right*) and move them through the array based on what you observe at each position.

`l` and `r` can be **any indices in the array** — they don't have to start at the ends, they don't have to move in the same direction, and they don't have to move at the same speed. Choosing where they start and how they move is what makes each variant of the pattern do something different.

## The core idea

A single-pointer loop visits every position one at a time. A two-pointer loop maintains a **window or relationship between two positions**, and uses the comparison or combination of values at those positions to decide what to do next.

```
arr = [ a, b, c, d, e, f, g ]
        ↑                 ↑
        l                 r
```

At each step you can:

- Read or compare `arr[l]` and `arr[r]`.
- Move `l` forward (`l++`), move `r` backward (`r--`), or move either independently.
- Stop when the pointers meet, cross, or hit the boundary.

The whole technique fits in a `while (l < r)` (or `while (r < n)`) loop, which usually makes the whole algorithm **O(n)** — each pointer moves through the array at most once.

## Common variants

There are three main ways pointers move, each suited to different kinds of problems:

### 1. Opposite ends, moving inward

This is the most common starting setup. The recipe is:

1. **Start `l` at `0`** and **`r` at `arr.length - 1`** — the two ends of the array.
2. **Increment `l`, decrement `r`, or move both**, based on the conditions the problem gives you.
3. **Repeat until the pointers meet** (`l >= r`).

```
[ a, b, c, d, e, f, g ]
  ↑                 ↑
  l →             ← r
```

Typical problems: checking if a string is a palindrome, finding pairs that sum to a target in a **sorted** array, reversing an array in place, the "container with most water" problem.

### 2. Same direction, fast and slow

Both pointers start at (or near) the beginning, but one moves faster than the other.

```
[ a, b, c, d, e, f, g ]
  ↑  ↑
  s  f →
```

Typical problems: detecting cycles in a linked list (Floyd's tortoise and hare), finding the middle of a list in one pass, removing duplicates from a sorted array in place.

### 3. Sliding window (both moving forward)

`l` and `r` both start at the beginning and both move forward, but at different times based on the state of the window between them.

```
[ a, b, c, d, e, f, g ]
     ↑     ↑
     l     r →
     <----->
      window
```

Typical problems: longest substring without repeating characters, smallest subarray with sum ≥ target, max sum of any window of size k. (Sliding window is technically its own pattern, but it's built on the same two-pointer idea.)

## Example: is a string a palindrome?

The textbook opposite-ends problem. A palindrome reads the same forwards and backwards (`"racecar"`, `"level"`), so we compare the first character with the last, then move both pointers inward and compare again. As soon as any pair disagrees, we know the string isn't a palindrome.

```javascript
function isPalindrome(word) {
    let L = 0, R = word.length - 1;
    while (L < R) {
        if (word.charAt(L) != word.charAt(R)) {
            return false;
        }
        L++;
        R--;
    }
    return true;
}
```

Notice exactly the three-step recipe from above:

- **Start:** `L = 0`, `R = word.length - 1`.
- **Move:** every iteration increments `L` *and* decrements `R` (both pointers step inward — the condition is "they always move together unless we've already returned false").
- **Stop:** `while (L < R)` ends the moment the pointers meet or cross.

One pass, **O(n) time**, **O(1) extra space**. The pointers do all the work — no extra array, no reversed copy of the string.

### Trace on `"racecar"`

```
L=0 R=6 → 'r' == 'r' ✓
L=1 R=5 → 'a' == 'a' ✓
L=2 R=4 → 'c' == 'c' ✓
L=3 R=3 → loop ends (L < R is false)
return true
```

And on `"hello"`:

```
L=0 R=4 → 'h' != 'o' ✗  → return false
```

The mismatch is caught on the very first comparison, which is the other thing two pointers gets you: **early exit** the moment the answer is determined.

## Example: two-sum on a sorted array

Given a **sorted** array, find two numbers that add up to a target.

```javascript
const twoSumSorted = (nums, target) => {
    let l = 0;
    let r = nums.length - 1;

    while (l < r) {
        const sum = nums[l] + nums[r];
        if (sum === target) return [l, r];
        if (sum < target)  l++;   // need a larger sum → move left pointer right
        else               r--;   // need a smaller sum → move right pointer left
    }

    return [];
};

console.log(twoSumSorted([1, 3, 4, 6, 8, 11], 10)); // [1, 4]  (3 + 8)
```

This is `O(n)` instead of the `O(n²)` you'd get with two nested loops. The sortedness is what makes the move-one-pointer decision unambiguous: if the sum is too small, only moving `l` right can possibly help; if it's too big, only moving `r` left can help.

## When to reach for two pointers

The pattern is a fit when the problem has any of these flags:

- You're working with an **array or string** and feel tempted to write nested loops.
- The data is **sorted**, or sorting it first wouldn't change the answer.
- You're looking for a **pair, window, or subarray** that satisfies some condition.
- You need to do something **in place** with O(1) extra space.
- The problem mentions **palindrome**, **reverse**, **cycle**, **duplicate removal**, or **windows / substrings**.

## Why it works (and why it's fast)

A nested-loop solution checks every pair: O(n²) work. Two pointers gets away with O(n) because at each step you **eliminate possibilities** in bulk. In the sorted two-sum, moving `l` rightward doesn't just skip one pair — it eliminates every pair involving the old `l` and anything between the old `r` and now. The structure of the data (sortedness, symmetry, or the shape of a window) is what makes that elimination valid.

## Key takeaway

Two pointers means **maintaining two indices into the same array** and moving them in a coordinated way to extract information that a single index couldn't. `l` and `r` can be anywhere — at the ends, at the start, or anywhere in between — and the way they move (toward each other, in lockstep, or at different speeds) defines the variant of the pattern. It's one of the cheapest tools you have for turning an O(n²) idea into an O(n) one.
