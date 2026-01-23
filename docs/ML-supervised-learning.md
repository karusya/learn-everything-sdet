---
title: Supervised Learning — Core Concepts
summary: An overview of supervised machine learning, covering data, models, training, evaluation, and inference.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# Supervised Learning

## Overview

**Supervised machine learning** is based on learning a relationship between inputs and outputs using labeled data.

The core concepts of supervised learning are:
- Data
- Model
- Training
- Evaluating
- Inference

---

## Data

Data is the **driving force** of machine learning.

It can appear as:
- Numbers and words stored in tables
- Pixel values in images
- Waveforms in audio files

Related data is stored in **datasets**.

### Examples of datasets
- Images of cats
- Housing prices
- Weather information

---

## Dataset structure

A dataset is made up of **individual examples**.

An example is similar to:
- A single row in a spreadsheet

Each example contains:
- **Features**
- **Label**

### Features
- Input values used by the model to make predictions

### Label
- The “answer”
- The value the model is trying to predict

#### Example (weather prediction)
- Features: latitude, longitude, temperature, humidity, cloud coverage, wind direction, atmospheric pressure
- Label: rainfall amount

Examples that contain **both features and a label** are called **labeled examples**.

---

## Dataset characteristics

Datasets are characterized by:
- **Size** — number of examples
- **Diversity** — range of conditions covered by the examples

Good datasets are:
- Large **and**
- Highly diverse

However:
- A large dataset does not guarantee diversity
- A diverse dataset does not guarantee enough examples

### Examples
- 100 years of data only for July → poor predictions for January
- Few years of data covering all months → poor predictions due to limited historical variability

Both size and diversity are required for reliable learning.

---

## Model

In supervised learning, a **model** is a complex collection of numbers that defines a mathematical relationship between:
- Input features
