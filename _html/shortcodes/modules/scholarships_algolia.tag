{% comment %}
Title: Scholarships - Algolia
Markup: {% this study_areas:"" title:"" %}
Example: {% this study_areas:"" %}
Properties: <ul><li>study_areas</li><li>title</li><li><small><i>Exclude blank properties from Tag/Block</i></small></ul>
Instructions: <strong>Selectable Study Areas:</strong><br /> Example usage: <pre>study_areas:"journalism|medicine|Art"</pre>general|Nursing|education|engineering|Music|business|Law|accounting|agriculture|journalism|medicine|Art|business administration|architecture|occupational therapy|Civil engineering|Biology|English|history|elementary education|science|mathematics|food science/technology|library science|theatre|Textile chemistry, textile management, textile science|dental hygiene|fine arts|Automotive marketing|Chemical engineering|computer science|culinary arts|document management, graphic communication|human sciences|mechanical engineering|Aviation|American history|chemistry|Electrical engineering|agribusiness, agriscience|engineering, math, science, technology|hospitality with focus on travel and tourism, tourism-specific area|political science|art history|healthcare|law enforcement|pharmacy|Horticulture|Physics|visual arts|automotive aftermarket management|industrial engineering|landscape architecture|ministry|nuclear engineering and nuclear science|travel/tourism|chiropractic|interior design|criminal justice|engineering, science|geology|health-related field|marketing|social work|teacher education|teaching|Psychology|dentistry|engineering, mathematics, science|fashion|performing arts|automotive|electrical engineering, mechanical engineering|environmental studies|graphic design|humanities|management|medical|special education|Computer science and aeronautical/aerospace, astronautical, architectural, automotive, civil, hemical, computer, electrical, environmental, industrial, mechanical, manufacturing, materials science, or petroleum engineering|French|agriculture-related field|arts and sciences|business management|communications|communications, journalism|finance|finance, hospitality, technology|marine-related field|math, science|Geology, geophysics|Graphic communications|arts|broadcasting, electronic media, television|construction|dance|economics|engineering, math, science|engineering, mathematics, science, technology|family and consumer sciences
{% endcomment %}


<div class="algolia-scholarships">

    <!-- Filters -->
    <div class="filters">

        <form class="filter-form">

            <div class="filter-title">Search Rankings</div>
            <div id="algolia-searchBox"></div>

            <div class="filter-title">Filter Options</div>
            <div class="filter-section js-target">

                <div class="filter-control js-toggle"></div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Location</div>
                    <div class="filter-options" id="algolia-refinementList-state"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Popular Study Areas</div>
                    <div class="filter-options" id="algolia-toggleList-study_areas"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Sponsored by School</div>
                    <div class="filter-options" id="algolia-toggleList-sponsor-is_school"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Renewability</div>
                    <div class="filter-options" id="algolia-toggleList-renewable"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Minimum GPA</div>
                    <div class="filter-options" id="algolia-refinementList-min_gpa"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Ethnicity Preference</div>
                    <div class="filter-options" id="algolia-refinementList-races"></div>
                </div>

                <div class="filter-category">
                    <div class="filter-label js-toggle-category">Enrollment Level</div>
                    <div class="filter-options" id="algolia-refinementList-enroll_level"></div>
                </div>

            </div>

            <div id="algolia-clearAll"></div>

        </form>

    </div>

    <!-- Title/Hits/Pagination -->
    <div class="results list js-children-toggle">

        <div id="algolia-currentRefinedValues"></div>

        <h3 class="header">
        
            {{ title | ternary: 'Scholarships' }}

            <div class="result-stats">
                <div class="result-count" id="algolia-count"></div>
            </div>

            <div class="btn-controls">
                <button type="button" class="btn-toggle js-collapse-all">Collapse All</button>
                <button type="button" class="btn-toggle js-expand-all">Expand All</button>
            </div>

        </h3>

        <div id="algolia-hits" class="scholarships"></div>
        <div class="algolia-pagination" id="algolia-pagination"></div>

    </div>

</div>

<link href="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.js"></script>

<script>

