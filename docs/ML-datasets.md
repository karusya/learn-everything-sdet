---
title: Train, Validation, and Test Sets — Core Workflow
summary: Dataset splitting principles, workflow, and criteria for reliable validation and testing in ML.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Train, Validation, and Test Sets

## Why dataset splitting is necessary

To properly evaluate a machine learning model, data must be split into separate subsets.

This prevents:
- Overfitting
- Overestimating performance
- Data leakage

The three standard subsets are:
- Training set
- Validation set
- Test set

---

## Data preparation before splitting

Before creating dataset splits:

- Remove duplicate examples
- Clean corrupted or inconsistent records
- Ensure label correctness

Duplicates must be removed because:
- They can inflate evaluation metrics
- They create data leakage between training and evaluation sets
- They reduce the reliability of model validation

---

## Training set

The **training set** is the data the model learns from.

During training:
- The model sees both features and labels
- The model updates its parameters
- Loss is minimized

The model directly fits patterns in this dataset.

---

## Validation set

The **validation set** is used during model development.

Purpose:
- Evaluate the model after training
- Detect overfitting
- Compare different model versions
- Tune hyperparameters

The model does not update its parameters using validation data.

---

## Test set

The **test set** is used at the final stage.

Purpose:
- Measure true generalization performance
- Simulate unseen real-world data

The test set must not influence model tuning.

---

## Criteria for a good validation or test set

A high-quality validation or test set must:

- Be large enough to produce statistically meaningful results
- Be representative of the overall dataset
- Be representative of real-world data the model will encounter
- Contain zero duplicated examples from the training set

If these conditions are not met, evaluation results may be misleading.

---

## Workflow

1. Clean data and remove duplicates
2. Split into training, validation, and test sets
3. Train the model on the training set
4. Evaluate on the validation set
5. Adjust the model if needed
6. Select the best-performing version
7. Evaluate once on the test set

---

## Summary

- Clean data before splitting
- Remove duplicates to avoid leakage
- Training set is for learning
- Validation set is for tuning
- Test set is for final evaluation
- Validation and test sets must be representative and independent
