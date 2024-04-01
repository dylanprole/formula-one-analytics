with

source as (

      select * from {{ source('bronze', 'races') }}

),

renamed as (

    select

        -- ids
        {{ adapter.quote("raceId") }} as race_id,
        {{ adapter.quote("circuitId") }} as circuit_id,
        
        -- strings
        {{ adapter.quote("name") }} as circuit_name,
        {{ adapter.quote("url") }} as race_url,

        -- numerics
        {{ adapter.quote("year") }} as race_year,
        {{ adapter.quote("round") }} as season_round,

        -- booleans

        -- dates
        {{ adapter.quote("date") }} as race_date,
        {{ adapter.quote("fp1_date") }} as fp1_date,
        {{ adapter.quote("fp2_date") }} as fp2_date,
        {{ adapter.quote("fp3_date") }} as fp3_date,
        {{ adapter.quote("quali_date") }} as quali_date,
        {{ adapter.quote("sprint_date") }} as sprint_date,

        -- timestamps
        {{ adapter.quote("time") }} as race_time,
        {{ adapter.quote("fp1_time") }} as fp1_time,
        {{ adapter.quote("fp2_time") }} as fp2_time,
        {{ adapter.quote("fp3_time") }} as fp3_time,
        {{ adapter.quote("quali_time") }} as quali_time,
        {{ adapter.quote("sprint_time") }} as sprint_time

    from source

)

select * from renamed
  