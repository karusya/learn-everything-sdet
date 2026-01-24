---
title: ML Problem Framing — Core Notes
summary: How to break down a problem, define success criteria, and decide whether machine learning is the right solution.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# ML Problem Framing

## What is problem framing?

**Problem framing** is the process of dissecting a problem into separate elements that need to be resolved.

It focuses on:
- Understanding what the real problem is
- Defining clear goals
- Deciding how success will be measured

Problem framing happens **before** choosing models or writing code.

---

## Why problem framing matters

Correct framing ensures that:
- The problem is solvable with machine learning
- The ML solution aligns with the real goal
- Effort is not wasted on inappropriate approaches

Poor framing often leads to:
- Wrong optimization targets
- Models that perform well technically but fail in practice

---

## Main outcomes of problem framing

The key outcomes of framing are:
- A clear decision on **whether ML is needed**
- The ability to **express the problem in ML terms**
- A shared understanding of **what success looks like**

---

## Framing the problem with ML terms

To frame a problem for ML, you must be able to identify:
- Inputs (features)
- Outputs (labels)
- A measurable objective (metric or loss)

If these cannot be defined, the problem is likely **not ready** for ML.

---

## Steps to understand and frame the problem

### 1. State the goal
- Clearly define what you want to achieve
- Express the goal in business or product terms

### 2. Check if the problem can be solved with ML
- Look for patterns rather than rules
- Confirm that predictions or probabilistic outputs are acceptable
- Ensure the task benefits from learning from data

### 3. Verify data availability
- Confirm that data exists
- Check whether data includes:
  - Features
  - Labels (or reasonable proxy labels)
- Ensure data quality and relevance

Without data, an ML model cannot be trained.

---

## Summary

- Problem framing breaks a problem into solvable parts
- It defines goals and success criteria
- The main result is deciding whether ML is appropriate
- Framing requires clear goals, ML-formulation, and available data
- Good framing is a prerequisite for successful ML projects

# ML Problem Framing — Decision Steps

## Step 1: Define the goal in real-world terms

- Clearly state **what problem needs to be solved**
- Describe the desired outcome without ML terminology
- Focus on **business or product impact**, not algorithms

Example:
- “Reduce incorrect approvals” instead of “build a classifier”

---

## Step 2: Decide whether this is an ML use case

Machine learning is broadly divided into two systems:

### Predictive Machine Learning
- **Outcome:** makes a prediction (number, class, probability)
- **Training:** uses large amounts of **labeled data**
- **Typical tasks:** regression, classification, ranking

Examples:
- Predict demand
- Detect fraud
- Estimate prices

---

### Generative AI
- **Outcome:** generates new content based on user intent
- **Training:** uses large amounts of **unlabeled data**
- **Typical outputs:** text, images, audio, code

Examples:
- Text generation
- Image creation
- Code assistance

---

## Step 3: Try to solve the problem manually

Before using ML:
- Attempt a solution using **rules or heuristics**
- Check if simple logic produces acceptable results
- Evaluate clarity, reliability, and maintenance effort

If heuristics work well, ML may be unnecessary.

---

## Step 4: Decide if ML is worth it

Evaluate the ML solution based on:
- **Cost** (development, infrastructure, data labeling)
- **Maintenance** (monitoring, retraining, drift handling)
- **Performance gains** over manual or rule-based solutions

ML should be chosen only if it provides **clear, measurable benefits** that justify its complexity.

---

## Summary

- Start by defining the real-world goal
- Confirm the problem fits predictive ML or generative AI
- Try heuristic solutions first
- Choose ML only if it outperforms simpler approaches in cost and maintenance




# ML Problem Framing — Data Criteria, Predictive Power, and Actionability

## Why data evaluation matters

Even if a problem looks suitable for ML, the solution will fail if the **data does not meet key criteria**.

For problem framing, data must:
- Support learning
- Enable useful predictions
- Lead to meaningful actions

---

## Data criteria

For ML to work, data should meet the following criteria:

