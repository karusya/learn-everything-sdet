---
title: ML Production Cycle — Main Stages
summary: Overview of the machine learning production cycle, from project scoping to monitoring and business evaluation.
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 -->

# ML Production Cycle

Machine learning systems follow a **production cycle** that includes several stages from planning to deployment and evaluation.

The production cycle ensures that ML solutions:
- Solve real business problems
- Use reliable data
- Are monitored and maintained after deployment

There are **six main steps** in the ML production cycle.

---

## 1. Project scoping

The project begins with defining the **problem and objectives**.

Key activities:
- Define goals and expected outcomes
- Define constraints (cost, time, infrastructure)
- Establish evaluation criteria
- Identify stakeholders
- Involve stakeholders in planning
- Estimate and allocate resources

This stage ensures the project solves the **correct problem** and aligns with business needs.

---

## 2. Data management

Data management focuses on organizing and preparing data used for machine learning.

This includes:
- Identifying data sources
- Managing data formats
- Data processing and cleaning
- Data quality control
- Data storage and accessibility

Effective data management is critical because **data quality directly affects model performance**.

---

## 3. ML model development

In this stage, raw data is transformed into usable datasets and models are trained.

Main steps:
- Prepare datasets (training, validation, and test sets)
- Label data when required
- Generate and select features
- Train the model
- Evaluate model performance
- Test model behavior

The goal is to create a model that generalizes well to unseen data.

---

## 4. Deployment

Deployment moves the trained model into a **production environment**.

This allows the model to:
- Process real-world data
- Generate predictions or outputs
- Integrate with applications or systems

Deployment often involves:
- APIs
- Cloud services
- Batch or real-time inference pipelines

---

## 5. Monitoring and maintenance

Once the model is in production, it must be continuously monitored.

Monitoring focuses on:
- Model performance
- Prediction errors
- Data drift
- Model decay over time

Maintenance activities include:
- Updating the model
- Retraining with new data
- Adjusting to new environments or requirements

---

## 6. Business analysis

The final step evaluates how the model performs relative to **business goals**.

This includes:
- Measuring impact on business metrics
- Identifying insights from predictions
- Assessing return on investment
- Deciding whether further improvements are needed

Model performance should always be evaluated in terms of **business value**, not only technical metrics.

---

## Summary

The ML production cycle consists of:

1. Project scoping
2. Data management
3. Model development
4. Deployment
5. Monitoring and maintenance
6. Business analysis

Following this cycle helps ensure that ML systems remain reliable, useful, and aligned with business objectives.