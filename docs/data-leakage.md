# Data Leakage

## What is Data Leakage?

Data leakage occurs when **information outside the training set sneaks into the model during the learning process**, causing it to perform unrealistically well in evaluation but fail in production.

---

## The Core Principle

At evaluation time we are **simulating a real prediction scenario**. For that simulation to be valid, two things must hold:

1. The model must **not have learned from evaluation data**
2. Every feature must **reflect only information that would be available at the moment a real prediction is needed**

> Every form of leakage violates at least one of these two conditions.

---

## Form 1: Target Leakage

The feature directly encodes the target, or reflects events that happen **after** the prediction point.

**Examples:**
- Predicting whether a loan defaults, but including a feature like `"missed_payment"` — which only exists *because* the default already happened
- Predicting hospital readmission using a feature collected after discharge
- Any field that is a downstream consequence of what you're trying to predict

**Why it's subtle:** these features have high predictive power, so the model eagerly uses them. The problem only becomes obvious when the model fails on new data where those future values don't exist yet.

```
Timeline:
  [Prediction point] -----> [Event you're predicting]
         ↑                          ↑
  features must live here     target lives here
  
  Target leakage = a feature that lives here ----^
```

---

## Form 2: Train-Test Contamination

Test data influences the training process, breaking the independence between splits.

### Preprocessing Before Splitting

Applying transformations to the full dataset **before** splitting leaks test statistics into training:

- Fitting a scaler on all data → the mean and std include test rows
- Imputing missing values using the full dataset mean
- Encoding categories based on frequencies across all rows

**Fix:** always split first, then fit transformations **only on training data**, and apply (transform only) to test data.

```
Wrong:                          Right:
  full data                       full data
      ↓                               ↓
  normalize ← leaks test!         train / test split
      ↓                               ↓           ↓
  train / test split          fit scaler      apply scaler
                              on train only   to test only
```

### Other Common Sources

| Source | Why it leaks |
|---|---|
| Splitting time-ordered data randomly | Future rows end up in training set |
| Tuning hyperparameters on test scores | Test set guides model decisions |
| Duplicate rows across splits | Model has effectively seen test data |
| Feature engineering informed by test patterns | Test distribution shapes the features |

---

## Detecting Leakage

- Model accuracy is **suspiciously high** — especially near perfect
- Performance **drops sharply** when moving from evaluation to production
- A feature has **near-perfect correlation** with the target
- Feature importance shows a variable that **shouldn't logically exist** at prediction time

---

## Key Rules

1. **Split before you preprocess** — fit all transformers on training data only
2. **Check the timeline** — every feature must be available *before* the prediction moment
3. **Never touch the test set** until final evaluation — no hyperparameter tuning against it
4. **For time-series data** — always split chronologically, never randomly
