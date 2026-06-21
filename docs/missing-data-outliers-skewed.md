# Missing Data, Outliers, and Skewed Data

**Raw datasets almost always come with three kinds of problems**: some values are missing, some values are far outside the normal range, and the values that *are* present often don't follow the clean, symmetric distributions our models assume.

Each of these makes downstream analysis harder. Statistical summaries (means, variances, correlations) can be misleading when they're computed over data with missing or extreme values; machine learning models can fit to noise instead of signal when distributions are heavily skewed. Before any modeling step, the data has to be inspected and cleaned.

This page covers the three problems in turn — what they are, how to detect them, and what your options are for handling them.

## Missing data

**Missing data** means that a value we expected to have isn't there — represented as `NaN`, `NULL`, an empty string, or a placeholder like `-1` or `9999`.

### Why we have missing data

Missing data isn't random — it usually has a reason, and the reason matters because it changes what you're allowed to do about it. The standard taxonomy splits missingness into three categories:

- **MCAR — Missing Completely At Random.** The missingness has nothing to do with the data. A respondent simply skipped a question, or a sensor occasionally dropped a reading. This is the **cleanest case** — there is **no pattern** in which values are missing, so dropping them costs you sample size but doesn't introduce bias.
- **MAR — Missing At Random.** The missingness depends on **other observed variables**, but not on the missing value itself. Older respondents skip income questions more often, but among people of the same age, income is missing at random. Imputation can usually recover this case because the missingness is explained by something we *do* have.
- **MNAR — Missing Not At Random.** The missingness depends on the **missing value itself**. A device at high temperature stops reporting its temperature; people with very high incomes refuse to disclose their income. This is the **hardest case** — imputing can **introduce systematic bias**, because the missing values are *not* random samples from the same distribution as the observed ones. They're specifically the extreme ones.

You can rarely prove which category your data is in, but a quick exploration (which rows are missing, which columns predict missingness) gives you a strong working theory.

### When to drop vs impute

The choice between dropping and imputing depends on **how much** is missing and **where**. A few rules of thumb:

- **Column-level: if a column has more than ~50–70% missing values**, consider **dropping the column** entirely — or at least replacing it with a binary **missingness indicator** (a flag column that says "was this value present?"). At that scale, there isn't enough signal left to impute reliably, but the *pattern* of missingness might itself be informative.
- **Row-level: if a row has many missing values simultaneously**, **removing the row** is often better than trying to repair it. Imputing a row that's mostly holes is mostly fabrication.
- **Cell-level: if missing values are rare** (around **5%** of a column, say), **imputation is the better choice**. You preserve sample size, and the imputed values are unlikely to dominate the column's statistics.

A useful way to think about it: imputation is "filling in the gaps" — it works well when there *are* mostly known values to interpolate from. Once the gaps outweigh the known values, you're inventing data, not recovering it.

### How to handle it

In rough order from simplest to most sophisticated:

- **Drop rows** with missing values (`df.dropna()`). Fine if missingness is small and MCAR.
- **Drop columns** that are mostly missing. If a feature is past the 50–70% threshold, it's usually not worth saving.
- **Fill with a constant** — `0`, `"unknown"`, or a sentinel value. Loses information but is fast and explicit.
- **Mean / median imputation** — replace missing numeric values with the column mean or median. Quick, but shrinks variance and can distort relationships.
- **Group-based imputation** — fill with the mean *within a relevant group* (e.g. fill missing income by occupation).
- **Model-based imputation** — predict the missing value using the other features (KNN imputation, iterative imputation, regression).
- **Add a "was-missing" flag column.** Whatever you fill in, also create a boolean column saying "this row was originally missing." Lets a model learn from the missingness pattern itself — especially valuable when you suspect MNAR.

Median is usually safer than mean because it's robust to outliers — which connects directly to the next section.

### Imputation strategies

Once you've decided to impute (rather than drop), the next question is **what value to fill in**. The choice depends on the type of feature and the shape of its distribution.

#### Mean imputation

Replace missing values with the **column mean**.

- **When to use:** numerical features that are roughly **symmetric** and have **no significant outliers**.
- **Why:** the mean represents the "center" of a symmetric distribution well. With no outliers to drag it around and no skew to displace it, the mean is a reasonable guess at a typical value.
- **Caveat:** mean imputation shrinks the column's variance (every imputed point sits exactly at the mean), which can weaken correlations and hurt model calibration.

#### Median imputation

Replace missing values with the **column median**.

- **When to use:** numerical features with **skewed distributions** or **visible outliers**.
- **Why:** the median is **robust to outliers** — it's a positional statistic, so even a few extreme values can't pull it far. It's also less affected by skew than the mean.
- **Practical rule:** for most regression problems, median is the **safer default** than mean. If you're not sure which to pick, start with median.

#### Mode imputation