// Variables
var studyAreas      = {%- if study_areas -%}"{{ study_areas }}"{%- else -%}false{%- endif -%};
var studyAreasFacet = studyAreas ? { study_areas: studyAreas.split('|') } : {};
var hitsPerPage = 20;
var scholarships_search = instantsearch({
    appId: '{{ site.algolia.api_id }}',
    apiKey: '{{ site.algolia.api_key }}',
    indexName: '{{ site.algolia.scholarships }}',
    urlSync: false,
    searchParameters: {
        disjunctiveFacetsRefinements: studyAreasFacet,
        attributesToRetrieve: [ 'name', 'contact', 'requirements', 'application_url', 'deadline', 'enrollment_levels', 'renewable', 'sponsor', 'study_areas' ]
    }
});

// Scholarship
function sanitize_scholarship(item) {

    // Average
    if (item.avg) {
        item.avg = numberFormat(item.avg);
    }

    // Study Areas
    if (item.study_areas) {
        item.study_areas = capitlizedWords(item.study_areas);
    }

    // Renewable
    if (item.renewable) {
        item.renewable = item.renewable == 'Y' ? 'Yes' : 'No';
    }

    // Enrollement Levels
    var enrollment_levels = '';

    if (item.enrollment_levels && item.enrollment_levels[0] != '') {
        for (var key in item.enrollment_levels) {
            enrollment_levels += key != (item.enrollment_levels.length - 1) ? item.enrollment_levels[key] + ', ' : item.enrollment_levels[key] + ' ';
        }
    }

    item.enrollment_levels = enrollment_levels;

    // Return Item
    return item;

}


// Format Phone
function formatPhone(str) {
    return str.replace(/\D/g, '').substring(0, 10).replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
}


