#coding=utf-8
import jieba,math
import jieba.analyse
import os
from wordcloud import WordCloud
import matplotlib.pyplot as plt

def isfloat(value):
    try:
        float(value)
        return True
    except ValueError:
        return False

word_freq = {}
with open("./stopWords.txt", encoding="utf-8") as f:
    stopW = f.read()
files = os.listdir()
for file in files:
    if(file == ".ipynb_checkpoints" or file == "Untitled.ipynb" or file == "stopWords.txt" or file == "dict.txt"):
        continue
    f = open(file,encoding = 'utf8').read()
    words = jieba.cut(f, cut_all = False)
    remainderWords = list(filter(lambda a: a not in stopW and a != '\n', words))
    for word in remainderWords:
        if(isfloat(word)):
            remainderWords.remove(word)
            continue
        if word in word_freq:
            word_freq[word]  = word_freq[word] + 1
        else:
            word_freq[word] = 1
    freq_word = []
    for word, freq in word_freq.items():
        freq_word.append((word, freq))
    freq_word.sort(key = lambda x: x[1], reverse = True)
    max_number = int(1000)

freq_word = freq_word[0:400]


word=""
for term in freq_word:
    word = word + term[0] + " "

wc = WordCloud(font_path="C:\\Windows\\fonts\\mingliu.ttc",
               background_color="white",width=1200,height=600,
               max_words = 400,max_font_size=60)
wc.generate(word)
# 視覺化呈現
plt.axis("off")
plt.figure(figsize=(20,10), dpi = 400)
plt.imshow(wc)
