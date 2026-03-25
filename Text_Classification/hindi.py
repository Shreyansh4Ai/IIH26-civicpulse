"""
==============================================================
  Hindi Complaint Text Classification Pipeline
  Approach: TF-IDF + Traditional ML (SVM / Logistic Regression)
  Supports large CSV datasets via chunked loading
==============================================================

SETUP (run once):
    pip install pandas scikit-learn numpy matplotlib seaborn joblib tqdm

USAGE:
    1. Set FILE_PATH, TEXT_COLUMN, LABEL_COLUMN below
    2. Run: python hindi_complaint_classifier.py
"""

# ─────────────────────────────────────────────
#  CONFIGURATION  ← Edit these before running
# ─────────────────────────────────────────────
FILE_PATH    = r"C:\Users\samik\OneDrive\Desktop\Text Classification\hindi_dataset_11650.csv"   # Full or relative path to your CSV
TEXT_COLUMN  = "clean_text"     # Column containing Hindi complaint text
LABEL_COLUMN = "Category"          # Column containing the class/label
ENCODING     = "utf-8"             # Try "utf-8-sig" or "latin-1" if errors occur
CHUNK_SIZE   = 50_000              # Rows per chunk (tune based on your RAM)
TEST_SIZE    = 0.2                 # 20% for testing
RANDOM_STATE = 42

# ─────────────────────────────────────────────
#  STEP 0 — Imports
# ─────────────────────────────────────────────
import os
import re
import warnings
import joblib
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from tqdm import tqdm

from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.svm import LinearSVC
from sklearn.pipeline import Pipeline
from sklearn.metrics import (
    classification_report, confusion_matrix,
    accuracy_score, f1_score
)
from sklearn.utils import shuffle
from sklearn.preprocessing import LabelEncoder

warnings.filterwarnings("ignore")
print("✅ All imports successful.\n")


# ─────────────────────────────────────────────
#  STEP 1 — Load Large CSV in Chunks
# ─────────────────────────────────────────────
def load_large_csv(file_path, text_col, label_col, chunk_size, encoding):
    """Load a large CSV file in memory-efficient chunks."""
    print(f"📂 Loading dataset from: {file_path}")
    print(f"   Chunk size : {chunk_size:,} rows")

    chunks = []
    total_rows = 0

    try:
        reader = pd.read_csv(
            file_path,
            usecols=[text_col, label_col],
            chunksize=chunk_size,
            encoding=encoding,
            on_bad_lines="skip"
        )

        for chunk in tqdm(reader, desc="   Reading chunks"):
            chunk = chunk.dropna(subset=[text_col, label_col])
            chunk[text_col]  = chunk[text_col].astype(str)
            chunk[label_col] = chunk[label_col].astype(str).str.strip()
            chunks.append(chunk)
            total_rows += len(chunk)

    except FileNotFoundError:
        print(f"\n❌ ERROR: File not found → '{file_path}'")
        print("   Please update FILE_PATH in the CONFIGURATION section.")
        raise SystemExit(1)
    except ValueError as e:
        print(f"\n❌ ERROR: Column mismatch → {e}")
        print(f"   Available columns: check your CSV header.")
        raise SystemExit(1)

    df = pd.concat(chunks, ignore_index=True)
    df = shuffle(df, random_state=RANDOM_STATE).reset_index(drop=True)
    print(f"\n✅ Dataset loaded: {total_rows:,} total rows | {df[label_col].nunique()} unique labels\n")
    return df


# ─────────────────────────────────────────────
#  STEP 2 — Exploratory Data Analysis (EDA)
# ─────────────────────────────────────────────
def run_eda(df, text_col, label_col):
    """Print EDA summary and save plots."""
    print("=" * 55)
    print("  STEP 2 — Exploratory Data Analysis")
    print("=" * 55)

    print(f"\n📊 Dataset Shape  : {df.shape}")
    print(f"📝 Text Column    : '{text_col}'")
    print(f"🏷️  Label Column   : '{label_col}'")
    print(f"\n📌 Label Distribution:\n")
    dist = df[label_col].value_counts()
    print(dist.to_string())

    # Text length stats
    df["_text_len"] = df[text_col].apply(len)
    print(f"\n📏 Text Length Stats (characters):")
    print(df["_text_len"].describe().round(2).to_string())

    # Plot 1: Label distribution
    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    dist.plot(kind="bar", ax=axes[0], color="steelblue", edgecolor="white")
    axes[0].set_title("Class Distribution", fontsize=13)
    axes[0].set_xlabel("Label")
    axes[0].set_ylabel("Count")
    axes[0].tick_params(axis="x", rotation=45)

    # Plot 2: Text length distribution
    axes[1].hist(df["_text_len"], bins=50, color="coral", edgecolor="white")
    axes[1].set_title("Complaint Text Length Distribution", fontsize=13)
    axes[1].set_xlabel("Characters")
    axes[1].set_ylabel("Frequency")

    plt.tight_layout()
    plt.savefig("eda_plots.png", dpi=120)
    plt.close()
    print("\n💾 EDA plots saved → eda_plots.png")

    df.drop(columns=["_text_len"], inplace=True)
    print()


