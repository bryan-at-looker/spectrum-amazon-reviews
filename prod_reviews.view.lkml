view: reviews {
  sql_table_name: prod.reviews ;;

  dimension: review_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.review_id ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: helpful_votes {
    type: number
    sql: ${TABLE}.helpful_votes ;;
  }

  dimension: marketplace {
    type: string
    sql: ${TABLE}.marketplace ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_parent {
    type: string
    sql: ${TABLE}.product_parent ;;
  }

  dimension: product_title {
    type: string
    sql: ${TABLE}.product_title ;;
  }

  dimension: review_body {
    type: string
    sql: ${TABLE}.review_body ;;
  }

  dimension: review_headline {
    type: string
    sql: ${TABLE}.review_headline ;;
  }

  dimension: review_date {
    group_label: "Review Date"
    group_item_label: "Date"
    label: "Review Date"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.review_date ;;
  }

  dimension: review_date_raw {
    group_label: "Review Date Raw"
    group_item_label: "Date Raw"
    label: "Review Date Raw"
    type: date_raw
    sql: ${TABLE}.review_date ;;
  }

  dimension_group: review {
    type: time
    timeframes: [
      raw,
      time,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.review_time ;;
  }

  dimension: star_rating {
    type: number
    sql: ${TABLE}.star_rating ;;
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

  measure: average_stars {
    type: average
    sql: 1.00000*${star_rating} ;;
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

  dimension: total_votes {
    type: number
    sql: ${TABLE}.total_votes ;;
  }

  dimension: verified_purchase {
    type: string
    sql: ${TABLE}.verified_purchase ;;
  }

  dimension: vine {
    type: string
    sql: ${TABLE}.vine ;;
  }

  measure: review_count {
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
    filters: { field: verified_purchase value: "Yes"}
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
    type: date
    description: "Use this filter for period analysis"
    sql: ${previous_period} IS NOT NULL ;;
    convert_tz: no
  }

  dimension: previous_period {
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
  # } Previous Period End

}
