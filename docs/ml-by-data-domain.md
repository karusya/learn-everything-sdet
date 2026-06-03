# ML by Data Domain

The type of data you're working with largely determines which ML techniques are appropriate. This is one of the most practical mental models for choosing an approach.

---

## Tabular Data

Rows and columns — spreadsheets, relational databases, CSVs.

**Tree-based ensemble methods dominate** and routinely outperform deep learning on tabular benchmarks.

### Algorithms

| Method | Notes |
|---|---|
| **XGBoost / LightGBM / CatBoost** | Go-to for most tabular tasks; handles mixed types, missing values, and non-linearities well |
| **Random Forest** | Strong baseline; robust to overfitting via bagging |
| **Linear models** (Ridge, Lasso, Logistic Regression) | Fast, interpretable; good when relationships are approximately linear |
| **SVMs** | Effective on smaller datasets with clear decision boundaries |
| **k-NN** | Distance-based; sensitive to scale and dimensionality |
| **Neural nets** (TabNet, FT-Transformer) | Narrowing the gap with tree methods but still rarely win outright |

### Common Tasks

- **Classification** — predict a category (churn, fraud, diagnosis)
- **Regression** — predict a continuous value (price, demand, risk score)
- **Ranking** — order items by relevance (search, recommendations)
- **Anomaly detection** — flag outliers (fraud, sensor faults)

---

## Image Data & Computer Vision

Teaching machines to understand and interpret images and video.

Pixel grids — photos, medical scans, satellite imagery, video frames.

**Convolutional Neural Networks (CNNs)** have been the dominant architecture since 2012; **Vision Transformers (ViTs)** are now competitive at scale. Computer vision is almost exclusively a deep learning domain.

### Core Tasks

#### Classification
Assign a label to an entire image.

- Input: image → Output: class label
- Example: **X-ray image → "healthy" or "pneumonia"** — model learns visual patterns associated with pathology
- Tools: ResNet, EfficientNet, ViT

#### Object Detection
Locate *and* classify multiple objects within an image. Returns bounding boxes + labels.

- Input: image → Output: bounding boxes + class + confidence score
- Example: detect all lesions in a scan and mark their locations
- Tools: **YOLO** (real-time, single-stage), **DETR** (transformer-based), Faster R-CNN (two-stage, more accurate)

#### Segmentation
Classify at the pixel level — the most granular form of understanding.

Two variants:
- **Semantic segmentation** — label every pixel with a class (no distinction between instances)
- **Instance segmentation** — label every pixel *and* distinguish separate instances of the same class

- Example: **MRI scan → pixel mask showing exactly which voxels are tumor tissue**
- Tools: **U-Net** (dominant in medical imaging), **SAM** (Segment Anything Model, zero-shot), Mask R-CNN

### Algorithms & Tools

| Method | Type | Notes |
|---|---|---|
| **ResNet / EfficientNet / ConvNeXt** | Classification | CNN backbones; pretrain on ImageNet, fine-tune on domain data |
| **ViT / Swin Transformer** | Classification | Patch-based attention; strong at scale |
| **YOLOv8 / YOLOv9** | Detection | Fast enough for real-time; good balance of speed and accuracy |
| **Faster R-CNN** | Detection | Two-stage; higher accuracy, slower |
| **DETR** | Detection | Transformer-based; no hand-crafted anchors |
| **U-Net** | Segmentation | Encoder-decoder with skip connections; standard in medical imaging |
| **SAM (Segment Anything)** | Segmentation | Foundation model; prompt-based, zero-shot capable |
| **Mask R-CNN** | Instance seg | Extends Faster R-CNN with pixel masks per instance |

### Frameworks

- **PyTorch** — dominant in research and medical imaging
- **TorchVision** — pretrained models, datasets, transforms
- **Hugging Face Transformers** — ViT, DETR, SAM
- **Ultralytics (YOLO)** — detection and segmentation pipelines
- **MONAI** — PyTorch-based framework specifically for medical image analysis

### Key Concepts