# ─────────────────────────────────────────────
#  STEP 3 — Hindi Text Preprocessing
# ─────────────────────────────────────────────

# Common Hindi stopwords (Devanagari script)
HINDI_STOPWORDS = set([
    "का", "के", "की", "है", "हैं", "में", "से", "को", "पर", "और",
    "यह", "वह", "एक", "था", "थे", "थी", "कि", "जो", "हो", "ने",
    "हम", "आप", "वे", "इस", "उस", "भी", "तो", "ही", "नहीं", "कर",
    "मैं", "हमारे", "आपके", "उनके", "इनके", "उनका", "इनका", "किया",
    "किये", "करना", "करने", "होने", "होना", "रहा", "रही", "रहे",
    "अब", "तब", "जब", "यहाँ", "वहाँ", "कहाँ", "कैसे", "क्यों",
    "क्या", "कौन", "कितना", "कितनी", "कितने", "सभी", "बहुत",
    "बड़ा", "छोटा", "अच्छा", "बुरा", "पहले", "बाद", "साथ",
])

def preprocess_hindi(text: str) -> str:
    """
    Clean and normalize a Hindi complaint text string.
    Steps:
      1. Lowercase (for any Roman/English mixed text)
      2. Remove URLs, emails, phone numbers
      3. Remove special characters, keep Devanagari + spaces
      4. Normalize multiple spaces
      5. Remove Hindi stopwords
    """
    # Lowercase Roman characters
    text = text.lower()

    # Remove URLs
    text = re.sub(r"http\S+|www\S+", " ", text)

    # Remove emails
    text = re.sub(r"\S+@\S+", " ", text)

    # Remove phone numbers (10-digit sequences)
    text = re.sub(r"\b\d{10}\b", " ", text)

    # Remove digits and punctuation, keep Devanagari Unicode range (U+0900–U+097F) and spaces
    text = re.sub(r"[^\u0900-\u097F\s]", " ", text)

    # Normalize whitespace
    text = re.sub(r"\s+", " ", text).strip()

    # Remove stopwords
    tokens = text.split()
    tokens = [t for t in tokens if t not in HINDI_STOPWORDS]

    return " ".join(tokens)


def apply_preprocessing(df, text_col):
    """Apply Hindi preprocessing to the full dataframe."""
    print("=" * 55)
    print("  STEP 3 — Hindi Text Preprocessing")
    print("=" * 55)
    print("\n⚙️  Cleaning and normalizing Hindi text...")

    tqdm.pandas(desc="   Processing")
    df["cleaned_text"] = df[text_col].progress_apply(preprocess_hindi)

    # Show a sample
    print("\n📋 Sample Before → After:")
    sample = df[[text_col, "cleaned_text"]].head(3)
    for _, row in sample.iterrows():
        print(f"  BEFORE : {row[text_col][:80]}")
        print(f"  AFTER  : {row['cleaned_text'][:80]}")
        print()

    return df


# ─────────────────────────────────────────────
#  STEP 4 — Encode Labels
# ─────────────────────────────────────────────
def encode_labels(df, label_col):
    """Encode string labels to integers."""
    print("=" * 55)
    print("  STEP 4 — Label Encoding")
    print("=" * 55)

    le = LabelEncoder()
    df["label_encoded"] = le.fit_transform(df[label_col])

    print(f"\n🏷️  Classes ({len(le.classes_)}):")
    for idx, cls in enumerate(le.classes_):
        count = (df["label_encoded"] == idx).sum()
        print(f"   [{idx}] {cls:30s} → {count:,} samples")

    print()
    return df, le


# ─────────────────────────────────────────────
#  STEP 5 — Train / Test Split
# ─────────────────────────────────────────────
def split_data(df):
    """Stratified train/test split."""
    print("=" * 55)
    print("  STEP 5 — Train / Test Split")
    print("=" * 55)

    X = df["cleaned_text"]
    y = df["label_encoded"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y,
        test_size=TEST_SIZE,
        random_state=RANDOM_STATE,
        stratify=y
    )

    print(f"\n   Training samples : {len(X_train):,}")
    print(f"   Test samples     : {len(X_test):,}")
    print()
    return X_train, X_test, y_train, y_test


