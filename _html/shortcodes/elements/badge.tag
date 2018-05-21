{% comment %}
Title: Badge
Markup: {% this image:"" title:"" download:"" float:"" %}
Example: {% this title:"Top 10 Bachelor Degrees Badge" download:"https://via.placeholder.com/200x200" image:"https://via.placeholder.com/300x250" %}
Properties: <ul><li>image <i>required.</i></li><li>title</li><li>download</li><li>float <i>left, right or exclude property</i></li><li><small><i>Exclude blank properties from Tag/Block</i></small></ul>
{% endcomment %}


{% if image %}

    {% if float %}
        {% capture class %} fl-{{ float }}{% endcapture %}
    {% endif %}

    <div class="badge{{ class }}">

        <img src="{{ image }}" alt="{{ title }}" />

        {% if download %}
            <a href="{{ download }}" class="btn" download>Download Badge</a>
        {% endif %}

    </div>

{% endif %}