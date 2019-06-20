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

#   dimension: review {
#     group_label: "Review Date"
#     group_item_label: "Date"
#     label: "Review Date"
#     type: date
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}.review_date ;;
#   }

  dimension: review_headline {
    type: string
    sql: ${TABLE}.review_headline ;;
  }

  dimension_group: review {
    type: time
    timeframes: [
      raw,
      date,
      time,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.review_time ;;
  }

  dimension: star_rating {
    type: number
    sql: ${TABLE}.star_rating ;;
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

}
