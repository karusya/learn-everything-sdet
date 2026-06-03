# ML by Learning Paradigm

A complementary lens to data domain: the same dataset can be approached with different learning paradigms depending on what labels you have, what you're optimizing for, and how feedback is structured.

Three fundamental paradigms — supervised, unsupervised, reinforcement — plus modern variants that blur the lines.

---

## Supervised Learning

**Learn from labeled examples.**

You provide both the input data and the correct answers. The algorithm learns to map inputs to outputs by minimizing its error on the provided examples. At inference time, it generalizes this mapping to unseen inputs.

- Requires: **labeled data** (often expensive and time-consuming to collect)
- Feedback signal: the difference between predicted output and ground truth label (loss function)

### Structure

```
Input (X) + Label (Y)  →  Train model  →  Predict Y for new X
```

### Examples

| Task | Input | Label |
|---|---|---|
| Email spam detection | Email text | Spam / not spam |
| X-ray diagnosis | Chest X-ray image | Healthy / pneumonia |
| House price prediction | Square footage, location, etc. | Sale price |
| Speech recognition | Audio waveform | Transcript |

### Sub-tasks

- **Classification** — output is a discrete class (binary or multiclass)
- **Regression** — output is a continuous value
- **Structured prediction** — output is a structured object (sequence, tree, bounding box)

### Common Algorithms

- Logistic / Linear Regression
- Decision Trees, Random Forest, Gradient Boosting (XGBoost)
- Support Vector Machines
- Neural networks (when inputs are images, text, audio)

---

## Unsupervised Learning

**Find structure without a teacher.**

No labels — only raw input data. There is no "right answer" to optimize against. The algorithm discovers patterns, groupings, or compressed representations inherent in the data.

- Requires: **unlabeled data** (cheap and abundant)
- Feedback signal: none external; optimization targets internal criteria (cluster cohesion, reconstruction error, etc.)

### Structure

```
Input (X) only  →  Train model  →  Discover structure in X
```

### Core Tasks

#### Clustering
Group similar data points together without predefined categories.

- Example: segment customers by purchasing behavior — model discovers natural groups without being told what the groups are
- Algorithms: **k-Means**, **DBSCAN**, **Hierarchical clustering**, **Gaussian Mixture Models**

#### Dimensionality Reduction
Compress high-dimensional data into fewer dimensions while preserving structure. Used for visualization, denoising, and as preprocessing.

- Example: compress 10,000-gene expression profiles to 2D for visualization
- Algorithms: **PCA**, **t-SNE**, **UMAP**, **Autoencoders**

#### Anomaly Detection
Identify data points that don't fit the learned distribution of "normal."

- Example: flag unusual network traffic without labeled attack examples
- Algorithms: **Isolation Forest**, **One-Class SVM**, **Autoencoders**

#### Generative Modeling
Learn the data distribution and sample new data points from it.

- Example: generate synthetic medical images for training data augmentation
- Algorithms: **VAEs**, **GANs**, **Diffusion models**

---

## Reinforcement Learning

**Learn through trial and error.**

An **agent** takes actions in an **environment**, receives **rewards** for good actions and **penalties** for bad ones. Learning happens through repeated interaction — no labeled dataset, no static training set. The agent improves its **policy** (mapping from states to actions) to maximize cumulative reward over time.

- Requires: a defined environment with a reward signal
- Feedback signal: scalar reward (often delayed, sparse, or noisy)

### Structure

```
Agent observes state  →  Takes action  →  Environment returns reward + new state  →  Agent updates policy  →  Repeat
```

### Key Concepts

- **Policy** — the agent's strategy; maps states to actions
- **Reward** — scalar signal indicating how good an action was
- **Value function** — estimated cumulative future reward from a given state
- **Exploration vs. exploitation** — balance between trying new actions and using what already works
- **Delayed reward** — the consequences of an action may only become clear many steps later (e.g., a bad move in chess)

### Examples

| Domain | Agent | Actions | Reward |
|---|---|---|---|
| **Games** | Game-playing AI (AlphaGo, OpenAI Five) | Board moves / controller inputs | Win/loss, score |
| **Robotics** | Robot arm | Joint torques | Task completion, efficiency |
| **LLM fine-tuning (RLHF)** | Language model | Token generation | Human preference score |
| **Ad bidding** | Bidding system | Bid amount | Revenue from click/conversion |
| **Drug discovery** | Molecule generator | Add/remove atoms | Predicted binding affinity |

### Common Algorithms

| Algorithm | Notes |
|---|---|
| **Q-Learning / DQN** | Learn value of each action in each state; Deep Q-Network extends with neural nets |
| **Policy Gradient (REINFORCE)** | Directly optimize the policy; high variance |
| **PPO (Proximal Policy Optimization)** | Stable, widely used; powers most modern RL applications including RLHF |
| **SAC (Soft Actor-Critic)** | Off-policy; sample efficient; strong in continuous action spaces (robotics) |
| **AlphaZero / MuZero** | Combines RL with tree search; superhuman game-playing |

---

## Modern Variants

The three paradigms above are foundational but increasingly blended in practice.

### Semi-Supervised Learning

**A small amount of labeled data + a large amount of unlabeled data.**

Labeling is expensive; unlabeled data is cheap. The model uses the unlabeled data to learn better representations, then refines with the small labeled set.

- Example: you have 200 labeled X-rays and 50,000 unlabeled scans — semi-supervised learning uses all 50,200 images
- Techniques: pseudo-labeling, consistency regularization, label propagation
- Tools: **FixMatch**, **MixMatch**, graph-based methods

### Self-Supervised Learning

**The model creates its own labels from the structure of the data.**

No human annotation required. The model is given a pretext task derived from the data itself — predicting a masked portion, predicting the next token, predicting if two image patches are from the same image. Solving this forces the model to learn rich, generalizable representations.

- **This is how modern LLMs are trained**: given a sequence of text, predict the next token. The "label" is just the next word in the corpus — no human needed.
- **Also how vision foundation models train**: mask patches of an image and predict the missing pixels (MAE), or learn that two augmented views of the same image should have similar embeddings (SimCLR, DINO)

| Model | Pretext task | Learned representation used for |
|---|---|---|
| **GPT / LLaMA** | Predict next token | Text generation, reasoning, classification |
| **BERT** | Predict masked tokens (MLM) | Text classification, NER, QA |
| **MAE** | Predict masked image patches | Image classification, detection, segmentation |
| **SimCLR / DINO** | Contrastive: augmented views → same embedding | Visual features without labels |

### Transfer Learning

Not a paradigm on its own, but the dominant practical workflow: **pretrain** a model on a large task with abundant data (often self-supervised), then **fine-tune** on a small task-specific labeled dataset.

- Self-supervised pretraining → supervised fine-tuning
- Powers nearly all modern NLP and computer vision applications

---

## Summary

| Paradigm | Labeled data | Feedback signal | Typical use |
|---|---|---|---|
| **Supervised** | Yes (required) | Ground truth label | Classification, regression, detection |
| **Unsupervised** | No | Internal criteria | Clustering, dimensionality reduction, generation |
| **Reinforcement** | No (uses rewards) | Environment reward | Games, robotics, LLM alignment (RLHF) |
| **Semi-supervised** | Small amount | Labels + unlabeled structure | Low-label medical, vision tasks |
| **Self-supervised** | No (self-generated) | Pretext task error | LLM pretraining, vision foundation models |
