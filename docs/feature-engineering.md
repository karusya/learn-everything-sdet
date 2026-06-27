# Feature Engineering

## Why feature engineering matters

A **linear model** can only do one thing: **add and multiply its inputs by fixed coefficients**. The prediction for a row is `w₁·x₁ + w₂·x₂ + ... + b` — a weighted sum, period. That's a powerful structure, but it has a sharp limit: it can only represent **linear relationships** between the inputs and the target.

The moment a real relationship isn't linear — house price grows faster than square footage, customer spend depends on the *interaction* of age and income, response time has a sudden cliff after 10 seconds — a linear model can't see it on its own. You can hand it `x` all you want; if the true effect is `x²`, or `x · y`, or `log(x)`, or "weekday vs weekend," the weighted sum will never recover that shape.

**This is where feature engineering comes in.** It's the process of **creating new input features from the existing ones** so that the model has the **right information in the right shape** to learn from. Done well, it turns a problem the model can't solve into one it solves easily — sometimes with a much simpler algorithm.

A useful way to think about it: feature engineering moves the burden of "understanding the data" from the model to the human. The human knows that price scales with the *log* of square footage, that risk depends on age *and* income jointly, that purchases spike on weekends. By computing those features explicitly, you let the model focus on what it's actually good at — weighting them.

## The core idea

A model learns the **mapping from features to target**. If the features already encode the structure of the real-world relationship, the mapping is easy. If they don't, the model has to find the structure on its own — and many models simply can't.

Three rough goals of feature engineering:

1. **Linearize non-linear relationships** — so linear models can fit them.
2. **Expose interactions** — so the effect of one feature can depend on another.
3. **Encode domain knowledge** — so the model doesn't have to rediscover things you already know.

## Common techniques

### Polynomial features and interactions

If the effect of a feature is non-linear, give the model the **non-linear version** explicitly:

- **Polynomials:** add `x²`, `x³`, `√x`, `1/x`. Lets a linear model fit curves.
- **Interactions:** add `x · y`. Lets the effect of `x` depend on `y` (and vice versa). Crucial for cases like "discount only matters for premium customers" — the joint product `is_premium · discount` captures it; neither feature alone does.

```python
df["sqft_squared"]    = df["sqft"] ** 2
df["age_x_income"]    = df["age"] * df["income"]
```

scikit-learn's `PolynomialFeatures` generates all combinations up to a chosen degree, but be careful — the number of features grows fast.

### Binning (discretization)

Convert a continuous feature into **bins** or **categories**:

- **Equal-width** — `[0–10), [10–20), [20–30)`
- **Equal-frequency (quantile)** — each bin has roughly the same number of rows
- **Domain-based** — `child, teen, adult, senior` for age

When to use it: the relationship is non-monotonic (e.g., risk is highest for *very young* and *very old* drivers), or there's a natural threshold (a 10-second response feels totally different from a 11-second one), or you want the model to ignore minor noise within a band.

The cost: you lose resolution within each bin. Worth it when the within-bin variation isn't meaningful for the target.

### Date and time features

A raw timestamp like `2026-06-21 14:30:00` is useless to a model directly. Break it into components that **carry the actual signal**:

- **Calendar parts:** year, month, day of month, day of week, hour, minute.
- **Cyclical features:** month-of-year and hour-of-day are circular (December is next to January). Encoding them as `sin(2π · hour / 24)` and `cos(2π · hour / 24)` preserves that wrap-around.
- **Flags:** `is_weekend`, `is_holiday`, `is_business_hour`.
- **Durations / lags:** `days_since_signup`, `time_since_last_purchase`.

For most applications, calendar parts + a `is_weekend` flag get you most of the way there.

### Ratios and differences

A model that gets `revenue` and `cost` separately won't necessarily figure out **profit margin** — that's `(revenue − cost) / revenue`. Explicitly precomputing the ratio or difference often outperforms expecting the model to discover it:

