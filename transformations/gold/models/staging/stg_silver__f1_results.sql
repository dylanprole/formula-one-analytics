with

source as (

      select * from {{ source('silver', 'f1_results') }}

),

renamed as (

    select

        {{ adapter.quote("race_year") }} as season,	
        {{ adapter.quote("race_date") }},	
        {{ adapter.quote("season_round") }},	
        {{ adapter.quote("circuit_name") }},	
        {{ adapter.quote("position") }},	
        {{ adapter.quote("points") }},	
        {{ adapter.quote("grid_number") }},	
        {{ adapter.quote("driver_name") }} as driver,	
        {{ adapter.quote("driver_nationality") }},	
        {{ adapter.quote("driver_date_of_birth") }},	
        {{ adapter.quote("constructor_name") }} as constructor,	
        {{ adapter.quote("constructor_nationality") }},	
        {{ adapter.quote("status_description") }},	
        {{ adapter.quote("fastest_lap_rank") }},	
        {{ adapter.quote("fastest_lap") }},

    from source

)

select * from renamed
  