// Format Number
function numberFormat(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


// Capitlized Words
function capitlizedWords(str) {
    return str.replace(/(?:^|\s)\S/g, function(a) { 
        return a.toUpperCase(); 
    });
};

// Format Refined Tag Values
function formatRefineValues(item) {
    switch (item.attributeName) {
        case 'states':
            item = stateAbbrToName(item);
            break;
        case 'enrollment_levels':
        case 'races':
        case 'study_areas':
            item.name = capitlizedWords(item.name);
            break;
        case 'renewable':
            item.name = 'Renewablity: ' + (item.name == 'Y' ? 'Yes' : 'No');
            break;
        case 'sponsor.is_school':
            item.name = 'Sponsored by School: ' + (item.name == 'Y' ? 'Yes' : 'No');
            break;
        case 'min_gpa':
            if (item.name == '0') {
                item.name = 'Not Specified';
            } else if (item.name == '1' || item.name == '2' || item.name == '3' || item.name == '4') {
                item.name += '.0';
            }
            item.name = 'Minimum GPA: ' + item.name;
            break;
    }

    return item;
}

// Min GPA Label Transform
function minGPALabel(item) {
    var gpa = {
        "0": "Not Specified",
        "1": "1.0",
        "2": "2.0",
        "3": "3.0",
        "4": "4.0",
    };

    item.name = gpa[item.name] ? gpa[item.name] : item.name;
    item.highlighted = item.name;

    return item;
}

// State Abbreviation to Name
function stateAbbrToName(item) {
    var states = {
        "AA": "Armed Forces Americas",
        "AB": "Alberta",
        "AE": "Armed Forces Africa/Canada/Europe/Middle East",
        "AK": "Alaska",
        "AL": "Alabama",
        "AP": "Armed Forces Pacific",
        "AR": "Arkansas",
        "AS": "American Samoa",
        "AZ": "Arizona",
        "BC": "British Columbia",
        "CA": "California",
        "CO": "Colorado",
        "CT": "Connecticut",
        "DC": "District Of Columbia",
        "DE": "Delaware",
        "FL": "Florida",
        "FM": "Federated States Of Micronesia",
        "GA": "Georgia",
        "GU": "Guam",
        "HI": "Hawaii",
        "IA": "Iowa",
        "ID": "Idaho",
        "IL": "Illinois",
        "IN": "Indiana",
        "KS": "Kansas",
        "KY": "Kentucky",
        "LA": "Louisiana",
        "MA": "Massachusetts",
        "MB": "Manitoba",
        "MD": "Maryland",
        "ME": "Maine",
        "MH": "Marshall Islands",
        "MI": "Michigan",
        "MN": "Minnesota",
        "MO": "Missouri",
        "MP": "Northern Mariana Islands",
        "MS": "Mississippi",
        "MT": "Montana",
        "NB": "New Brunswick",
        "NC": "North Carolina",
        "ND": "North Dakota",
        "NE": "Nebraska",
        "NF": "Newfoundland and Labrador",
        "NH": "New Hampshire",
        "NJ": "New Jersey",
        "NL": "Newfoundland and Labrador",
        "NM": "New Mexico",
        "NS": "Nova Scotia",
        "NT": "Northwest Territories",
        "NU": "Nunavut",
        "NV": "Nevada",
        "NY": "New York",
        "OH": "Ohio",
        "OK": "Oklahoma",
        "ON": "Ontario",
        "OR": "Oregon",
        "PA": "Pennsylvania",
        "PE": "Prince Edward Island",
        "PR": "Puerto Rico",
        "PW": "Palau",
        "QC": "Québec",
        "RI": "Rhode Island",
        "SC": "South Carolina",
        "SD": "South Dakota",
        "SK": "Saskatchewan",
        "TN": "Tennessee",
        "TX": "Texas",
        "UT": "Utah",
        "VA": "Virginia",
        "VI": "Virgin Islands",
        "VT": "Vermont",
        "WA": "Washington",
        "WI": "Wisconsin",
        "WV": "West Virginia",
        "WY": "Wyoming",
        "YT": "Yukon"
    };

    item.name = states[item.name];
    item.highlighted = item.name;

    return item;
}

{% raw %}

var template = '\
    <div class="item scholarship js-target">\
        <h4 class="title js-toggle">\
            {{name}}\
            {{#avg}}<span class="amount">${{avg}}</span>{{/avg}}\
            <svg aria-hidden="true" class="icon-plus-minus" width="29" height="29" viewBox="0 0 29 29" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><ellipse class="circle" cx="14.5" cy="14.5" rx="14.5" ry="14.5"></ellipse><path class="plus" d="M8.833 13.171h4.037V9.135h3.035v4.036h4.036v3.035h-4.036v4.036H12.87v-4.036H8.833z"></path><path class="minus" d="M8.833 13.171h11.108v3.035H8.833z"></path></g></svg>\
        </h4>\
        <div class="content">\
            {{#requirements}}<p>{{requirements}}</p>{{/requirements}}\
            {{#contact.address_1}}\
            <h5>Address &amp; College Info</h5>\
            <p>\
                {{contact.address_1}}<br />\
                {{#contact.city}}{{contact.city}},{{/contact.city}}\
                {{#contact.state}} {{contact.state}}{{/contact.state}}\
                {{#contact.zip}} {{contact.zip}}<br />{{/contact.zip}}\
                {{#contact.email}}{{contact.email}}<br />{{/contact.email}}\
                {{#contact.phone}}{{contact.phone}}{{/contact.phone}}\
            </p>\
            {{/contact.address_1}}\
            {{#application_url}}<a class="link-tertiary" href="{{application_url}}" target="_blank" rel="nofollow" >Scholarship Application</a>{{/application_url}}\
        </div>\
    </div>';

// Result Count
scholarships_search.addWidget(
    instantsearch.widgets.stats({
        container: '#algolia-count',
        templates: {
            body: '{{nbHits}} Results'
        }
    })
);

// Pagination
scholarships_search.addWidget(
    instantsearch.widgets.pagination({
        container: '#algolia-pagination',
        scrollTo: '.algolia-scholarships',
        labels: {
            first: 'First',
            previous: 'Previous',
            next: 'Next',
            last: 'Last'
        },
        padding: 2,
        cssClasses: {
            root: 'pagination',
            disabled: 'pagination-disabled',
            active: 'pagination-active'
        }
    })
);

// Filters: clear all
scholarships_search.addWidget(
    instantsearch.widgets.clearAll({
        container: '#algolia-clearAll',
        cssClasses: {
            link: 'btn btn-secondary',
        },
        templates: {
            link: 'Clear All Filters'
        },
        autoHideContainer: true
    })
);


// Result display
scholarships_search.addWidget(
    instantsearch.widgets.hits({
        container: '#algolia-hits',
        templates: {
            empty: 'Sorry, no results found.',
            item: template
        },
        transformData: {
            item: sanitize_scholarship
        },
        hitsPerPage: hitsPerPage
    })
);


// Filters: Search by name/city
scholarships_search.addWidget(
    instantsearch.widgets.searchBox({
        container: '#algolia-searchBox',
        autofocus: false
    })
);

// Filters: classes for groups of filters
var dropdownClasses = {
    root: 'filter-expand',
    header: 'filter-expand-header',
    body: 'filter-expand-body',
    item: 'filter-expand-item',
    active: 'active',
    count: 'filter-count'
};

var toggleClasses = {
    count: 'filter-count',
    active: 'active'
};

// Filters: States
scholarships_search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#algolia-refinementList-state',
        attributeName: 'states',
        operator: 'or',
        sortBy: ['name:asc', 'count:desc'],
        limit: 99,
        cssClasses: dropdownClasses,
        collapsible: {
            collapsed: false
        },
        transformData: {
            item: stateAbbrToName
        }
    })
);

