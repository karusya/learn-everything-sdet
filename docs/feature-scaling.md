# Feature Scaling

## What feature scaling is

**Feature scaling** is the practice of transforming numerical features so they live on a **comparable range**. It's about **correcting the algorithm's tendency to treat bigger features as more important** ones — purely because their raw numbers happen to be larger.

If one feature is "age" (0–100) and another is "income" (0–1,000,000), most algorithms will quietly behave as though income matters 10,000× more than age, because that's what the numerical magnitudes say. Scaling brings them onto the same playing field so the algorithm can decide on importance from the data, not from accidents of measurement.

## Why scale matters

**Scale matters because many algorithms work by computing distances or updating parameters in proportion to how much each feature contributes to the error.** If a feature's numbers are large, its contribution gets correspondingly amplified — without it actually being more informative.

A few concrete cases:

- **Distance-based methods** (KNN, K-means, hierarchical clustering, SVM with RBF kernel) compute Euclidean (or similar) distances between rows. A feature with a range of 1,000,000 will dominate the distance computation; a feature with a range of 5 will be ignored. The "closest" neighbors are decided almost entirely by the largest-scale feature.
- **Linear regression trained with gradient descent is sensitive to scale.** When features have very different magnitudes, the loss landscape becomes elongated and gradient descent zig-zags slowly toward the minimum. Scaling makes the landscape more spherical and gradient descent converges much faster.
- **Linear regression solved with its closed-form solution** (`(XᵀX)⁻¹Xᵀy`) is **not** sensitive to scale — the math compensates automatically. So scaling doesn't change the answer, but it can help with numerical stability and coefficient interpretability.
- **Regularized models** (Ridge, Lasso, ElasticNet) apply the same penalty to every coefficient, so a feature on a tiny scale gets effectively over-penalized and a feature on a huge scale gets effectively under-penalized. Scaling is essentially required.

**Scaling is standard practice** — close to automatic — for everything except tree-based models (random forest, gradient boosting). Trees split on thresholds, so they're invariant to any monotonic rescaling of an individual feature. You can skip scaling for them.

## The three main scalers

scikit-learn ships three workhorse scalers. Each one answers a slightly different question.

### `StandardScaler` — center and unit-variance

Subtracts the **mean** and divides by the **standard deviation**:

```
x_scaled = (x − mean) / std
```

After scaling, each feature has mean `0` and standard deviation `1`.

- **Best for:** gradient-based optimization (logistic regression, neural networks, SVMs) and regularized linear models. Works well when the feature is roughly symmetric and free of severe outliers.
- **Bonus:** makes **coefficients comparable on the same scale**, so you can read importance off them directly.
- **Caveat:** **outliers still exist after scaling — they're just centered.** A value 10× the std stays 10× the std; the scaler doesn't pull it in. If your feature has heavy outliers, the mean and std are themselves distorted, and the bulk of the data ends up squeezed near zero.

### `MinMaxScaler` — squash to a fixed range

Maps every value to the range `[0, 1]` by subtracting the minimum and dividing by the range:

```
x_scaled = (x − min) / (max − min)
```

- **Best for:** situations where a **bounded range is required** — input layers of some neural networks, pixel data for image models, anything that expects values in `[0, 1]`.
- **Caveat:** extremely **sensitive to outliers**. A single huge value sets `max`, and almost everything else collapses to a sliver near zero. Use only when you're confident the data has no extreme values (or you've already handled them).

### `RobustScaler` — use median and IQR

Subtracts the **median** and divides by the **interquartile range (IQR)**:

```
x_scaled = (x − median) / IQR
```

Because both the median and the IQR are positional statistics, they don't move when you add extreme values. So the scaling is computed from the bulk of the data, not from the tails.

- **Best for:** features with **genuine outliers that you want to preserve** but don't want distorting the scale. The bulk gets sensibly scaled; the outliers stay outliers in the scaled feature instead of dominating the scale.
- **Caveat:** the scaled range isn't fixed, and the distribution shape doesn't fundamentally change — only the influence of outliers on the *scaling* is neutralized.

## The one rule you can't break

> **Always fit your scaler on training data only, then apply it to both train and test.**

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
scaler.fit(X_train)               # learn mean & std from training data only
X_train = scaler.transform(X_train)
X_test  = scaler.transform(X_test)   # apply the same training-learned mean/std
```

This is the same fit-on-train / transform-on-test discipline we saw with imputation. If you fit the scaler on the full dataset (train + test), the test set has implicitly influenced the parameters the scaler learned, and your evaluation metrics will look slightly better than they really are. The leak is small per scaler but adds up across the pipeline.

## Which scaler to use — a decision framework

A simple decision tree that will steer you right in most situations:

1. **Start with `StandardScaler` as the default.** It's the right answer for the majority of linear and gradient-based models when features are roughly well-behaved.
2. **Switch to `RobustScaler` if your feature has outliers you can't remove.** When the bulk of the data sits in one range but a long tail or a handful of extremes can't be cleaned up, RobustScaler scales the bulk sensibly without letting the tail set the standard.
3. **Use `MinMaxScaler` only when a bounded range is required.** Some neural network input layers, image pixel data, or constraints from downstream tools that expect `[0, 1]`. Outside those cases, it's the riskiest of the three because of its outlier sensitivity.
4. **When in doubt: run the model with both `StandardScaler` and `RobustScaler` on a held-out set and pick the one with the lower error.** Two lines of code, one CV run, definitive answer.

## Common pitfalls

- **Fitting the scaler on the full dataset.** The most common leak — see the rule above.
- **Forgetting that tree models don't need scaling.** Adding it doesn't hurt much, but it adds complexity for no benefit.
- **Scaling and *then* splitting.** Same leakage problem as fitting on the full data; the split has to happen first.
- **Using MinMaxScaler without checking for outliers.** A single extreme value will collapse the rest of the feature to a sliver near zero.
- **Choosing a scaler before transforming a skewed feature.** If a feature spans many orders of magnitude, **log-transform first**, then scale. No scaler fixes skew — they all just rescale whatever shape the data currently has.

## Key takeaway

Feature scaling exists to **prevent the algorithm from confusing "big numbers" with "important features."** For distance-based and gradient-based models, raw scale dominates the math; scaling brings every feature onto comparable footing so the model can learn from the data instead of from measurement artifacts. The three workhorses — **StandardScaler** (default), **RobustScaler** (outliers), **MinMaxScaler** (bounded range) — cover almost every case, with the universal rule that you **fit on training data only** and apply the same parameters to test. And when a feature is heavily skewed, **transform before you scale** — scaling alone won't fix the shape.
