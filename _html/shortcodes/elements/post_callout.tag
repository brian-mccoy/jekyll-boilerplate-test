{% comment %}
Title: Post Callout
Markup: {% this image:"" url:"" title:"" ribbon:"" float:"" %}
Example: {% this title:"Healthcare Management" ribbon:"Featured" float:"" image:"https://via.placeholder.com/300x200/000/fff" url:"#" %}
Properties: <ul><li>image <i>required.</i></li><li>url <i>required.</i></li><li>ribbon</li><li>float <i>left, right or exclude property</i></li><li><small><i>Exclude blank properties from Tag/Block</i></small></ul>
{% endcomment %}


{% if image and url %}

    {% if float %}
        {% capture class %} fl-{{ float }}{% endcapture %}
    {% endif %}

    {% if ribbon %}
        {% capture ribbon %} data-ribbon="{{ ribbon }}"{% endcapture %}
    {% endif %}

    <a class="post-callout{{ class }}" style="background-image: url('{{ image }}')" href="{{ url }}" {{ ribbon }}>

        {% if title %}
            <span class="title">{{ title }}</span>
        {% endif %}

    </a>

{% endif %}