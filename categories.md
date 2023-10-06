---
layout: pageminimal
title: Category Index
permalink: /categories/index.html
title: Category Index
tags: [Categories]
description: "An archive of posts sorted by categories."

---

{% assign categories = site.categories | sort | hash_filter %}

<ul class="tag-box inline">
  {% if categories.first[0] == null %}
    {% for tag in categories %}
      <li><a href="#{{ tag }}">{{ tag}} <span>{{ site.tags[tag].size }}</span></a></li>
    {% endfor %}
  {% else %}
    {% for tag in categories %}
      <li><a href="#{{ tag[0] }}">{{ tag[0]}} <span>{{ tag[1].size }}</span></a></li>
    {% endfor %}
  {% endif %}
</ul>

{% for tag in categories %}
  <h2 id="{{ tag[0] }}" style="color: #c91b26">{{ tag[0] }}</h2>
  <ul class="post-list">
    {% assign pages_list = tag[1] %}
    {% for post in pages_list %}
      {% if post.title != null %}
      {% if group == null or group == post.group %}
      <li><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}<span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date: "%B %d, %Y" }}</time></span></a></li>
      {% endif %}
      {% endif %}
    {% endfor %}
    {% assign pages_list = nil %}
    {% assign group = nil %}
  </ul>
{% endfor %}