### Availability
- Data must exist and be accessible
- Features and labels (or proxy labels) must be obtainable

### Quality
- Data should be accurate and consistent
- Missing values, noise, and errors should be manageable

### Representativeness
- Data should reflect real-world conditions
- Training data and production data should come from similar distributions

### Size and diversity
- Sufficient number of examples
- Coverage of different scenarios and edge cases

Without these properties, model predictions will be unreliable.

---

## Predictive power

**Predictive power** describes whether the available data can actually predict the target.

To assess predictive power:
- Check if features contain information related to the label
- Look for patterns beyond randomness
- Validate that predictions perform better than a baseline

Signs of low predictive power:
- Predictions close to random guessing
- Very small improvement over simple heuristics
- High variance across datasets

If data has no predictive signal, ML will not help.

---

## Actionability

A prediction is only valuable if it leads to an **action**.

Actionability means:
- Predictions influence decisions
- Different predictions result in different outcomes
- Acting on predictions creates measurable value

Examples:
- Predicting churn is actionable only if retention actions exist
- Predicting demand is useful only if supply can be adjusted

If no action follows a prediction, the ML system provides little value.

---

## Connecting prediction to action

When framing the problem, always ask:
- What decision will be made using this prediction?
- Who or what acts on the output?
- What happens if the prediction is wrong?

This ensures the model supports real-world workflows.

---

## Summary

- Data must meet criteria for availability, quality, and representativeness
- Predictive power determines whether learning is possible
- Actionability determines whether predictions are useful
- ML is justified only when all three are present


# Proxy Labels, Generative Techniques, and Model Decisions

## Proxy labels

**Proxy labels** are substitutes for true labels when those labels are **not available in the dataset**.

They are used when:
- The true outcome cannot be measured directly
- Label collection is too expensive or slow
- The real signal exists but is implicit

Examples:
- Clicks as a proxy for user interest
- Time spent as a proxy for content quality
- Purchases as a proxy for satisfaction

Limitations:
- Proxy labels may be noisy
- They may not fully represent the real objective
- They can introduce bias if poorly chosen

---

## Techniques to guide generative models

To make a generative model produce the desired output, several techniques can be used.

### Distillation
- A smaller model learns from a larger, more capable model
- Used to reduce cost and latency
- Preserves most of the original model’s behavior

---

### Fine-tuning
- Adjusting a pre-trained model using task-specific data
- Improves performance on narrow or domain-specific tasks
- Requires labeled or curated data

---

### Prompt engineering
- Designing structured inputs to guide model behavior
- Does not change model weights
- Fast and low-cost compared to training

---

## Success metrics

**Success metrics** are defined to determine whether work on a model is effective.

They help answer:
- Is the model useful?
- Is further improvement justified?
- Is the model ready for production?

Metrics should:
- Align with the model goal
- Reflect real-world impact
- Be consistently measurable

---

## Deciding if a model is worth improving

When evaluating a model, consider the following outcomes:

### Not good enough, but continue
- Model should **not** be used in production
- There is strong potential for improvement
- Additional data or iteration may significantly help

---

### Good enough, and continue
- Model **can** be used in production
- Further improvements are possible
- Iteration may increase value

---

### Good enough, but can’t be made better
- Model is already in production
- Performance is near theoretical or practical limits
- Further work is unlikely to justify the cost

---

### Not good enough, and never will be
- Model should **not** be deployed
- Data or signal is fundamentally insufficient
- No realistic amount of training will make it viable

---

## Recommendations for building models

1. **Start simple**
   - Use baselines and simple approaches first
   - Avoid unnecessary complexity early

2. **Decide between training vs reusing**
   - Train your own model when:
     - Domain is unique
     - Data is proprietary
   - Use a pre-trained model when:
     - Task is common
     - Cost and speed matter

---

## Summary

- Proxy labels replace missing true labels
- Generative models can be guided via distillation, fine-tuning, or prompts
- Success metrics determine whether progress is meaningful
- Clear decision categories prevent wasted effort
- Simple solutions and existing models should be considered first