- **Transfer learning** — pretrain on large dataset (ImageNet), fine-tune on small domain-specific dataset (e.g., 500 X-rays); critical when labeled medical data is scarce
- **Data augmentation** — random flips, rotations, brightness shifts to artificially expand training data
- **Backbone vs. head** — backbone extracts features (ResNet, ViT); task-specific head performs classification/detection/segmentation on top
- **Anchor boxes** — predefined bounding box shapes used in older detection models (YOLO, Faster R-CNN); DETR eliminates these

---

## Text / NLP

Teaching machines to understand, process, and generate human language.

Sequences of tokens — documents, records, conversations, code.

**Transformers** are now the universal architecture for NLP. The core idea is **self-attention**: the model learns which words in a sequence are relevant to each other, regardless of distance.

### Real-World Examples

- **Google Translate** — sequence-to-sequence transformer maps tokens in one language to another
- **Medical records analysis** — extract diagnoses, medications, dosages, and patient history from unstructured clinical notes; enables downstream analytics without manual chart review
- **Email spam filtering** — text classification
- **Legal document review** — NER + classification to flag clauses, entities, obligations

### Core Tasks

| Task | What it does | Example |
|---|---|---|
| **Classification** | Assign label to text | Sentiment, spam, ICD code from notes |
| **NER** | Extract named entities | Pull drug names, dosages, dates from records |
| **Translation** | Map sequence → sequence in another language | Google Translate |
| **Summarization** | Compress long text | Summarize a patient's discharge notes |
| **Question answering** | Extract or generate answer given context | "What medications is this patient on?" |
| **Embeddings / retrieval** | Represent text as dense vectors for similarity search | Semantic search, RAG pipelines |

### Algorithms & Tools

| Method | Notes |
|---|---|
| **BERT / RoBERTa** | Encoder-only transformer; strong for classification, NER, extractive QA |
| **GPT / LLaMA** | Decoder-only; generative tasks — summarization, translation, chat |
| **T5 / BART** | Encoder-decoder; seq2seq tasks — translation, summarization |
| **Sentence-BERT (SBERT)** | Fine-tuned for sentence embeddings; semantic similarity and retrieval |
| **TF-IDF + logistic regression** | Fast baseline; works well when labeled data is limited |
| **RNNs / LSTMs** | Pre-transformer sequential models; largely superseded |

### Frameworks

- **Hugging Face Transformers** — standard library; access to thousands of pretrained models
- **spaCy** — production NLP: tokenization, NER, dependency parsing
- **LangChain / LlamaIndex** — LLM orchestration, RAG pipelines
- **NLTK** — classical NLP utilities; preprocessing

### Key Concepts

- **Tokenization** — text is split into subword tokens before being fed to the model
- **Pretraining + fine-tuning** — pretrain on massive corpus (Wikipedia, PubMed); fine-tune on small labeled dataset; essential when domain-specific labeled data is scarce (e.g., clinical NLP)
- **Embeddings** — words and sentences mapped to vectors in high-dimensional space; similar meanings → nearby vectors
- **RAG (Retrieval-Augmented Generation)** — retrieve relevant documents at inference time and feed them as context to the model; grounds outputs in real data

---

## Time Series

Data where **time and order matter** — you can't shuffle the rows without destroying information.

Ordered numerical sequences — stock prices, website traffic, sensor readings, vital signs, energy consumption.

A mixed domain: classical statistical models remain competitive; deep learning wins when patterns are complex or data is abundant.

### Real-World Examples

- **Stock prices** — forecast next-day closing price; detect anomalous trading activity
- **Website traffic** — predict hourly sessions to auto-scale infrastructure
- **Patient vitals** — detect early deterioration from continuous ICU monitor readings
- **Energy demand** — forecast grid load to optimize power generation

### The Time Ordering Problem

Standard ML assumes i.i.d. (independent, identically distributed) samples — time series violates this. Key challenges:
- **Temporal leakage** — accidentally training on future data; train/test splits must be chronological, never random
- **Non-stationarity** — statistical properties (mean, variance) shift over time
- **Seasonality** — patterns that repeat at fixed intervals (daily, weekly, annual)

### Approaches

#### Classical Statistics
Best when data is limited, interpretability matters, or patterns are well-understood.

