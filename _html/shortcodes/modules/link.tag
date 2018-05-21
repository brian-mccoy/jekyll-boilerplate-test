{% comment %}
Title: Link
Markup: {% this url:"" title:"" subtitle:"" image:"" %}
Example: {% this title:"Scholarships for Minority Students" image:"" url:"#" %}
Example_1: {% this title:"Scholarships for Minority Students" subtitle:"Scholarships" url:"#" %}
Example_2: {% this title:"Scholarships for Minority Students" subtitle:"Scholarships" image:"https://via.placeholder.com/100x100" url:"#" %}
Properties: <ul><li>url <i>required.</i></li><li>title <i>required.</i></li><li>subtitle</li><li>image</li><li><small><i>Exclude blank properties from Tag/Block</i></small></ul>
{% endcomment %}


{% if url and title %}

    {% capture properties %}
        {%- if subtitle %} data-subtitle="{{ subtitle }}"{% endif -%}
        {%- if image %} style="background-image: url('{{ image }}');"{% endif -%}
    {% endcapture %}

    <a class="link{{ image | if: ' type-image' }}" href="{{ url }}" {{ properties | strip_newlines }}>{{ title }}</a>

{% endif %}