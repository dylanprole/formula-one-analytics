with

source as (

      select * from {{ source('bronze', 'drivers') }}

),

renamed as (
    
    select

        -- ids
        {{ adapter.quote("driverId") }} as driver_id,

        -- strings
        {{ adapter.quote("driverRef") }} as driver_ref,
        {{ adapter.quote("code") }} as driver_code,
        {{ adapter.quote("forename") }} as first_name,
        {{ adapter.quote("surname") }} as last_name,
        {{ adapter.quote("nationality") }} as driver_nationality,
        {{ adapter.quote("url") }} as driver_url,

        -- numerics
        {{ adapter.quote("number") }} as driver_number,

        -- booleans

        -- dates
        {{ adapter.quote("dob") }} as driver_date_of_birth

        -- timestamps

    from source

)

select * from renamed
  