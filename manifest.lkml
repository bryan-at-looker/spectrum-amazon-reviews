project_name: "spectrum-amazon-reviews"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }

constant: drill_link_listener {
  # hidden drill link to listen to current filters
  value: "reviews.drill_link_listener._link"
}

constant: path {
  value: "/explore/{{_model._name}}/{{_explore._name}}"
}


constant: find_filters {
  value: "
  {% assign query_array = @{drill_link_listener} | split: '&' %}
  {% assign filters = '' %}
  {% for qs in query_array %}
  {% assign qs_check = qs | slice: 0,2 %}
  {% if qs_check contains 'f[' %}
  {% assign filters = filters | append: '&' | append: qs %}
  {% endif %}
  {% endfor %}
  {{ filters }}"
}

constant: star_vis_config {
  value: "%7B%22color_application%22%3A%7B%22collection_id%22%3A%221b2bd731-3f09-443a-a06d-504174f4d897%22%2C%22palette_id%22%3A%22ee300d79-e6d8-4bad-a8b5-b43657b78590%22%7D%2C%22show_view_names%22%3Afalse%2C%22show_row_numbers%22%3Afalse%2C%22truncate_column_names%22%3Afalse%2C%22hide_totals%22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22table_theme%22%3A%22gray%22%2C%22limit_displayed_rows%22%3Afalse%2C%22enable_conditional_formatting%22%3Atrue%2C%22conditional_formatting%22%3A%5B%7B%22type%22%3A%22along+a+scale...%22%2C%22value%22%3Anull%2C%22background_color%22%3A%22%23ff9900%22%2C%22font_color%22%3Anull%2C%22color_application%22%3A%7B%22collection_id%22%3A%221b2bd731-3f09-443a-a06d-504174f4d897%22%2C%22palette_id%22%3A%224e09fc09-ab13-4ca7-a7ee-cc664d416b76%22%2C%22options%22%3A%7B%22steps%22%3A5%2C%22reverse%22%3Afalse%2C%22stepped%22%3Afalse%2C%22mirror%22%3Afalse%7D%7D%2C%22bold%22%3Afalse%2C%22italic%22%3Afalse%2C%22strikethrough%22%3Afalse%2C%22fields%22%3A%5B%22reviews.reviews_per_customer%22%5D%7D%5D%2C%22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls%22%3Afalse%2C%22type%22%3A%22table%22%2C%22series_types%22%3A%7B%7D%7D"
}

constant: star_breakdown_drill_fields {
  value: "@{path}?@{find_filters}&fields=reviews.star_rating_image,reviews.product_count,reviews.review_count,reviews.customer_count,reviews.reviews_per_customer&@{star_vis_config}&sorts=reviews.star_rating_image&total=on&vis=@{star_vis_config}"
}