# ─────────────────────────────────────────────
#  STEP 6 — Build & Train Models
# ─────────────────────────────────────────────
def build_pipelines():
    """Return two sklearn Pipelines: Logistic Regression and LinearSVC."""

    tfidf = TfidfVectorizer(
        analyzer="word",
        ngram_range=(1, 2),       # unigrams + bigrams
        max_features=100_000,      # cap vocabulary for memory efficiency
        sublinear_tf=True,         # log-scale TF to reduce impact of high-freq terms
        min_df=2,                  # ignore very rare terms
        max_df=0.95,               # ignore near-universal terms
    )

    lr_pipeline = Pipeline([
        ("tfidf", tfidf),
        ("clf", LogisticRegression(
            max_iter=1000,
            C=1.0,
            solver="saga",         # fast solver for large datasets
            n_jobs=-1,
            random_state=RANDOM_STATE
        ))
    ])

    svm_pipeline = Pipeline([
        ("tfidf", TfidfVectorizer(
            analyzer="word",
            ngram_range=(1, 2),
            max_features=100_000,
            sublinear_tf=True,
            min_df=2,
            max_df=0.95,
        )),
        ("clf", LinearSVC(
            max_iter=2000,
            C=1.0,
            random_state=RANDOM_STATE
        ))
    ])

    return {"Logistic Regression": lr_pipeline, "LinearSVC (SVM)": svm_pipeline}


def train_and_evaluate(pipelines, X_train, X_test, y_train, y_test, le):
    """Train both models, evaluate, and return results."""
    print("=" * 55)
    print("  STEP 6 — Model Training & Evaluation")
    print("=" * 55)

    results = {}

    for name, pipeline in pipelines.items():
        print(f"\n🚀 Training: {name} ...")
        pipeline.fit(X_train, y_train)

        y_pred = pipeline.predict(X_test)
        acc  = accuracy_score(y_test, y_pred)
        f1   = f1_score(y_test, y_pred, average="weighted")

        print(f"   ✅ Accuracy        : {acc:.4f} ({acc*100:.2f}%)")
        print(f"   ✅ Weighted F1     : {f1:.4f}")

        print(f"\n📋 Classification Report — {name}:")
        print(classification_report(
            y_test, y_pred,
            target_names=le.classes_,
            zero_division=0
        ))

        results[name] = {
            "pipeline": pipeline,
            "y_pred": y_pred,
            "accuracy": acc,
            "f1": f1
        }

    return results


# ─────────────────────────────────────────────
#  STEP 7 — Cross-Validation
# ─────────────────────────────────────────────
def run_cross_validation(best_pipeline, X_train, y_train):
    """5-fold stratified cross-validation on the best model."""
    print("=" * 55)
    print("  STEP 7 — 5-Fold Cross-Validation")
    print("=" * 55)

    skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=RANDOM_STATE)
    cv_scores = cross_val_score(
        best_pipeline, X_train, y_train,
        cv=skf, scoring="f1_weighted", n_jobs=-1
    )

    print(f"\n   CV F1 Scores : {np.round(cv_scores, 4)}")
    print(f"   Mean F1      : {cv_scores.mean():.4f} ± {cv_scores.std():.4f}\n")


# ─────────────────────────────────────────────
#  STEP 8 — Confusion Matrix Plot
# ─────────────────────────────────────────────
def plot_confusion_matrix(y_test, y_pred, le, model_name):
    """Save a heatmap confusion matrix."""
    cm = confusion_matrix(y_test, y_pred)
    labels = le.classes_

    fig_size = max(8, len(labels))
    fig, ax = plt.subplots(figsize=(fig_size, fig_size - 1))

    sns.heatmap(
        cm, annot=True, fmt="d", cmap="Blues",
        xticklabels=labels, yticklabels=labels,
        ax=ax, linewidths=0.5
    )
    ax.set_xlabel("Predicted Label", fontsize=11)
    ax.set_ylabel("True Label", fontsize=11)
    ax.set_title(f"Confusion Matrix — {model_name}", fontsize=13)
    plt.xticks(rotation=45, ha="right")
    plt.yticks(rotation=0)
    plt.tight_layout()

    fname = f"confusion_matrix_{model_name.replace(' ', '_').lower()}.png"
    plt.savefig(fname, dpi=120)
    plt.close()
    print(f"💾 Confusion matrix saved → {fname}")


