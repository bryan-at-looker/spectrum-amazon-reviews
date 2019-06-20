view: reviews_raw {
  sql_table_name: spectrum_schema.parquet ;;

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

  dimension_group: review {
    type: time
    timeframes: [
      raw,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.review_date ;;
  }

  dimension_group: review_time {
    type: time
    timeframes: [raw, time]
    sql: DATEADD(years,5,DATEADD(milliseconds, MOD(STRTOL(LEFT(MD5(${customer_id}),15),16)+STRTOL(LEFT(MD5(${product_id}),15),16),86400000), ${review_raw})) ;;
  }

  dimension: review_date {
    type: date
    sql: ${review_time_time::date} ;;

  }

  dimension: review_headline {
    type: string
    sql: ${TABLE}.review_headline ;;
  }

  dimension: review_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.review_id ;;
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
    type: yesno
    sql: ${TABLE}.verified_purchase = 'Y' ;;
  }

  dimension: vine {
    type: yesno
    sql: ${TABLE}.vine = 'Y' ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