- **Ratios:** `price / sqft`, `clicks / impressions`, `weight / height²` (BMI).
- **Differences:** `current_year_revenue − last_year_revenue`, `actual − expected`.

These are particularly important for **linear models**, which can't construct ratios at all from raw inputs.

### Aggregations and grouped statistics

For each row, attach a **summary statistic computed over a group**:

- `avg_price_per_neighborhood` joined onto every house in that neighborhood.
- `customer_avg_basket_size` joined onto every transaction by that customer.
- `product_30d_sales_count` joined onto every row that references that product.

These features let the model "see" context the individual row doesn't carry. They're also a leading cause of **data leakage** if computed carelessly — make sure the aggregation only uses data from before the row's timestamp, or only from the training set.

### Domain-derived features

The highest-leverage feature engineering usually comes from **encoding domain knowledge** the model can't infer from the raw inputs alone:

- For real estate: `total_bathrooms = full_baths + 0.5 · half_baths`, `has_garage`, `is_corner_lot`.
- For e-commerce: `days_until_event`, `is_returning_customer`, `cart_value_per_item`.
- For finance: `debt_to_income`, `current_ratio`, `volatility_30d`.

These features encode the **shorthand experienced people use to reason about the problem**. A model that sees them learns much faster than one that has to reconstruct them from primitives.

### Transformations for skew and outliers

We covered these in the data-cleaning notes, but they're feature engineering too:

- **Log / `log1p`** — for right-skewed, all-positive features spanning multiple orders of magnitude.
- **Square root** — gentler than log; good for counts.
- **Box-Cox / Yeo-Johnson** — automatic power transforms.
- **Clipping / Winsorizing** — bound extreme values without removing them.

### Categorical encoding

Most models can't consume `"red"` directly. Encode it:

- **One-hot encoding** — one column per category. Standard default for nominal categories with low cardinality.
- **Ordinal encoding** — assign integers when the category has a meaningful order (`low < medium < high`).
- **Target / mean encoding** — replace each category with the mean of the target for that category. Powerful but leaks easily — must be computed with cross-validation or out-of-fold.
- **Frequency encoding** — replace each category with how often it appears. Simple and surprisingly strong.

Encoding is its own subfield, but every model needs *some* answer for categoricals.

## A useful workflow

A rough order of operations when feature engineering on a new problem:

1. **Look at the target.** Skewed? Bounded? Counts? Apply a transform if needed.
2. **Audit each feature for type and shape.** Categorical? Continuous? Skewed? Outliers? Apply the right cleanup / transform.
3. **Add domain-derived features.** What ratios, flags, and combinations would a human expert care about?
4. **Add interactions** between any features whose effects you suspect depend on each other.
5. **Add aggregations** for any group-level context the row should carry.
6. **Check leakage** at every step. Did you use information from the future or from the test set?
7. **Validate.** Train a model with and without the new features. The features that don't help, throw out.

## When feature engineering matters less

Modern models can do some of this work for you:

- **Tree-based models** (random forest, gradient boosting) can fit non-linear and interactive relationships from raw features, so they care less about explicit polynomials or interactions. They still benefit from domain-derived features and clean ratios.
- **Deep learning** on tabular data can in principle learn arbitrary transformations, but in practice, well-engineered features still help — especially when data is limited.
- **Linear models** are at the other extreme — they can do almost nothing themselves, so they benefit most from heavy feature engineering.

A good heuristic: **the simpler the model, the more feature engineering it needs**. Even with powerful models, hand-crafted features remain one of the highest-ROI activities in a typical ML project.

## Key takeaway

A linear model can only add and multiply its inputs by fixed coefficients — anything more complex (curves, interactions, thresholds, ratios, calendar effects) has to be **handed to it** as a pre-computed feature. **Feature engineering** is the practice of creating those features from the raw data so that the model has the **right information in the right shape**. The standard tools — polynomials, binning, date parts, ratios, aggregations, domain features, transforms, encodings — are the vocabulary; choosing the right one for each problem is the craft.
