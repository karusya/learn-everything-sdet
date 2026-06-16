# Gradient Descent

## What is Gradient Descent?

Gradient descent is an **iterative optimization algorithm** that lets a model learn its parameters by taking small steps in the direction that reduces error — repeating until the cost can no longer be meaningfully reduced.

---

## The Cost Function as a Landscape

Imagine the cost function as a physical landscape:

- Every possible combination of model parameters corresponds to a **point on this landscape**
- The **height** of that point is the cost (error) at those parameter values
- **Training a model** means starting wherever you are on this landscape and finding your way to the **lowest point**

```
Cost
  |
  |  \         /
  |   \       /
  |    \     /
  |     \   /
  |      \_/   ← global minimum
  |
  +-----------------> w (parameter)
```

The goal: reach the valley floor.

---

## The Update Rule

### The Gradient

The key ingredient is the **gradient** — a measure of the slope at your current position.

- The gradient tells you **which direction is uphill** and **how steep the slope is**
- To reduce cost, you step in the **opposite direction** of the gradient (downhill)

Formally, the partial derivative:

$$\frac{\partial \text{cost}}{\partial w}$$

measures how much the cost changes for a tiny nudge to parameter `w` — the slope in `w`'s direction.

### The Formula

Gradient descent updates each parameter at every step:

$$w \leftarrow w - \eta \cdot \frac{\partial \text{cost}}{\partial w}$$

$$b \leftarrow b - \eta \cdot \frac{\partial \text{cost}}{\partial b}$$

Where:
- `w` — weight parameter
- `b` — bias parameter
- `η` (eta) — the **learning rate**, controls how large each step is
- `∂cost/∂w` — the gradient, tells us the slope direction

The **minus sign** is what makes it descent — we move opposite to the uphill direction.

---

## The Learning Rate η

The learning rate controls step size and is critical to get right:

| Learning Rate | Effect |
|---------------|--------|
| Too large | Overshoots the minimum, may diverge |
| Too small | Converges very slowly, expensive |
| Just right | Steadily reaches the minimum |

```
Too large:          Too small:          Just right:
   *                  *
     *                 *
        *               *
  (misses min)    (crawls)            * * * * *_/
```

---

## The Algorithm Step by Step

1. **Initialize** parameters `w` and `b` (often randomly or as zeros)
2. **Compute** the cost at current parameters
3. **Compute** the gradient — how much each parameter affects the cost
4. **Update** each parameter using the update rule
5. **Repeat** steps 2–4 until cost stops decreasing significantly

---

## Key Takeaways

- Gradient descent doesn't find the minimum in one step — it **iterates toward it**
- The gradient is a local measurement — it only sees the slope at the current point
- It can get stuck in **local minima** on non-convex landscapes (a known limitation)
- Most deep learning optimizers (Adam, RMSProp) are variations built on top of this core idea
