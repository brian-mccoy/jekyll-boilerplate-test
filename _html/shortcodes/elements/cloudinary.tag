{% comment %}
Title: Cloudinary
Markup: {% this path:"" breakpoints:"" quality:"" format:"" flag:"" width:"" height:"" width:"" crop:"" radius:"" opacity:"" overlay_color:"" overlay_opacity:"" gradient:"" %}
Example: {% this path:"/v1511377049/BusinessAnalytics.com/Homepage/img-masters-in-BA.jpg" %}<div class="clearfix"></div>
Example_1: {% this path:"/v1511377049/BusinessAnalytics.com/Homepage/img-masters-in-BA.jpg" height:"500" width:"500" %}<div class="clearfix"></div>
Example_2: {% this path:"/v1511377049/BusinessAnalytics.com/Homepage/img-masters-in-BA.jpg" breakpoints:"600=/v1507744268/BusinessAnalytics.com/Degrees/img-pull-quote-temp.jpg|900=/v1507744268/BusinessAnalytics.com/Degrees/img-rankings-temp.jpg" %}<div class="clearfix"></div>
Example_3: {% this path:"/v1511377049/BusinessAnalytics.com/Homepage/img-masters-in-BA.jpg" overlay_color:"1D1D5C" overlay_opacity:"70"  %}<div class="clearfix"></div>
Properties: <ul><li>path <i>required.</i></li><li>breakpoints <i>e.g. picture tag: 600=IMAGE_PATH|900=IMAGE_PATH or srcset tag: 600|900|1200</i></li><li>quality</li><li>format</li><li>flag</li><li>width</li><li>height</li><li>width</li><li>crop</li><li>radius</li><li>opacity</li><li>overlay_color</li><li>overlay_opacity</li><li>gradient</li><li><small><i>Exclude blank properties from Tag/Block</i></small></ul>
Instructions: Contact developer for more information on Cloudinary Properties.
{% endcomment %}


{% if path %}

    {%- capture properties -%}
        {%- if quality -%} q_{{ quality }}, {%- endif -%}
        {%- if format -%} f_{{ format }}, {%- endif -%}
        {%- if flag -%} fl_{{ flag }}, {%- endif -%}
        {%- if width -%} w_{{ width }}, {%- endif -%}
        {%- if height -%} h_{{ height }}, {%- endif -%}
        {%- if crop -%} c_{{ crop }}, {%- endif -%}
        {%- if radius -%} r_{{ radius }}, {%- endif -%}
        {%- if opacity -%} o_{{ opacity }}, {%- endif -%}
        {%- if overlay_color -%} co_rgb:{{ overlay_color }}, {%- endif -%}
        {%- if overlay_opacity -%} e_colorize:{{ overlay_opacity }}, {%- endif -%}
    {%- endcapture -%}

    {%- capture secondary_properties -%}
        {%- if gradient -%} {{ gradient }}, {%- endif -%}
    {%- endcapture -%}

    {%- capture img_prefix -%} 
        https://res.cloudinary.com/{{ cloud_name }}/image/upload
        {%- if properties -%} /{{ properties }} {%- endif -%}
        {%- if secondary_properties != "" -%} /{{ secondary_properties }} {%- endif -%}
        /
    {%- endcapture -%}

    {% assign img_orginal = img_prefix | append: path %}

    {% if breakpoints and width != "" %}

        {% assign bps = breakpoints | split:"|" %}
        
        {% for bp in bps %}

            {% assign width_image = bp | split:"=" %}
            {% assign bp_width = width_image[0] | remove: 'px' %}
            {% assign bp_image = width_image[1] %}

            {% if bp_image %}

                {% assign markup = "picture" %}
                {% capture sources %} {{ sources }} <source media="(max-width: {{ bp_width }}px)" srcset="{{ img_prefix }}{{ bp_image }}">{% endcapture %}

            {% else %}
                
                {% assign markup = "srcset" %}
                
                {% if forloop.last %}
                    {% capture srcsets %} {{ srcsets }} {{ img_prefix }}w_{{ bp_width }}/{{ path }} {{ bp_width }}w{% endcapture %}
                    {% capture sizes %} {{ sizes }} {{ bp_width }}px{% endcapture %}
                {% else %}
                    {% capture srcsets %} {{ srcsets }} {{ img_prefix }}w_{{ bp_width }}/{{ path }} {{ bp_width }}w,{% endcapture %}
                    {% capture sizes %} {{ sizes }} (max-width: {{ bp_width }}px) {{ bp_width }}px,{% endcapture %}
                {% endif %}

            {% endif %}

        {% endfor %}

    {% endif %}

    {% if width or height %}
        {% assign markup = "default" %}
    {% endif %}

    {% case markup %}

        {% when 'picture' %}

            <picture>
                {{ sources | strip_newlines }}
                <img src="{{ img_orginal }}" alt="{{ title }}" />

                {% if caption %}
                    <caption>{{ caption }}</caption>
                {% endif %}
            </picture>

        {% when 'srcset' %}

            <img srcset="{{ srcsets | strip_newlines }}" sizes="{{ sizes | strip_newlines }}" src="{{ img_orginal }}" alt="{{ title }}" />

        {% when 'clienthints' %}
            
            <img src="{{ img_prefix }}w_auto/{{ path }}" alt="{{ title }}" />

        {% else %}

            <img src="{{ img_orginal }}" alt="{{ title }}" />

    {% endcase %}

{% endif %}