Replace missing values with the **most common value** in the column.

- **When to use:** **categorical** features (`color`, `country`, `device_type`) and **binary** features (`is_active`).
- **Why:** "mean" doesn't make sense for categorical data — there's no numeric center. The mode picks the single most frequent category, which is the cheapest guess at a typical value.
- **Caveat:** if there are several categories with similar frequencies, mode imputation can over-represent the winner. Consider adding a missingness flag.

#### Constant value imputation

Fill missing values with a **specific value** — commonly `0`, `-1`, `"unknown"`, or another sentinel.

- **When to use:** when the missingness *itself* is meaningful, when you want the model to be able to detect it, or when the data type doesn't have a natural center.
- **Why:** simple and explicit. A tree-based model can learn a separate branch for the sentinel; a downstream pipeline can spot it easily.
- **Caveat:** sentinel values look like real numbers to many models. Pairing them with a missingness flag avoids the "is this a real `-1` or a marker?" ambiguity.

### Don't leak — compute imputation statistics from training data only

> **All imputation statistics — mean, median, mode, constants — must be computed from the *training* data only**, and then applied to the test set (and to any future data) using the **same values**.

This is one of the most common causes of **data leakage** in machine learning pipelines. If you compute the median over the full dataset (including the test set) and use it to fill in training values, your model has indirectly seen information from the test set during training, and your evaluation will look more optimistic than it really is.

The right pattern, in scikit-learn terms:

```python
from sklearn.impute import SimpleImputer

imputer = SimpleImputer(strategy="median")
imputer.fit(X_train)              # learn the median from training data only
X_train = imputer.transform(X_train)
X_test  = imputer.transform(X_test)   # apply the same training-learned median
```

The same principle applies to scaling, encoding, and every other preprocessing step: **fit on train, transform on test**.

## Outliers

An **outlier** is a value that's far from the rest of the distribution. They can come from real, rare events (a stock crash, a billionaire in an income survey) or from data errors (a typo, a sensor glitch, a wrong unit).

### Investigate first

Before changing anything, **check whether the value is a data error or a real extreme observation**. A "100-year-old infant" is a typo; an actual centenarian is data. A car listed at ₹1 with 200,000 km on the odometer is almost certainly a unit mismatch or a placeholder; a luxury car at ₹50,000,000 is real. The right treatment depends entirely on which one you have, and the only reliable way to tell is to look — at the row, at the source, at the units, at a sample of similar rows nearby.

Common sources of fake outliers:

- **Typos** — an extra zero, a misplaced decimal point.
- **Unit mismatches** — one row in grams, the rest in kilograms; one column in dollars, another in cents.
- **Sensor glitches / placeholders** — `-999`, `9999`, `0`, or the column's max as a "no reading" sentinel.

Real outliers — extreme but valid measurements — usually still need to be considered carefully, but they don't get "fixed."

### Why they matter

Outliers wreak havoc on summary statistics and many models:

- **Mean and variance** are extremely sensitive to outliers; even a single extreme point can move them far.
- **Linear regression** tries to minimize squared error, so a single outlier pulls the entire fit toward itself — the few large errors dominate the loss function.
- **Distance-based methods** (KNN, K-means) treat the outlier as a competitor for cluster membership.

Robust alternatives (median, IQR, MAD, tree-based models) handle outliers naturally — which is one reason to know what your tools are sensitive to.

### How to detect them

- **Visually** — boxplots, histograms, scatter plots. The eye is very good at spotting "one of these is not like the others."
- **Z-score** — `|(x − mean) / std| > 3` is the textbook threshold. Quick, but the threshold assumes a roughly normal distribution and uses the very statistics outliers distort.
- **IQR rule** — flag points below `Q1 − 1.5·IQR` or above `Q3 + 1.5·IQR`. This is what a boxplot uses. Robust because it relies on quartiles, not the mean.
- **Domain knowledge** — a heart rate of 350 bpm is impossible; a temperature of −500 °C is impossible. The cheapest detector is often a sanity check against what the value *could* physically mean.

### Four ways to handle an outlier

There's no one right answer — it depends on whether the outlier is "real" or an error and on how much you want it to influence the model:

- **Remove** when the outlier is a **data error with no meaningful interpretation**. Drop the row (or the value) and move on.
- **Clip (Winsorize)** when the outlier is **real but you don't want it to dominate the loss function**. Replace extremes with a percentile cap — for example, anything above the 99th percentile becomes the 99th percentile. The row stays in the dataset, but its influence is bounded.
- **Transform** — apply **log or square root** — when the outlier is one extreme of a **right-skewed distribution**. The log transform compresses the right tail without removing any values. Appropriate for targets and features where values are all positive and span several orders of magnitude. (This is where outlier handling and skewness handling overlap; see the next section.)
- **Keep** when the outlier is **genuinely informative for the prediction task**. Fraud detection, rare-disease classification, anomaly detection — the outliers *are* the signal.

