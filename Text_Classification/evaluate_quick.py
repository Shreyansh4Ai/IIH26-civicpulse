import pandas as pd
import json
import numpy as np
from datasets import Dataset
from transformers import pipeline
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import warnings
warnings.filterwarnings('ignore')

df = pd.read_csv("data/processed.csv")
with open("data/label_map.json") as f:
    maps = json.load(f)
id2label = {int(k): v for k, v in maps['id2label'].items()}
train_df, test_df = train_test_split(df[['Complaint Text','label']], test_size=0.2, random_state=42, stratify=df['label'])

pipe = pipeline("text-classification", model="models/bert_finetuned", device=0, truncation=True, max_length=128)
preds = pipe(test_df['Complaint Text'].tolist(), batch_size=32)

y_pred = []
for p in preds:
    lbl = p['label']
    if 'LABEL' in lbl:
        y_pred.append(int(lbl.split('_')[-1]))
    else:
        y_pred.append(label2id[lbl])

target_names = [id2label[i] for i in sorted(id2label)]

print("\n==============================")
print(f"TEST ACCURACY: {accuracy_score(test_df['label'], y_pred):.4f}")
print("==============================\n")
print(classification_report(test_df['label'], y_pred, target_names=target_names))
