view: reviews {
  sql_table_name: prod.reviews ;;

  dimension: review_id {
    group_label: "IDs"
    primary_key: yes
    type: string
    sql: ${TABLE}.review_id ;;
  }

  dimension: customer_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: helpful_votes {
    group_label: "Votes"
    type: number
    sql: ${TABLE}.helpful_votes ;;
  }

  dimension: marketplace {
    group_label: "Product Details"
    type: string
    sql: ${TABLE}.marketplace ;;
  }

  dimension: product_category {
    group_label: "Product Details"
    type: string
    sql: REPLACE(${TABLE}.product_category,'_',' ') ;;
  }

  dimension: product_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.product_id ;;
    link: {
      label: "View on Amazon"
      url: "https://www.amazon.com/dp/{{value}}"
    }
  }

  dimension: product_parent {
    group_label: "Product Details"
    type: string
    sql: ${TABLE}.product_parent ;;
  }

  dimension: product_title {
    group_label: "Product Details"
    type: string
    sql: ${TABLE}.product_title ;;
  }

  dimension: review_body {
    group_label: "Review Details"
    type: string
    sql: ${TABLE}.review_body ;;
  }

  dimension: review_headline {
    group_label: "Review Details"
    type: string
    sql: ${TABLE}.review_headline ;;
  }

  dimension: review_date {
    view_label: "2) Dates"
    group_label: "Review Date"
    group_item_label: "Date"
    label: "Review Date"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.review_date ;;
  }

  dimension: review_date_raw {
    view_label: "2) Dates"
    group_label: "Review Date Raw"
    group_item_label: "Date Raw"
    label: "Review Date Raw"
    type: date_raw
    sql: ${TABLE}.review_date ;;
  }

  dimension_group: review {
    view_label: "2) Dates"
    type: time
    timeframes: [
      raw,
      time,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.review_time ;;
  }

  measure: min_review_date {
    view_label: "2) Dates"
    type: date_raw
    sql: MIN(${review_raw}) ;;
  }

  measure: max_review_date {
    view_label: "2) Dates"
    type: date_raw
    sql: MIN(${review_raw}) ;;
  }

  dimension: star_rating {
    group_label: "Review Details"
    type: number
    sql: ${TABLE}.star_rating ;;
    value_format_name: decimal_0
    html:
    <div>
    {% for i in (0..4) %}
    {% assign full= i | plus: 0.75 %}
    {% assign half= i | plus:  0.25 %}
    {% if value > full %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_star.png"/>
    {% elsif value > half %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_half_star.png"/>
    {% else %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_no_star.png"/>
    {% endif %}
    {% endfor %}
    <br/>{{rendered_value}}
    </div>
    ;;
  }

  measure: average_stars {
    group_label: "Average Stars"
    group_item_label: "Average Stars"
    type: average
    sql: 1.00000*${star_rating} ;;
    value_format_name: decimal_2
  }

  measure: average_stars_image {
    group_label: "Average Stars"
    group_item_label: "With Image"
    type: average
    sql: 1.00000*${star_rating} ;;
    value_format_name: decimal_2
    html:
    {% for i in (0..4) %}
    {% assign full= i | plus: 0.75 %}
    {% assign half= i | plus:  0.25 %}
    {% if value > full %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_star.png"/>
    {% elsif value > half %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_half_star.png"/>
    {% else %}
    <img src="https://bryan-at-looker.s3.amazonaws.com/misc/amazon_no_star.png"/>
    {% endif %}
    {% endfor %}
    ;;
  }

  dimension: votes {
    group_label: "Votes"
    type: number
    sql: ${TABLE}.total_votes ;;
  }

  dimension: is_verified_purchase {
    group_label: "Review Details"
    type: yesno
    sql: ${TABLE}.verified_purchase ;;
  }

  dimension: is_vine {
    group_label: "Review Details"
    type: yesno
    sql: ${TABLE}.vine ;;
  }

  measure: review_count {
    group_label: "Review Count"
    group_item_label: "Count"
    label: "Review Count"
    type: count
    drill_fields: [review_id]
  }

  measure: reviews_per_customer {
    type: number
    sql: ${review_count}::float / ${customer_count} ;;
    value_format_name: decimal_2
  }

  measure: verified_purchase_review_count {
    type: count
    filters: { field: is_verified_purchase value: "Yes"}
    drill_fields: [review_id]
  }

  measure: customer_count {
    type: count_distinct
    sql: ${customer_id} ;;
    drill_fields: [review_id]
  }

  measure: product_count {
    type: count_distinct
    sql: ${product_id} ;;
    drill_fields: [review_id]
  }

  # Previous Period {
  filter: previous_period_filter {
    default_value: "1 days"
    view_label: "2) Dates"
    type: date
    description: "Use this filter for period analysis"
    sql: ${previous_period} IS NOT NULL ;;
    convert_tz: no
  }

  dimension: previous_period {
    view_label: "2) Dates"
    type: string
    suggestions: ["This Period","Previous Period","Has Value","Is Null","In Period","Not In Period"]
    description: "The reporting period as selected by the Previous Period Filter"
    sql:
        CASE
          WHEN {% date_start previous_period_filter %} is not null AND {% date_end previous_period_filter %} is not null /* date ranges or in the past x days */
            THEN
              CASE
                WHEN ${review_date_raw} >=  {% date_start previous_period_filter %}
                  AND  ${review_date_raw} <= {% date_end previous_period_filter %}
                  THEN 'This Period'
                WHEN  ${review_date_raw} >= DATEADD(day,-1*DATEDIFF(day,{% date_start previous_period_filter %}, {% date_end previous_period_filter %} ) + 1, DATEADD(day,-1,{% date_start previous_period_filter %} ) )
                  AND  ${review_date_raw} < DATEADD(day,-1,{% date_start previous_period_filter %} ) + 1
                  THEN 'Previous Period'
              END
          WHEN {% date_start previous_period_filter %} is null AND {% date_end previous_period_filter %} is null /* has any value or is not null */
            THEN CASE WHEN  ${review_date_raw} is not null THEN 'Has Value' ELSE 'Is Null' END
          WHEN {% date_start previous_period_filter %} is null AND {% date_end previous_period_filter %} is not null /* on or before */
            THEN
              CASE
                WHEN ${review_date_raw} <=  {% date_end previous_period_filter %} THEN 'In Period'
                WHEN ${review_date_raw} >   {% date_end previous_period_filter %} THEN 'Not In Period'
              END
         WHEN {% date_start previous_period_filter %} is not null AND {% date_end previous_period_filter %} is null /* on or after */
           THEN
             CASE
               WHEN  ${review_date_raw} >= {% date_start previous_period_filter %} THEN 'In Period'
               WHEN ${review_date_raw} < {% date_start previous_period_filter %} THEN 'Not In Period'
            END
        END ;;
  }

  measure: average_stars_previous_period {
    group_label: "Average Stars"
    group_item_label: "Period Analysis (Previous Period)"
    type: average
    sql: 1.00000*${star_rating} ;;
    value_format_name: decimal_2
    filters: { field: previous_period value: "Previous Period" }
  }

  measure: average_stars_this_period {
    group_label: "Average Stars"
    group_item_label: "Period Analysis (This Period)"
    type: average
    sql: 1.00000*${star_rating} ;;
    value_format_name: decimal_2
    filters: { field: previous_period value: "This Period" }
  }

  measure: average_stars_trending {
    group_label: "Average Stars"
    group_item_label: "Period Analysis (Trends)"
    type: number
    sql: ${average_stars_this_period} - ${average_stars_previous_period} ;;
    value_format: "[>=-0.005]+0.000\" stars\";-0.000\" stars\""
  }

  measure: review_count_previous_period {
    group_label: "Review Count"
    group_item_label: "Period Analysis (Previous Period)"
    type: count
    value_format_name: decimal_0
    filters: { field: previous_period value: "Previous Period" }
  }

  measure: review_count_this_period {
    group_label: "Review Count"
    group_item_label: "Period Analysis (This Period)"
    type: count
    value_format_name: decimal_0
    filters: { field: previous_period value: "This Period" }
  }

  measure: review_count_trending {
    group_label: "Review Count"
    group_item_label: "Period Analysis (Trends)"
    type: number
    sql: 1.0000*${review_count_this_period} / ${review_count_previous_period} - 1 ;;
    value_format_name: percent_2
  }

  # } Previous Period End

}