# ─────────────────────────────────────────────
#  STEP 9 — Model Comparison Bar Chart
# ─────────────────────────────────────────────
def plot_model_comparison(results):
    """Bar chart comparing model accuracies and F1 scores."""
    names = list(results.keys())
    accs  = [results[n]["accuracy"] for n in names]
    f1s   = [results[n]["f1"] for n in names]

    x = np.arange(len(names))
    width = 0.35

    fig, ax = plt.subplots(figsize=(8, 5))
    bars1 = ax.bar(x - width/2, accs, width, label="Accuracy",  color="steelblue",  edgecolor="white")
    bars2 = ax.bar(x + width/2, f1s,  width, label="F1 (weighted)", color="darkorange", edgecolor="white")

    ax.set_ylim(0, 1.05)
    ax.set_ylabel("Score")
    ax.set_title("Model Comparison: Accuracy vs F1 Score")
    ax.set_xticks(x)
    ax.set_xticklabels(names)
    ax.legend()

    for bar in bars1 + bars2:
        ax.annotate(f"{bar.get_height():.3f}",
                    xy=(bar.get_x() + bar.get_width() / 2, bar.get_height()),
                    xytext=(0, 4), textcoords="offset points",
                    ha="center", va="bottom", fontsize=9)

    plt.tight_layout()
    plt.savefig("model_comparison.png", dpi=120)
    plt.close()
    print("💾 Model comparison chart saved → model_comparison.png\n")


# ─────────────────────────────────────────────
#  STEP 10 — Save Best Model
# ─────────────────────────────────────────────
def save_best_model(results, le):
    """Save the best-performing pipeline and label encoder."""
    best_name = max(results, key=lambda n: results[n]["f1"])
    best_pipeline = results[best_name]["pipeline"]

    joblib.dump(best_pipeline, "best_model_pipeline.pkl")
    joblib.dump(le, "label_encoder.pkl")

    print("=" * 55)
    print("  STEP 10 — Saved Best Model")
    print("=" * 55)
    print(f"\n   🏆 Best Model     : {best_name}")
    print(f"   📦 Pipeline saved : best_model_pipeline.pkl")
    print(f"   📦 Encoder saved  : label_encoder.pkl\n")

    return best_name, best_pipeline


# ─────────────────────────────────────────────
#  STEP 11 — Inference on New Complaints
# ─────────────────────────────────────────────
def predict_new_complaints(pipeline, le, complaints: list):
    """Classify a list of new Hindi complaint strings."""
    print("=" * 55)
    print("  STEP 11 — Inference on New Complaints")
    print("=" * 55)

    cleaned = [preprocess_hindi(c) for c in complaints]
    preds   = pipeline.predict(cleaned)
    labels  = le.inverse_transform(preds)

    print()
    for i, (original, label) in enumerate(zip(complaints, labels), 1):
        print(f"  [{i}] Input  : {original[:80]}")
        print(f"      Predicted : {label}")
        print()


# ─────────────────────────────────────────────
#  MAIN — Orchestrate All Steps
# ─────────────────────────────────────────────
def main():
    print("\n" + "=" * 55)
    print("  Hindi Complaint Text Classification Pipeline")
    print("  Model: TF-IDF + Logistic Regression / LinearSVC")
    print("=" * 55 + "\n")

    # Step 1: Load
    df = load_large_csv(FILE_PATH, TEXT_COLUMN, LABEL_COLUMN, CHUNK_SIZE, ENCODING)

    # Step 2: EDA
    run_eda(df, TEXT_COLUMN, LABEL_COLUMN)

    # Step 3: Preprocess
    df = apply_preprocessing(df, TEXT_COLUMN)

    # Step 4: Encode labels
    df, le = encode_labels(df, LABEL_COLUMN)

    # Step 5: Split
    X_train, X_test, y_train, y_test = split_data(df)

    # Step 6: Train & evaluate both models
    pipelines = build_pipelines()
    results   = train_and_evaluate(pipelines, X_train, X_test, y_train, y_test, le)

    # Step 7: Cross-validation on best model
    best_name_cv = max(results, key=lambda n: results[n]["f1"])
    run_cross_validation(results[best_name_cv]["pipeline"], X_train, y_train)

    # Step 8: Confusion matrices
    for name, res in results.items():
        plot_confusion_matrix(y_test, res["y_pred"], le, name)

    # Step 9: Model comparison chart
    plot_model_comparison(results)

    # Step 10: Save best model
    best_name, best_pipeline = save_best_model(results, le)

    # Step 11: Demo inference
    sample_complaints = [
        "मेरा बिजली का बिल बहुत ज्यादा आया है, कृपया जाँच करें।",
        "पानी की आपूर्ति तीन दिनों से बंद है, समस्या का समाधान करें।",
        "सड़क पर बड़े-बड़े गड्ढे हैं, दुर्घटना का खतरा है।",
        "मेरा इंटरनेट कनेक्शन काम नहीं कर रहा है।",
        "कचरा उठाने वाले कई दिनों से नहीं आये हैं।",
    ]
    predict_new_complaints(best_pipeline, le, sample_complaints)

    print("=" * 55)
    print("  ✅ Pipeline Complete!")
    print("  Output files:")
    print("    📊 eda_plots.png")
    print("    📊 model_comparison.png")
    print("    📊 confusion_matrix_*.png")
    print("    📦 best_model_pipeline.pkl")
    print("    📦 label_encoder.pkl")
    print("=" * 55 + "\n")


if __name__ == "__main__":
    main()