### Two rules to avoid leakage

Two crucial rules apply here, one for each treatment:

> **For removing rows: never drop outlier rows from the test set.**
>
> The test set represents the real-world distribution the model will face in deployment, which includes extreme values. Removing them hides the model's actual behavior on hard cases — you'll look better on paper than you really are.

> **For clipping: compute your thresholds from the training set only, then apply the same thresholds to the test set.**
>
> A car scored in deployment might have unusually high mileage; you cap it at the **training-set 99th percentile**, exactly as you capped the training data. The test set never determines any thresholds — it only receives the transformations you derived from training.

The same fit-on-train / transform-on-test discipline we saw with imputation applies here. Any preprocessing step that uses statistics computed from data must compute those statistics from the training data only.

## Skewed data and transforms

Many numerical features and targets are **right-skewed**: most values are small, but a long right tail pulls the mean above the median. Prices, incomes, mileage readings, file sizes, response times — almost every "amount" variable looks this way.

Skew hurts **linear models** in particular: the few large values dominate the squared error, so the model fits the expensive few and underfits the typical many. The model's "average customer" ends up being closer to the long tail than to the actual typical customer.

### Log transform — the most common fix

The most common fix is a **log transform**. The log compresses large values **far more** than small ones and pulls the long tail in toward a symmetric shape:

```python
import numpy as np
x_log = np.log1p(x)   # log(1 + x), safe when x contains zeros
```

Why `log1p`? Because `log(0)` is undefined (it's `-∞`). `np.log1p(x)` computes `log(1 + x)`, which gracefully handles zeros and very small values. It still only works on **non-negative** input.

### Transforming the target

The **highest-impact place to apply the log transform is often the target itself**. Training on `log1p(price)` makes the model optimize **proportional error** rather than absolute error: a ₹50,000 miss on a ₹200,000 car counts for more than the same ₹50,000 miss on a ₹2,000,000 car. That's almost always what you actually want for prices, incomes, and durations.

Two things to remember if you go this route:

- The model now **predicts in log space**, so you have to invert the transform before reading the prediction as a real price:

  ```python
  prediction_log = model.predict(X_test)
  prediction     = np.expm1(prediction_log)   # inverse of log1p
  ```

- **Forgetting to invert is a common, silent bug** that makes predictions come out absurdly small (your model says a house costs ₹13). It compiles, it runs, the metrics look broken — but the cause is just a missing `expm1`. Always double-check the inverse step when training on a transformed target.

### Other transforms

Log is not the only tool. Pick based on how strong the skew is and what values you have:

- **Square root** — milder than log, also handles zeros, suits **count data** (number of events, number of visits).
- **Reciprocal (`1 / x`)** — stronger than log, for **severe skew**. Doesn't handle zero.
- **Box-Cox** — a parameterized power transform that finds the best exponent automatically. Requires **strictly positive** data.
- **Yeo-Johnson** — generalization of Box-Cox that **handles zeros and negative values**. Good default for general-purpose power transforming.

Both Box-Cox and Yeo-Johnson are available through scikit-learn's `PowerTransformer`.

### For left-skewed or negative-valued data

A plain log doesn't apply when the data is **left-skewed** (long tail to the left) or includes **negative values**. Reach for a **power transform** instead — **Box-Cox** for strictly positive data, **Yeo-Johnson** when zeros or negatives are in play. These find the best transformation automatically rather than relying on a fixed formula like `log`.

### Always check before and after

Whichever transform you choose, **compare the histogram before and after**. The goal is a **more symmetric shape**, not a reflex. If the "after" picture is still skewed, the transform didn't help much; if it's now skewed the other way, you over-corrected. The plot tells you in seconds whether the fix worked.

## How these three problems interact

They're not independent — they tend to show up together and amplify each other:

- A **missing-data placeholder** like `-999` looks like a giant outlier to anything that doesn't know it's a sentinel.
- **Outliers** are more common in **skewed** distributions almost by definition — the long tail *is* the extreme region.
- **Mean imputation** of missing values pulls the mean toward whatever you imputed, which interacts badly with both outliers and skew.

A reasonable order of operations: **understand missingness first**, **handle obvious data errors next**, **then look at distributions and decide whether to transform**, **and only then start computing summary statistics or fitting models**. Doing it in any other order tends to bake bad assumptions into the cleaned dataset.

## Key takeaway

Raw data always has missing values, outliers, and skewed distributions, and **none of them go away if you ignore them** — they just get baked into your summary statistics and your models. The basic moves are the same shape for all three: **detect** the problem (visually and statistically), **understand** where it comes from, and **choose** between dropping, transforming, imputing, or modeling around it. Cleanup isn't glamorous, but it's the single biggest determinant of how trustworthy everything downstream will be.
