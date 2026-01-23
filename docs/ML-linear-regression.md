---
title: Linear Regression — Core Notes
summary: Fundamental concept of linear regression in mathematics and machine learning, focusing on features, labels, and model parameters.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Linear Regression

## Concept overview

- Linear regression is designed to **find a relationship between variables**
- In Machine Learning, this relationship is between:
  - **Features (X)**
  - **Label / target (Y)**
- The goal is to model how changes in input features affect the output

---

## Mathematical background

- Linear regression comes from **school-level linear algebra**
- In algebra, it is represented as a straight-line equation:

y = mx + b
Where:
- `x` — independent variable
- `y` — dependent variable
- `m` — slope of the line
- `b` — intercept

---

## Linear regression in Machine Learning

In ML notation, the same idea is written as:

Y = B + WX


Where:
- `Y` — label (target variable)
- `X` — feature (input variable)
- `W` — weight
- `B` — bias

---

## Features, weights, and bias

- **Feature (X)**  
  Input data used to make predictions

- **Label (Y)**  
  The value the model is trying to predict

- **Weight (W)**  
  Determines how strongly a feature influences the prediction

- **Bias (B)**  
  Allows the model to shift predictions up or down independently of features

Both **weights and bias are learned during training**.

---

## Multiple features

- Linear regression can use **multiple features**
- In that case:
  - Each feature has its own weight
  - The model combines them linearly
- The idea remains the same: a linear relationship between inputs and output

---

## Summary

- Linear regression models linear relationships between variables
- The ML formulation directly mirrors the algebraic equation
- Training is the process of finding optimal **weights and bias**
- The model can scale from one feature to many without changing the core concept