// Filters: Races
scholarships_search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#algolia-refinementList-races',
        attributeName: 'races',
        operator: 'or',
        sortBy: ['name:asc', 'count:desc'],
        limit: 99,
        cssClasses: dropdownClasses,
        collapsible: {
            collapsed: false
        }
    })
);

// Filters: Min GPA
scholarships_search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#algolia-refinementList-min_gpa',
        attributeName: 'min_gpa',
        operator: 'or',
        sortBy: ['name:desc', 'count:desc'],
        limit: 99,
        cssClasses: dropdownClasses,
        collapsible: {
            collapsed: false
        },
        transformData: {
            item: minGPALabel
        }
    })
);

// Filters: Enrollment Levels
scholarships_search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#algolia-refinementList-enroll_level',
        attributeName: 'enrollment_levels',
        operator: 'or',
        sortBy: ['name:asc', 'count:desc'],
        limit: 99,
        cssClasses: dropdownClasses,
        collapsible: {
            collapsed: false
        }
    })
);

{% endraw %}

// Filters: Toggles
var toggleFacets = {
    'study_areas' : {
        'accounting': 'Accounting',
        'agriculture' : 'Agriculture',
        'Art' : 'Art',
        'biology' : 'Biology',
        'business' : 'Business',
        'criminal justice' : 'Criminal Justice',
        'computer science' : 'Criminal Justice',
        'education' : 'Education',
        'engineering' : 'Engineering',
        'engineering' : 'Engineering',
        'English' : 'English',
        'finance' : 'Finance',
        'general' : 'General',
        'journalism' : 'Journalism',
        'law' : 'Law',
        'medicine' : 'Medicine',
        'music' : 'Music',
        'nursing' : 'Nursing',
        'occupational therapy' : 'Occupational Therapy',
        'psychology' : 'Psychology',
        'science' : 'Science',
    },
    'renewable' : {
        'Y' : 'Yes',
        'N' : 'No',
    },
    'sponsor.is_school' : {
        'Y' : 'Yes',
        'N' : 'No',
    }
};

// If User defined study_areas isn't included, include it in filters.
if (studyAreas) {
    studyAreasArray = studyAreas.split("|");
    for (var key in studyAreasArray) {
        if (!toggleFacets.study_areas[studyAreasArray[key]]) {
            toggleFacets.study_areas[studyAreasArray[key]] = capitlizedWords(studyAreasArray[key]);
        }
    }
}

// Loop Toggle Facets.
for (var facet in toggleFacets) {

    // If empty, skip.
    if (Object.keys(toggleFacets[facet]).length === 0) {
        continue;
    }

    // Selector Container.
    parentID = 'algolia-toggleList-' + facet.replace(/\.|\s/gi, '-');

    // Loop Facet Filters. 
    for (var filter in toggleFacets[facet]) {

        // Create Child DOM Element.
        var toggle       = document.createElement('div');
        toggle.id        = 'algolia-toggle-' + filter.replace(/\.|\s/gi, '-');
        toggle.className = 'check-button';

        // Append Dom Child Element to Selector Container.
        document.getElementById(parentID).appendChild(toggle);

        // Run toggle widget.
        scholarships_search.addWidget(
            instantsearch.widgets.toggle({
                container: '#' + parentID + ' #' + toggle.id,
                attributeName: facet,
                label: toggleFacets[facet][filter],
                values: {
                    on: filter
                },
                cssClasses: toggleClasses
            })
        );
    }
}

scholarships_search.addWidget(
    instantsearch.widgets.currentRefinedValues({
        container: '#algolia-currentRefinedValues',
        clearAll: false,
        transformData: {
            item: formatRefineValues
        },
        templates: {
            header: 'Filtering By:'
        },
        attributes: [
        { name: 'states', }, 
        { name: 'study_areas', }, 
        { name: 'renewable', }, 
        { name: 'min_gpa', }, 
        { name: 'sponsor.is_school', }, 
        { name: 'races', }, 
        { name: 'enrollment_levels', }
        ],        
        onlyListedAttributes: true
    })
);

scholarships_search.start() 

</script>