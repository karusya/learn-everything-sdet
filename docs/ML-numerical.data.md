---
title: Numerical Data and Feature Vectors
summary: Understanding numerical data, feature vectors, and common feature engineering techniques used in machine learning.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Numerical Data and Feature Vectors

## Numerical data

**Numerical data** represents measurable quantities expressed as numbers.

These values can be used directly in mathematical calculations and machine learning models.

Examples of numerical data:
- Temperature
- Weight
- Height
- Age
- Price
- Distance

Numerical data is commonly used as **input features** for machine learning models.

---

# Feature vectors

A **feature vector** is a collection (array) of numerical values that represents an example in a machine learning model.

In practice:
- Each example in a dataset is converted into a vector
- Each element of the vector represents one feature
- Values are typically stored as **floating-point numbers**

Example feature vector:

[temperature, humidity, wind_speed, pressure]
[22.5, 0.65, 12.3, 1013.2]

This numerical representation allows machine learning models to process and learn patterns from the data.

---

# Feature engineering

**Feature engineering** is the process of transforming raw data into a representation that a machine learning model can learn from effectively.

Goals of feature engineering:
- Improve model performance
- Convert raw data into numerical form
- Highlight useful patterns for the model

Feature engineering often involves:
- Transforming raw values
- Scaling data
- Creating new derived features

---

# Common feature engineering techniques

## Normalization

**Normalization** converts numerical values into a **standard range**, typically between 0 and 1.

Purpose:
- Prevent features with large scales from dominating the model
- Improve training stability

Example:

Original values: [0, 50, 100]
Normalized values: [0.0, 0.5, 1.0]

---

## Binning

**Binning** converts numerical values into **ranges (buckets)**.

Purpose:
- Simplify continuous data
- Reduce noise
- Capture broader patterns

Example:
Age values → bins

0–18   → child
19–35  → young adult
36–60  → adult
60+    → senior

This transformation can make patterns easier for some models to learn.

---

# Summary

- Numerical data represents measurable quantities expressed as numbers
- A feature vector is an array of numerical values describing one example
- Feature engineering transforms raw data into model-friendly representations
- Normalization scales values into a standard range
- Binning groups numerical values into ranges


# Data Preprocessing

## What is data preprocessing?

**Data preprocessing** is the process of preparing raw data so that it can be effectively used by a machine learning model.

It typically involves:
- Cleaning the data
- Transforming feature values
- Handling missing or incorrect values
- Scaling or normalizing data
- Creating additional features

The goal is to convert raw datasets into **high-quality, model-ready data**.

---

# Outliers

## What is an outlier?

An **outlier** is a value that is significantly distant from most other values in a feature or label.

Outliers can negatively affect:
- Model training
- Statistical estimates
- Model stability

### Types of outliers

Outliers can be categorized as:

**1. Outliers caused by mistakes**
- Measurement errors
- Incorrect data entry
- Sensor malfunction

These should usually be **removed or corrected**.

**2. Legitimate outliers**
- Rare but valid observations
- Natural extreme values

These may contain important information and should be **carefully evaluated** before removal.

---

# Normalization

## Why normalization is needed

Normalization transforms feature values so they exist on a **similar scale**.

Benefits include:

- Helps models converge faster during training
- Prevents features with large values from dominating others
- Improves prediction stability
- Reduces numerical instability (such as NaN values)
- Helps the model learn appropriate weights for each feature

---

# Common normalization methods

## Linear scaling

Linear scaling transforms values from their original range into a **normalized range**.

Two common approaches:

### Min–Max scaling

Rescales values to a fixed interval (often 0–1):
X_scaled = (X - min) / (max - min)

### Mean normalization

Centers values around the mean:
X_scaled = (X - mean) / (max - min)

### When to use linear scaling

Best used when:
- Feature bounds do not change significantly over time
- The dataset contains few or no outliers
- Values are roughly uniformly distributed

---

## Z-score scaling (standardization)

Z-score scaling converts values into **standard deviation units** from the mean.

Formula:
Z = (X - μ) / σ

Where:
- μ = mean
- σ = standard deviation

This transformation represents how many standard deviations a value is from the mean.

### When to use Z-score scaling

Best when:
- Data follows a **normal or near-normal distribution**
- Features have different units or ranges

---

## Log scaling

Log scaling applies the logarithm to the raw value.
X_scaled = log(X)
### When log scaling is useful

Log scaling is helpful when the data follows a **power-law distribution**, meaning:

- Small values occur very frequently
- Large values occur rarely
- Values span several orders of magnitude

Example:
- Movie ratings counts
- Website traffic
- Income distribution

---

# Handling outliers

## Clipping

**Clipping** limits extreme values to a specified maximum or minimum threshold.

Example:
If value > threshold → set value = threshold

Purpose:
- Reduce influence of extreme outliers
- Improve model stability

---

# Binning (Bucketing)

**Binning** converts numerical values into categorical ranges (bins).

Example:

Income
0–20k
20k–50k
50k–100k
100k+

### When to use binning

- When the relationship between feature and label is weak or nonlinear
- When feature values cluster naturally
- When interpretability is important

---

## Quantile bucketing

Quantile bucketing creates bins such that **each bin contains roughly the same number of examples**.

Benefits:
- Helps balance the dataset across bins
- Reduces the influence of extreme outliers

---

# Data scrubbing (data cleaning)

**Data scrubbing** removes unreliable examples from datasets.

Common problems include:

| Problem | Example |
|------|------|
| Omitted values | Missing age in a census record |
| Duplicate examples | Logs uploaded twice |
| Out-of-range values | Typing an extra digit |
| Incorrect labels | Mislabeling an image |

Scripts or data pipelines can detect:

- Missing values
- Duplicate entries
- Invalid feature ranges

---

# Qualities of good numerical features

Good numerical features should be:

- **Clearly named**
- **Validated before training**
- **Sensible and meaningful**
- **Consistent across the dataset**

High-quality features improve model accuracy and reliability.

---

# Polynomial feature transformations

Sometimes it is useful to create **synthetic features** from existing numerical features.

Example:

Original feature:
x

Polynomial features:
x²
x³

Purpose:
- Capture nonlinear relationships
- Improve model expressiveness
- Allow linear models to learn more complex patterns

---

# Summary

Data preprocessing prepares raw data for machine learning models.

Key techniques include:

- Detecting and handling outliers
- Normalizing feature values
- Applying transformations like log scaling
- Using binning and quantile bucketing
- Cleaning unreliable data
- Creating synthetic features such as polynomial features

Effective preprocessing significantly improves **model performance and stability**.