| Method | Notes |
|---|---|
| **ARIMA** | Models trend + autocorrelation; requires stationarity |
| **SARIMA** | Extends ARIMA with explicit seasonality term |
| **Exponential Smoothing (ETS)** | Weighted average of past observations; simple and robust |
| **Prophet** (Facebook) | Additive model for business time series; handles holidays and seasonality |

#### Tree Methods + Feature Engineering
Often the best-performing approach on benchmarks without large datasets.

- Compute **lag features** (value at t-1, t-7, t-30), **rolling statistics** (7-day mean, std), and **calendar features** (day of week, month)
- Feed into XGBoost / LightGBM as standard tabular ML
- Interpretable, fast, handles missing data well

#### Deep Learning
Preferred when patterns are complex, multivariate, or you have large volumes of data.

| Method | Notes |
|---|---|
| **LSTMs / GRUs** | Recurrent nets; capture sequential dependencies; slower to train |
| **Temporal CNNs (TCN)** | Dilated convolutions over time; parallelizable, faster than RNNs |
| **N-BEATS / N-HiTS** | Purpose-built neural forecasters; strong on univariate benchmarks |
| **Temporal Fusion Transformer (TFT)** | Attention + LSTM; strong on multivariate, handles static metadata |
| **PatchTST** | Treats time series patches as tokens; strong long-horizon performance |

### Common Tasks

- **Forecasting** — predict future values (next hour, day, quarter)
- **Anomaly detection** — flag unusual patterns in logs, sensor streams, transactions
- **Classification** — label segments (normal vs. arrhythmia in ECG)
- **Imputation** — fill missing values in incomplete series

---

## Audio

Waveforms or spectrograms — speech, music, environmental sound.

Raw waveforms can be processed directly or converted to 2D spectrograms and treated like images.

### Algorithms

| Method | Notes |
|---|---|
| **CNNs on mel-spectrograms** | Convert audio → 2D image, apply image techniques |
| **Wav2Vec 2.0 / HuBERT** | Self-supervised pretraining on raw waveforms; strong for ASR |
| **Whisper** | Transformer-based ASR; robust across languages and accents |
| **RNNs / CTC** | Older ASR pipelines |

### Common Tasks

- **Speech recognition (ASR)** — speech to text
- **Speaker identification** — who is speaking
- **Sound classification** — music genre, environmental sound
- **Audio generation** — text-to-speech, music synthesis

---

## Graph Data

Nodes connected by edges — social networks, molecules, knowledge graphs.

**Graph Neural Networks (GNNs)** are purpose-built for this structure; they propagate information across edges.

### Algorithms

| Method | Notes |
|---|---|
| **GCN** (Graph Convolutional Network) | Spectral-based convolution over graph |
| **GraphSAGE** | Inductive; samples and aggregates neighbor features |
| **GAT** (Graph Attention Network) | Attention weights over neighbors |
| **GIN** (Graph Isomorphism Network) | Theoretically expressive for graph classification |

### Common Tasks

- **Node classification** — label each node (user type, protein function)
- **Link prediction** — will two nodes connect (friend recommendation, drug interaction)
- **Graph classification** — label whole graphs (molecule property prediction)

---

## Video

Frames over time — combines spatial (image) and temporal structure.

### Algorithms

| Method | Notes |
|---|---|
| **3D CNNs** (C3D, I3D) | Extend 2D convolutions into the time dimension |
| **Two-stream networks** | Separate spatial and optical-flow streams |
| **Video Transformers** (TimeSformer, VideoMAE) | Self-attention across space and time |

### Common Tasks

- **Action recognition** — classify what's happening in a clip
- **Object tracking** — follow entities across frames
- **Video generation** — text-to-video (Sora, Runway)

---

## Quick Reference

| Domain | Primary architecture | Classic baseline |
|---|---|---|
| Tabular | Gradient boosting (XGBoost) | Linear model |
| Images | CNN / ViT | Logistic regression on pixels |
| Text | Transformer (BERT/GPT) | TF-IDF + logistic regression |
| Time series | Tree methods + lag features | ARIMA |
| Audio | CNN on spectrogram / Wav2Vec | MFCC + SVM |
| Graphs | GNN (GAT, GraphSAGE) | Node features + tree methods |
| Video | Video Transformer / 3D CNN | Frame-level CNN + pooling |
