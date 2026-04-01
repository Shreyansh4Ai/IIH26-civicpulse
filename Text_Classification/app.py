import streamlit as st
import json
import re
import joblib
import torch
import numpy as np
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
import os
import sys

# Get absolute path to the directory containing this script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Download NLTK data
@st.cache_resource
def download_nltk_data():
    nltk.download('stopwords', quiet=True)
    nltk.download('wordnet', quiet=True)

download_nltk_data()

st.title("Civic Complaint Categorization")
st.write("Enter a civic complaint below to automatically classify it into the correct category.")

try:
    # Load label maps
    label_map_path = os.path.join(BASE_DIR, "data", "label_map.json")
    with open(label_map_path) as f:
        maps = json.load(f)
    label2id = maps['label2id']
    id2label = {int(k): v for k, v in maps['id2label'].items()}
except Exception as e:
    st.error(f"Error loading label map: {e}")
    st.stop()

# Preprocessing
stop_words = set(stopwords.words('english'))
lemmatizer = WordNetLemmatizer()

def clean_text(text: str) -> str:
    text = str(text).lower()
    text = re.sub(r'http\S+|www\S+', '', text)
    text = re.sub(r'[^a-z\s]', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()
    tokens = [
        lemmatizer.lemmatize(tok)
        for tok in text.split()
        if tok not in stop_words and len(tok) > 2
    ]
    return ' '.join(tokens)

# Load Model
@st.cache_resource
def load_model():
    # If you want to use BERT, change this to True and make sure transformers is installed
    use_bert = False 
    
    if use_bert:
        from transformers import AutoTokenizer, AutoModelForSequenceClassification
        model_path = os.path.join(BASE_DIR, "models", "bert_finetuned")
        tokenizer = AutoTokenizer.from_pretrained(model_path)
        model = AutoModelForSequenceClassification.from_pretrained(model_path)
        model.eval()
        return ("bert", tokenizer, model)
    else:
        model_path = os.path.join(BASE_DIR, "models", "tfidf_pipeline.pkl")
        pipeline = joblib.load(model_path)
        return ("tfidf", pipeline, None)

try:
    model_type, model1, model2 = load_model()
except Exception as e:
    st.error(f"Error loading model: {e}")
    st.stop()

def predict(text: str) -> dict:
    if model_type == "bert":
        tokenizer, model = model1, model2
        inputs = tokenizer(text, return_tensors='pt', truncation=True, max_length=128)
        with torch.no_grad():
            logits = model(**inputs).logits
        probs = torch.softmax(logits, dim=-1)[0].numpy()
        pred_id = int(np.argmax(probs))
        confidence = float(probs[pred_id])
        return id2label[pred_id], confidence, {id2label[i]: round(float(p), 3) for i, p in enumerate(probs)}
    else:
        pipeline = model1
        pred_id = int(pipeline.predict([text])[0])
        try:
            probs = pipeline.predict_proba([text])[0]
            confidence = float(max(probs))
            all_scores = {id2label[i]: round(float(p), 3) for i, p in enumerate(probs)}
        except AttributeError:
            confidence = 1.0
            all_scores = {}
        return id2label[pred_id], confidence, all_scores

# UI
complaint = st.text_area("Complaint Text", height=150, placeholder="E.g., The road near my house has a huge pothole...")

if st.button("Predict Category"):
    if complaint.strip():
        with st.spinner("Analyzing complaint..."):
            category, confidence, all_scores = predict(complaint)
            
        st.success("Prediction Complete!")
        st.metric(label="Predicted Category", value=category)
        st.metric(label="Confidence", value=f"{confidence*100:.1f}%")
        
        if all_scores:
            st.write("### Category Probabilities")
            # Sort categories by probability
            sorted_scores = sorted(all_scores.items(), key=lambda x: x[1], reverse=True)
            for cat, score in sorted_scores:
                st.progress(score, text=f"{cat} ({score*100:.1f}%)")
    else:
        st.warning("Please enter a complaint to predict.")
