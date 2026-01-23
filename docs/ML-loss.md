---
title: Loss Functions — Core Notes
summary: What loss is, why it matters in machine learning, and the most common loss types used in regression.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Loss Functions

## What is loss?

- **Loss** is a numeric metric that describes **how wrong a model’s predictions are**
- It measures the **distance between predictions and actual labels (Y)**
- A lower loss means better model performance

Formally, loss compares:
- **Predicted value (ŷ)**
- **Actual value (y)**

---

## Why loss is important

- The main goal of training an ML model is **minimizing the loss**
- During training, the model adjusts its parameters (weights and bias) to reduce this value
- Loss is optimized regardless of whether the prediction is higher or lower than the actual value

---

## Distance between prediction and actual value

- Loss focuses on **distance**, not direction
- The sign of the error does not matter
- That is why loss functions use:
  - **Absolute values**, or
  - **Squared differences**

Basic error:
error = y - ŷ


---

## Common ways to calculate distance

### Absolute difference
|y - ŷ|
### Squared difference
(y - ŷ)²

---

## Types of loss functions

### L1 Loss
- Sum of absolute differences between actual and predicted values
L1 = Σ |y - ŷ|

- Treats all errors linearly
- Less sensitive to outliers than squared loss

---

### MAE (Mean Absolute Error)
- Average of L1 loss over `n` examples

MAE = (1 / n) * Σ |y - ŷ|


- Represents the **average absolute error**
- Easy to interpret

---

### L2 Loss
- Sum of squared differences between actual and predicted values

L2 = Σ (y - ŷ)²

- Penalizes large errors more strongly
- Commonly used in regression models

---

### MSE (Mean Squared Error)
- Average of squared differences over `n` examples

MSE = (1 / n) * Σ (y - ŷ)²


- Amplifies larger errors
- Smooth and differentiable, useful for optimization

---

### RMSE (Root Mean Squared Error)
- Square root of MSE

RMSE = √MSE


- Brings error back to the **same unit as the target variable**
- Easier to interpret than MSE

---

## Summary

- Loss measures how far predictions are from actual labels
- Training aims to minimize the loss
- Absolute and squared differences are the core building blocks
- MAE, MSE, and RMSE are the most common regression loss metrics
- Choice of loss affects how errors are penalized and optimized

